import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaabsa/api/me/request/login_request.dart';
import 'package:yaabsa/api/me/server.dart';
import 'package:yaabsa/api/me/status.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverAddressController = useTextEditingController();
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final apiKeyController = useTextEditingController();

    final isLoading = useState(false);
    final useApiKey = useState(false);
    final isStatusLoading = useState(false);
    final errorMessage = useState<String?>(null);
    final status = useState<ServerStatus?>(null);
    final statusError = useState<String?>(null);
    final lastCheckedServer = useState<String?>(null);
    final statusDebounce = useRef<Timer?>(null);
    final statusCancelToken = useRef<CancelToken?>(null);

    final currentUser = ref.watch(currentUserProvider).value;
    useEffect(() {
      if (currentUser?.server?.url != null && serverAddressController.text.isEmpty) {
        _setControllerTextKeepingCursor(serverAddressController, currentUser!.server!.url);
      }
      return null;
    }, [currentUser]);

    Future<ServerStatus?> fetchStatus({required bool showErrors}) async {
      if (showErrors) {
        errorMessage.value = null;
      }

      final normalizedServer = _normalizeServerAddress(serverAddressController.text.trim());
      if (normalizedServer == null) {
        if (showErrors) {
          statusError.value = 'Please enter a valid server address.';
        }
        status.value = null;
        lastCheckedServer.value = null;
        return null;
      }

      statusCancelToken.value?.cancel('Superseded by a newer address check');
      final cancelToken = CancelToken();
      statusCancelToken.value = cancelToken;

      isStatusLoading.value = true;
      statusError.value = null;

      try {
        final response = await ABSApi(
          basePathOverride: normalizedServer,
        ).getMeApi().getStatus(cancelToken: cancelToken);
        final fetchedStatus = response.data;

        if (fetchedStatus == null) {
          if (showErrors) {
            statusError.value = 'Server status request returned no data.';
          }
          return null;
        }

        final isAudiobookshelf = fetchedStatus.app.toLowerCase() == 'audiobookshelf';
        if (!isAudiobookshelf) {
          if (showErrors) {
            statusError.value = 'Server is reachable, but it is not an Audiobookshelf server.';
          }
          status.value = null;
          lastCheckedServer.value = null;
          return null;
        }

        status.value = fetchedStatus;
        lastCheckedServer.value = normalizedServer;
        statusError.value = null;
        return fetchedStatus;
      } on DioException catch (e) {
        if (!CancelToken.isCancel(e)) {
          if (showErrors) {
            statusError.value = _parseDioErrorMessage(e, fallback: 'Failed to fetch server status.');
          }
        }
      } catch (e) {
        if (showErrors) {
          statusError.value = 'Failed to fetch server status: $e';
        }
      } finally {
        if (identical(statusCancelToken.value, cancelToken)) {
          isStatusLoading.value = false;
          statusCancelToken.value = null;
        }
      }

      return null;
    }

    Future<ServerStatus?> ensureStatusForServer(String normalizedServer, {required bool showErrors}) async {
      if (status.value != null && lastCheckedServer.value == normalizedServer) {
        return status.value;
      }
      return fetchStatus(showErrors: showErrors);
    }

    Future<void> validateAndSignIn() async {
      errorMessage.value = null;

      final normalizedServer = _normalizeServerAddress(serverAddressController.text.trim());
      if (normalizedServer == null) {
        errorMessage.value = 'Please enter a valid server address.';
        return;
      }
      _setControllerTextKeepingCursor(serverAddressController, normalizedServer);

      final currentStatus = await ensureStatusForServer(normalizedServer, showErrors: true);
      if (currentStatus == null) {
        errorMessage.value = statusError.value ?? 'Unable to verify server status.';
        return;
      }

      final allowsLocal = currentStatus.authMethods.contains('local');
      if (!useApiKey.value && !allowsLocal) {
        errorMessage.value = 'Local login is disabled on this server. Use OpenID Connect instead.';
        return;
      }

      isLoading.value = true;

      try {
        late final User loggedInUser;

        if (useApiKey.value) {
          final apiKey = apiKeyController.text.trim();
          if (apiKey.isEmpty) {
            errorMessage.value = 'API key is required.';
            return;
          }

          logger('Attempting API key auth against server: $normalizedServer', tag: 'SignIn');

          final api = ABSApi(basePathOverride: normalizedServer);
          api.setBearerAuth('BearerAuth', apiKey);
          final userResponse = await api.getMeApi().getUser();
          final userData = userResponse.data;
          if (userData == null) {
            errorMessage.value = 'API key authentication failed: Invalid response.';
            return;
          }

          loggedInUser = userData.copyWith(apiKey: apiKey);
        } else {
          final username = usernameController.text.trim();
          final password = passwordController.text;

          if (username.isEmpty || password.isEmpty) {
            errorMessage.value = 'Username and password are required.';
            return;
          }

          logger('Attempting login to server: $normalizedServer with username: $username', tag: 'SignIn');

          final apiResponse = await ABSApi(basePathOverride: normalizedServer).getMeApi().login(
            loginRequest: LoginRequest(username: username, password: password),
            returnTokens: true,
          );

          final loginData = apiResponse.data;

          if (loginData == null) {
            errorMessage.value = 'Login failed: Invalid response from server.';
            return;
          }

          loggedInUser = loginData.user;
        }

        final serverUri = Uri.parse(normalizedServer);
        final db = ref.read(appDatabaseProvider);
        await db.addOrUpdateStoredUser(
          loggedInUser.copyWith(
            server: Server(host: serverUri.host, port: serverUri.port, ssl: serverUri.scheme == 'https'),
          ),
        );
        await db.setActiveUserId(loggedInUser.id);

        ref.invalidate(allStoredUsersProvider);
        ref.invalidate(currentUserProvider);

        if (!context.mounted) return;
        context.go('/');
      } on DioException catch (e) {
        errorMessage.value = _parseDioErrorMessage(e, fallback: 'Login failed.');
      } catch (e) {
        errorMessage.value = 'Login failed: $e';
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> startOpenIdConnect() async {
      errorMessage.value = null;

      final normalizedServer = _normalizeServerAddress(serverAddressController.text.trim());
      if (normalizedServer == null) {
        errorMessage.value = 'Please enter a valid server address first.';
        return;
      }
      _setControllerTextKeepingCursor(serverAddressController, normalizedServer);

      final currentStatus = await ensureStatusForServer(normalizedServer, showErrors: true);
      if (currentStatus == null) {
        errorMessage.value = statusError.value ?? 'Unable to verify server status.';
        return;
      }

      final allowsOpenId = currentStatus.authMethods.contains('openid');
      if (!allowsOpenId) {
        errorMessage.value = 'OpenID Connect is not enabled on this server.';
        return;
      }

      final codeVerifier = _generateCodeVerifier();
      final state = _randomBase64Url(24);
      final codeChallenge = _toBase64UrlNoPadding(sha256.convert(utf8.encode(codeVerifier)).bytes);

      final authUri = Uri.parse('$normalizedServer/auth/openid').replace(
        queryParameters: {
          'code_challenge': codeChallenge,
          'code_challenge_method': 'S256',
          'redirect_uri': 'yaabsa://oauth',
          'client_id': 'Yaabsa',
          'response_type': 'code',
          'state': state,
        },
      );

      logger('Launching OpenID endpoint: $authUri', tag: 'SignIn');
      final launched = await launchUrl(authUri, mode: LaunchMode.externalApplication);

      if (!launched && context.mounted) {
        errorMessage.value = 'Could not open the OpenID login page.';
        return;
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OpenID flow opened in your browser. Finish sign-in there and return to the app.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    useEffect(() {
      void onServerChanged() {
        final normalized = _normalizeServerAddress(serverAddressController.text.trim());

        statusDebounce.value?.cancel();

        if (normalized == null) {
          statusCancelToken.value?.cancel('Input became invalid');
          status.value = null;
          statusError.value = null;
          lastCheckedServer.value = null;
          isStatusLoading.value = false;
          return;
        }

        statusDebounce.value = Timer(const Duration(milliseconds: 500), () {
          final latest = _normalizeServerAddress(serverAddressController.text.trim());
          if (latest == null) return;
          if (latest == lastCheckedServer.value && status.value != null) return;
          fetchStatus(showErrors: false);
        });
      }

      serverAddressController.addListener(onServerChanged);
      return () {
        serverAddressController.removeListener(onServerChanged);
        statusDebounce.value?.cancel();
        statusCancelToken.value?.cancel('Sign-in view disposed');
      };
    }, [serverAddressController]);

    final activeStatus = status.value;
    final allowsLocal = activeStatus == null || activeStatus.authMethods.contains('local');
    final allowsOpenId = activeStatus?.authMethods.contains('openid') ?? false;
    const allowsApiKey = true;
    final customMessage = activeStatus?.authFormData?.authLoginCustomMessage;
    final openIdButtonText = activeStatus?.authFormData?.authOpenIDButtonText ?? 'Continue with OpenID Connect';

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -70,
            child: _GlowOrb(size: 250, color: colorScheme.primary.withValues(alpha: 0.16)),
          ),
          Positioned(
            bottom: -90,
            left: -55,
            child: _GlowOrb(size: 220, color: colorScheme.tertiary.withValues(alpha: 0.14)),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Card(
                    elevation: 1,
                    shadowColor: colorScheme.shadow.withValues(alpha: 0.08),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.96),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Yaabsa',
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Sign in to your Audiobookshelf server',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 22),
                          TextField(
                            controller: serverAddressController,
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(
                              labelText: 'Server Address',
                              hintText: 'https://your-audiobookshelf.example',
                              prefixIcon: const Icon(Icons.dns_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (isStatusLoading.value)
                            Row(
                              children: [
                                SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onSurfaceVariant),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Checking server...',
                                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            )
                          else if (activeStatus != null)
                            Row(
                              children: [
                                Icon(Icons.check_circle_rounded, size: 16, color: colorScheme.primary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Valid Audiobookshelf server (v${activeStatus.serverVersion})',
                                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                                  ),
                                ),
                              ],
                            )
                          else if (statusError.value != null)
                            Text(statusError.value!, style: textTheme.bodySmall?.copyWith(color: colorScheme.error)),
                          if (customMessage != null && customMessage.trim().isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              customMessage,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                            ),
                          ],
                          if (allowsApiKey) ...[
                            const SizedBox(height: 14),
                            SwitchListTile.adaptive(
                              value: useApiKey.value,
                              contentPadding: EdgeInsets.zero,
                              onChanged: isLoading.value
                                  ? null
                                  : (value) {
                                      useApiKey.value = value;
                                      errorMessage.value = null;
                                    },
                              title: const Text('Use API Key'),
                              subtitle: const Text(
                                'Authenticate with a generated API key instead of username/password.',
                              ),
                            ),
                          ],
                          if (useApiKey.value) ...[
                            const SizedBox(height: 12),
                            TextField(
                              controller: apiKeyController,
                              enabled: !isLoading.value,
                              obscureText: true,
                              onSubmitted: (_) => validateAndSignIn(),
                              decoration: InputDecoration(
                                labelText: 'API Key',
                                prefixIcon: const Icon(Icons.key_rounded),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            const SizedBox(height: 14),
                            FilledButton.icon(
                              onPressed: isLoading.value ? null : validateAndSignIn,
                              icon: isLoading.value
                                  ? SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary),
                                    )
                                  : const Icon(Icons.vpn_key_rounded),
                              label: Text(isLoading.value ? 'Signing in...' : 'Connect with API Key'),
                            ),
                          ] else if (allowsLocal) ...[
                            const SizedBox(height: 18),
                            TextField(
                              controller: usernameController,
                              enabled: !isLoading.value,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                prefixIcon: const Icon(Icons.person_outline_rounded),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: passwordController,
                              enabled: !isLoading.value,
                              obscureText: true,
                              onSubmitted: (_) => validateAndSignIn(),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.password_rounded),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            const SizedBox(height: 14),
                            FilledButton.icon(
                              onPressed: isLoading.value ? null : validateAndSignIn,
                              icon: isLoading.value
                                  ? SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary),
                                    )
                                  : const Icon(Icons.login_rounded),
                              label: Text(isLoading.value ? 'Signing in...' : 'Sign In'),
                            ),
                          ],
                          if (!useApiKey.value && allowsOpenId) ...[
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: isLoading.value ? null : startOpenIdConnect,
                              icon: const Icon(Icons.shield_outlined),
                              label: Text(openIdButtonText),
                            ),
                          ],
                          if (!useApiKey.value && !allowsLocal && !allowsOpenId) ...[
                            const SizedBox(height: 12),
                            Text(
                              'No supported authentication method is enabled on this server.',
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                            ),
                          ],
                          if (errorMessage.value != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              errorMessage.value!,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0.0)]),
        ),
      ),
    );
  }
}

