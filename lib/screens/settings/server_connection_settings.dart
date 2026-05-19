import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/me/request/login_request.dart';
import 'package:yaabsa/api/me/server.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/network/dio_factory.dart';

import 'package:yaabsa/generated/l10n.dart';

// TODO. Change view
class ServerConnectionSettings extends ConsumerStatefulWidget {
  const ServerConnectionSettings({super.key});

  static const String routeName = '/settings/server-connection';

  @override
  ConsumerState<ServerConnectionSettings> createState() => _ServerConnectionSettingsState();
}

class _ServerConnectionSettingsState extends ConsumerState<ServerConnectionSettings> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _externalServerController;
  late final TextEditingController _localServerController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  bool _isSaving = false;
  bool _obscurePassword = true;
  String? _initializedForUserId;

  @override
  void initState() {
    super.initState();
    _externalServerController = TextEditingController();
    _localServerController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _externalServerController.dispose();
    _localServerController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _initializeFromUser(User user) {
    if (_initializedForUserId == user.id) {
      return;
    }

    _initializedForUserId = user.id;
    _externalServerController.text = user.server?.externalUrl ?? '';
    _localServerController.text = user.server?.localUrl ?? '';
    _usernameController.text = user.username;
    _passwordController.clear();
  }

  ABSApi _buildServerApi(String baseUrl, {Map<String, String>? serverHeaders}) {
    return ABSApi(
      dio: createNativeDio(
        options: BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 3000),
          headers: serverHeaders,
        ),
      ),
      basePathOverride: baseUrl,
    );
  }

  Server _buildUpdatedServer(User user, {required String externalUrl, required String? localUrl}) {
    final previousConnection = user.server?.activeConnection ?? ServerConnection.external;
    final nextConnection = previousConnection == ServerConnection.local && localUrl != null
        ? ServerConnection.local
        : ServerConnection.external;

    return Server.fromExternalAddress(
      externalAddress: externalUrl,
      localAddress: localUrl,
      headers: user.server?.headers,
      activeConnection: nextConnection,
    );
  }

  Future<void> _save(User currentUser) async {
    if (_isSaving) {
      return;
    }

    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final normalizedExternal = _normalizeServerAddress(_externalServerController.text.trim());
    if (normalizedExternal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.screensSettingsServerConnectionSettingsPleaseEnterAValidExternalServer)),
      );
      return;
    }

    final localInput = _localServerController.text.trim();
    final normalizedLocal = localInput.isEmpty ? null : _normalizeServerAddress(localInput);
    if (localInput.isNotEmpty && normalizedLocal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.screensSettingsServerConnectionSettingsPleaseEnterAValidLocalServer)),
      );
      return;
    }

    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final wantsCredentialUpdate = username != currentUser.username || password.trim().isNotEmpty;

    if (wantsCredentialUpdate && password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.screensSettingsServerConnectionSettingsEnterPasswordToUpdateUsernameOr)),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      User updatedUser;
      final updatedServer = _buildUpdatedServer(
        currentUser,
        externalUrl: normalizedExternal,
        localUrl: normalizedLocal,
      );

      if (wantsCredentialUpdate) {
        final loginResponse = await _buildServerApi(normalizedExternal, serverHeaders: currentUser.server?.headers)
            .getMeApi()
            .login(
              loginRequest: LoginRequest(username: username, password: password),
              returnTokens: true,
            );

        final loginData = loginResponse.data;
        if (loginData == null) {
          throw FormatException(S.current.screensSettingsServerConnectionSettingsCredentialValidationReturnedNoData);
        }

        if (loginData.user.id != currentUser.id) {
          throw FormatException(
            S.current.screensSettingsServerConnectionSettingsCredentialsBelongToDifferentAccountUseAddAccount,
          );
        }

        updatedUser = loginData.user.copyWith(
          server: updatedServer,
          isActive: true,
          setting: loginData.user.setting ?? loginData.serverSettings,
        );
      } else {
        updatedUser = currentUser.copyWith(server: updatedServer);
      }

      final db = ref.read(appDatabaseProvider);
      await db.addOrUpdateStoredUser(updatedUser);

      ref.invalidate(currentUserProvider);
      ref.invalidate(allStoredUsersProvider);
      ref.invalidate(serverStatusProvider);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.current.screensSettingsServerConnectionSettingsServerSettingsSaved)));
      _passwordController.clear();
    } on DioException catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _parseDioErrorMessage(
              e,
              fallback: S.current.screensSettingsServerConnectionSettingsFailedToSaveServerSettingsPlain,
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.current.screensSettingsServerConnectionSettingsFailedToSaveServerSettings(e.toString())),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return SettingsPageScaffold(
      title: S.current.screensSettingsServerConnectionSettingsTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        currentUserAsync.when(
          data: (user) {
            if (user == null) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(S.current.screensSettingsServerConnectionSettingsNoActiveUserSignInBefore),
              );
            }

            _initializeFromUser(user);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          S.current.screensSettingsServerConnectionSettingsServerEndpoints,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _externalServerController,
                          keyboardType: TextInputType.url,
                          enabled: !_isSaving,
                          decoration: InputDecoration(
                            labelText: S.current.screensSettingsServerConnectionSettingsExternalServerURL,
                            hintText: S.current.screensSettingsServerConnectionSettingsHttpsYourAudiobookshelfExample,
                            prefixIcon: Icon(Icons.public_rounded),
                          ),
                          validator: (value) {
                            final normalized = _normalizeServerAddress((value ?? '').trim());
                            return normalized == null
                                ? S.current.screensSettingsServerConnectionSettingsEnterAValidExternalUrl
                                : null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _localServerController,
                          keyboardType: TextInputType.url,
                          enabled: !_isSaving,
                          decoration: InputDecoration(
                            labelText: S.current.screensSettingsServerConnectionSettingsLocalServerURLOptional,
                            hintText: S.current.screensSettingsServerConnectionSettingsHttp19216812513378,
                            prefixIcon: Icon(Icons.lan_rounded),
                          ),
                          validator: (value) {
                            final trimmed = (value ?? '').trim();
                            if (trimmed.isEmpty) {
                              return null;
                            }
                            final normalized = _normalizeServerAddress(trimmed);
                            return normalized == null
                                ? S.current.screensSettingsServerConnectionSettingsEnterAValidLocalUrlOrLeaveBlank
                                : null;
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          S.current.screensSettingsServerConnectionSettingsTheAppWillTryLocalFirst,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 22),
                        Text(
                          S.current.screensSettingsServerConnectionSettingsCredentials,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _usernameController,
                          enabled: !_isSaving,
                          decoration: InputDecoration(
                            labelText: S.current.screensSettingsServerConnectionSettingsUsername,
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (value) {
                            if ((value ?? '').trim().isEmpty) {
                              return S.current.screensSettingsServerConnectionSettingsUsernameCannotBeEmpty;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          enabled: !_isSaving,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: S.current.screensSettingsServerConnectionSettingsPassword,
                            hintText:
                                S.current.screensSettingsServerConnectionSettingsRequiredOnlyWhenChangingCredentials,
                            prefixIcon: const Icon(Icons.password_rounded),
                            suffixIcon: IconButton(
                              tooltip: _obscurePassword ? S.current.commonShowPassword : S.current.commonHidePassword,
                              onPressed: _isSaving
                                  ? null
                                  : () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                              icon: Icon(_obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          S.current.screensSettingsServerConnectionSettingsLeavePasswordEmptyToKeepCurrent,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton.icon(
                          onPressed: _isSaving ? null : () => _save(user),
                          icon: _isSaving
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.save_outlined),
                          label: Text(_isSaving ? S.current.commonSaving : S.current.commonSaveChanges),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(S.current.screensSettingsServerConnectionSettingsFailedToLoadUser(error.toString())),
          ),
        ),
      ],
    );
  }
}

String? _normalizeServerAddress(String input) {
  if (input.isEmpty) {
    return null;
  }

  final withScheme = input.contains('://') ? input : 'https://$input';
  final uri = Uri.tryParse(withScheme);

  if (uri == null || uri.host.isEmpty) {
    return null;
  }

  final pathSegments = uri.pathSegments.where((segment) => segment.trim().isNotEmpty).toList(growable: false);
  final normalizedPath = pathSegments.isEmpty ? '' : '/${pathSegments.join('/')}';

  final normalized = uri.replace(path: normalizedPath, query: null, fragment: null).toString();
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