String? _normalizeServerAddress(String input) {
  if (input.isEmpty) return null;

  final withScheme = input.contains('://') ? input : 'https://$input';
  final uri = Uri.tryParse(withScheme);

  if (uri == null || uri.host.isEmpty) {
    return null;
  }

  final normalized = uri.replace(path: '', query: null, fragment: null).toString();
  return normalized.endsWith('/') ? normalized.substring(0, normalized.length - 1) : normalized;
}

String _parseDioErrorMessage(DioException exception, {required String fallback}) {
  final responseData = exception.response?.data;

  if (responseData is Map<String, dynamic>) {
    final message = responseData['message']?.toString() ?? responseData['error']?.toString();
    if (message != null && message.isNotEmpty) {
      return message;
    }
  }

  if (responseData is String && responseData.trim().isNotEmpty) {
    return responseData;
  }

  if ((exception.message ?? '').isNotEmpty) {
    return exception.message!;
  }

  return fallback;
}

String _generateCodeVerifier() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
  final random = Random.secure();
  return List.generate(64, (_) => chars[random.nextInt(chars.length)]).join();
}

String _randomBase64Url(int bytes) {
  final random = Random.secure();
  final data = List<int>.generate(bytes, (_) => random.nextInt(256));
  return _toBase64UrlNoPadding(data);
}

String _toBase64UrlNoPadding(List<int> data) {
  return base64Url.encode(data).replaceAll('=', '');
}

void _setControllerTextKeepingCursor(TextEditingController controller, String text) {
  if (controller.text == text) return;
  controller.value = controller.value.copyWith(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
    composing: TextRange.empty,
  );
}
