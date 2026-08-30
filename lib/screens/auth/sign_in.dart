import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaabsa/api/me/request/login_request.dart';
import 'package:yaabsa/api/magic/magic_config.dart';
import 'package:yaabsa/api/me/server.dart';
import 'package:yaabsa/api/me/status.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/auth_secret_store.dart';
import 'package:yaabsa/provider/core/user_scope_invalidation.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/core/oidc_provider.dart';
import 'package:yaabsa/provider/core/magic_config_provider.dart';
import 'package:yaabsa/provider/wear/wear_phone_channel.dart';
import 'package:yaabsa/screens/auth/widgets/glow_orb.dart';
import 'package:yaabsa/screens/auth/widgets/sign_in_advanced_options.dart';
import 'package:yaabsa/screens/auth/widgets/sign_in_auth_section.dart';
import 'package:yaabsa/screens/auth/widgets/sign_in_error_panel.dart';
import 'package:yaabsa/screens/auth/widgets/sign_in_header_editor_dialog.dart';
import 'package:yaabsa/screens/auth/widgets/magic_config_import_dialog.dart';
import 'package:yaabsa/screens/auth/widgets/sign_in_server_status.dart';
import 'package:yaabsa/util/globals.dart' show audioHandler;
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/dio_factory.dart';
import 'package:yaabsa/util/network/request_headers.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverAddressController = useTextEditingController();
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final apiKeyController = useTextEditingController();
    final passwordFocusNode = useFocusNode(debugLabel: 'authentication-code-password');

    final isLoading = useState(false);
    final useApiKey = useState(false);
    final isStatusLoading = useState(false);
    final errorMessage = useState<String?>(null);
    final loginErrorDetails = useState<String?>(null);
    final status = useState<ServerStatus?>(null);
    final statusError = useState<String?>(null);
    final lastCheckedServer = useState<String?>(null);
    final statusDebounce = useRef<Timer?>(null);
    final statusCancelToken = useRef<CancelToken?>(null);
    final customHeaders = useState<Map<String, String>>(<String, String>{});
    final advancedOptionsExpanded = useState(false);
    final autoSignInAfterAuthenticationCode = useState(false);
    final importedMagicConfig = useState<MagicConfig?>(null);
    final processedMagicLink = useRef<String?>(null);
    final pendingMagicConfig = ref.watch(magicConfigImportProvider);
    final hasStoredUsers = ref
        .watch(allStoredUsersProvider)
        .maybeWhen(data: (users) => users.isNotEmpty, orElse: () => false);
    final signInQuery = GoRouterState.of(context).uri.queryParameters;
    final isWearPairing = signInQuery['wear'] == '1';
    final keyringLockedFromRoute = signInQuery['keyringLocked'] == '1';
    final currentUserState = ref.watch(currentUserProvider);
    final keyringError = currentUserState.error;
    final keyringUnavailable = keyringLockedFromRoute || isAuthSecretsUnavailableError(keyringError);

    final oidcState = ref.watch(oidcStateProvider);
    final oidcLoading = oidcState.isLoading;
    final oidcError = oidcState.maybeWhen(
      error: (error, _) => error is Exception ? error.toString().replaceFirst('Exception: ', '') : error.toString(),
      orElse: () => null,
    );

    ref.listen<AsyncValue<String?>>(activeUserIdProvider, (previous, next) {
      final userId = next.value;
      if (userId != null && !keyringUnavailable && !isLoading.value && !oidcLoading) {
        logger('SignIn: activeUserId became non-null ($userId). Redirecting to /', tag: 'SignIn');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.go('/');
          }
        });
      }
    });

    ref.listen<AsyncValue<User?>>(currentUserProvider, (previous, next) {
      if (next.hasValue && next.value != null && !isLoading.value && !oidcLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.go('/');
          }
        });
      }
    });

    ref.listen<AsyncValue<void>>(oidcStateProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && ref.read(currentUserProvider).value != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.go('/');
          }
        });
      }
    });

    ABSApi buildServerApi(String baseUrl) {
      final headers = buildRequestHeaders(serverHeaders: customHeaders.value);
      return ABSApi(
        dio: createNativeDio(
          options: BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(milliseconds: 5000),
            receiveTimeout: const Duration(milliseconds: 3000),
            headers: headers.isEmpty ? null : headers,
          ),
        ),
        basePathOverride: baseUrl,
      );
    }

    void setErrorMessage(String? message, {String? details}) {
      errorMessage.value = message;
      loginErrorDetails.value = details;
    }

    Future<void> showHeaderEditor({String? originalHeaderName}) async {
      final result = await showSignInHeaderEditorDialog(
        context: context,
        existingHeaders: customHeaders.value,
        originalHeaderName: originalHeaderName,
      );

      if (result == null) {
        return;
      }

      final nextHeaders = Map<String, String>.from(customHeaders.value);
      if (originalHeaderName != null && originalHeaderName != result.name) {
        nextHeaders.remove(originalHeaderName);
      }
      nextHeaders[result.name] = result.value;
      customHeaders.value = nextHeaders;

      status.value = null;
      statusError.value = null;
      lastCheckedServer.value = null;
    }

    void removeHeader(String headerName) {
      final nextHeaders = Map<String, String>.from(customHeaders.value);
      nextHeaders.remove(headerName);
      customHeaders.value = nextHeaders;
      status.value = null;
      statusError.value = null;
      lastCheckedServer.value = null;
    }

    Future<ServerStatus?> fetchStatus({required bool showErrors}) async {
      if (showErrors) {
        setErrorMessage(null);
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
        final response = await buildServerApi(normalizedServer).getMeApi().getStatus(cancelToken: cancelToken);
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

    Future<void> importMagicConfig(String input) async {
      if (processedMagicLink.value == input) {
        return;
      }
      processedMagicLink.value = input;
      setErrorMessage(null);

      try {
        final serverUrl = await MagicConfigCodec.serverUrlFromInput(input);
        _setControllerTextKeepingCursor(serverAddressController, serverUrl);
        status.value = null;
        lastCheckedServer.value = null;

        late final MagicConfig config;
        try {
          config = await MagicConfigCodec.decode(input: input);
        } on MagicConfigServerKeyRequiredException {
          final importedStatus = await fetchStatus(showErrors: true);
          if (importedStatus == null) {
            throw FormatException(statusError.value ?? 'The Authentication Code server could not be reached.');
          }

          final customMessage = importedStatus.authFormData?.authLoginCustomMessage;
          final marker =
              MagicConfigKeyMarker.extract(customMessage) ??
              MagicConfigKeyMarker.fromSerializedName(MagicConfigKeyMarker.extractFromSanitizedHtml(customMessage));
          if (marker == null) {
            throw const FormatException('The server key for this Authentication Code is unavailable.');
          }
          config = await MagicConfigCodec.decode(input: input, marker: marker);
        }
        customHeaders.value = Map<String, String>.from(config.headers);
        importedMagicConfig.value = config;
        autoSignInAfterAuthenticationCode.value = config.isPasswordBearing;
        useApiKey.value = false;
        passwordController.clear();
        _setControllerTextKeepingCursor(serverAddressController, config.serverUrl);
        _setControllerTextKeepingCursor(usernameController, config.username);
        advancedOptionsExpanded.value = config.isPasswordBearing;
        errorMessage.value = null;
        loginErrorDetails.value = null;
        ref.read(magicConfigImportProvider.notifier).clear();
        if (!config.isPasswordBearing) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              passwordFocusNode.requestFocus();
            }
          });
        }
      } catch (error, stackTrace) {
        processedMagicLink.value = null;
        ref.read(magicConfigImportProvider.notifier).clear();
        final message = error is FormatException ? error.message : error.toString();
        setErrorMessage(
          'Could not import Authentication Code: $message',
          details: _buildLoginErrorDetails(error: error, stackTrace: stackTrace),
        );
      }
    }

    Future<void> promptMagicConfigImport() async {
      final value = await showMagicConfigImportDialog(context);
      if (value != null && value.isNotEmpty) {
        ref.read(magicConfigImportProvider.notifier).receive(value);
      }
    }

    void clearImportedMagicConfig() {
      importedMagicConfig.value = null;
      autoSignInAfterAuthenticationCode.value = false;
      processedMagicLink.value = null;
      ref.read(magicConfigImportProvider.notifier).clear();
    }

    Future<void> initializeSelectedLibraryAfterLogin({
      required AppDatabase db,
      required String userId,
      required ABSApi? api,
      String? serverDefaultLibraryId,
    }) async {
      final normalizedDefaultLibraryId = serverDefaultLibraryId?.trim();

      if (normalizedDefaultLibraryId != null && normalizedDefaultLibraryId.isNotEmpty) {
        await db.setUserSetting(userId, 'selectedLibraryId', normalizedDefaultLibraryId);
      }

      if (api == null) {
        return;
      }

      try {
        final librariesResponse = await api.getLibraryApi().getLibraries();
        final libraries = librariesResponse.data?.libraries;
        if (libraries == null || libraries.isEmpty) {
          return;
        }

        final hasValidDefault =
            normalizedDefaultLibraryId != null &&
            normalizedDefaultLibraryId.isNotEmpty &&
            libraries.any((library) => library.id == normalizedDefaultLibraryId);

        final selectedLibraryId = hasValidDefault ? normalizedDefaultLibraryId : libraries.first.id;

        if (selectedLibraryId.isNotEmpty) {
          await db.setUserSetting(userId, 'selectedLibraryId', selectedLibraryId);
        }
      } catch (e, s) {
        logger(
          'Failed to initialize selected library after login for user $userId: $e\\n$s',
          tag: 'SignIn',
          level: InfoLevel.warning,
        );
      }
    }

    Future<void> validateAndSignIn() async {
      setErrorMessage(null);

      final normalizedServer = _normalizeServerAddress(serverAddressController.text.trim());
      if (normalizedServer == null) {
        setErrorMessage('Please enter a valid server address.');
        return;
      }
      _setControllerTextKeepingCursor(serverAddressController, normalizedServer);

      final currentStatus = await ensureStatusForServer(normalizedServer, showErrors: true);
      if (currentStatus == null) {
        setErrorMessage(statusError.value ?? 'Unable to verify server status.');
        return;
      }

      final allowsLocal = currentStatus.authMethods.contains('local');
      if (!useApiKey.value && !allowsLocal) {
        setErrorMessage('Local login is disabled on this server. Use OpenID Connect instead.');
        return;
      }

      isLoading.value = true;
      var authenticationSucceeded = false;
      final magicConfig = importedMagicConfig.value;
      final magicConfigMatches =
          magicConfig != null &&
          magicConfig.serverUrl == normalizedServer &&
          magicConfig.username == usernameController.text.trim();

      try {
        late User loggedInUser;
        ABSApi? authenticatedApi;
        String? serverDefaultLibraryId;
        String? loginPassword;

        if (useApiKey.value) {
          final apiKey = apiKeyController.text.trim();
          if (apiKey.isEmpty) {
            setErrorMessage('API key is required.');
            return;
          }

          logger('Attempting API key auth against server: $normalizedServer', tag: 'SignIn');

          final api = buildServerApi(normalizedServer);
          api.setBearerAuth('BearerAuth', apiKey);
          final userResponse = await api.getMeApi().getUser();
          final userData = userResponse.data;
          if (userData == null) {
            setErrorMessage('API key authentication failed: Invalid response.');
            return;
          }

          loggedInUser = userData.copyWith(apiKey: apiKey);
          authenticatedApi = api;
        } else {
          final username = usernameController.text.trim();
          final importedPassword = magicConfig != null && magicConfigMatches && magicConfig.isPasswordBearing
              ? magicConfig.password
              : null;
          final password = importedPassword ?? passwordController.text;

          if (username.isEmpty || password.isEmpty) {
            setErrorMessage('Username and password are required.');
            return;
          }
          loginPassword = password;

          logger('Attempting login to server: $normalizedServer with username: $username', tag: 'SignIn');

          final api = buildServerApi(normalizedServer);

          final apiResponse = await api.getMeApi().login(
            loginRequest: LoginRequest(username: username, password: password),
            returnTokens: true,
          );

          final loginData = apiResponse.data;

          if (loginData == null) {
            setErrorMessage('Login failed: Invalid response from server.');
            return;
          }

          loggedInUser = loginData.user.copyWith(setting: loginData.serverSettings);
          serverDefaultLibraryId = loginData.userDefaultLibraryId;

          final token = loggedInUser.preferredAuthToken;
          if (token != null && token.isNotEmpty) {
            api.setBearerAuth('BearerAuth', token);
            authenticatedApi = api;
          }
        }

        if (magicConfig != null && magicConfigMatches && magicConfig.isPasswordBearing) {
          final initialPassword = loginPassword;
          if (initialPassword == null || initialPassword.isEmpty) {
            setErrorMessage('The initial password is not available. Enter the account password manually.');
            return;
          }

          final isGuest = loggedInUser.type.trim().toLowerCase() == 'guest';
          if (isGuest) {
            if (!context.mounted) {
              return;
            }
            final continueWithGuestPassword = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('Guest password cannot be changed'),
                content: const Text(
                  'Audiobookshelf does not allow guest users to change passwords. The initial password will remain valid after this sign in. Continue only if you accept this risk.',
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                  FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Continue')),
                ],
              ),
            );
            if (continueWithGuestPassword != true) {
              clearImportedMagicConfig();
              setErrorMessage('Sign in cancelled because the guest password cannot be rotated.');
              return;
            }
          } else {
            if (!context.mounted) {
              return;
            }
            final newPassword = await showMagicPasswordChangeDialog(context);
            if (newPassword == null || newPassword.isEmpty) {
              clearImportedMagicConfig();
              setErrorMessage('Password change is required after using an Authentication Code.');
              return;
            }

            final api = authenticatedApi;
            if (api == null) {
              throw const FormatException('The server did not return a token needed to change the initial password.');
            }

            final passwordResponse = await api.getMeApi().updatePassword(
              password: initialPassword,
              newPassword: newPassword,
              refreshToken: loggedInUser.refreshToken,
            );
            final responseData = passwordResponse.data;
            final responseUser = responseData is Map ? responseData['user'] : null;
            final responseAccessToken = responseUser is Map ? responseUser['accessToken'] as String? : null;
            final responseRefreshToken = responseUser is Map ? responseUser['refreshToken'] as String? : null;

            if (responseAccessToken != null && responseAccessToken.isNotEmpty) {
              loggedInUser = loggedInUser.copyWith(
                accessToken: responseAccessToken,
                refreshToken: responseRefreshToken ?? loggedInUser.refreshToken,
              );
              api.setBearerAuth('BearerAuth', responseAccessToken);
            } else {
              final reloginApi = buildServerApi(normalizedServer);
              final reloginResponse = await reloginApi.getMeApi().login(
                loginRequest: LoginRequest(username: loggedInUser.username, password: newPassword),
                returnTokens: true,
              );
              final reloginData = reloginResponse.data;
              if (reloginData == null) {
                throw const FormatException('Password changed, but the follow-up login returned no account data.');
              }
              loggedInUser = reloginData.user.copyWith(setting: reloginData.serverSettings);
              serverDefaultLibraryId = reloginData.userDefaultLibraryId;
              final reloginToken = loggedInUser.preferredAuthToken;
              if (reloginToken != null && reloginToken.isNotEmpty) {
                reloginApi.setBearerAuth('BearerAuth', reloginToken);
                authenticatedApi = reloginApi;
              }
            }
          }
        }

        if (isWearPairing) {
          final accessToken = useApiKey.value ? loggedInUser.apiKey : (loggedInUser.accessToken ?? loggedInUser.token);
          if (accessToken == null || accessToken.isEmpty) {
            setErrorMessage('Login succeeded, but the server did not return a token for the watch.');
            return;
          }

          final sent = await sendWearCredentialsToWatch(
            serverUrl: normalizedServer,
            accessToken: accessToken,
            refreshToken: useApiKey.value ? null : loggedInUser.refreshToken,
          );

          if (!context.mounted) return;
          if (!sent) {
            setErrorMessage('Could not send credentials to the watch. Make sure it is still waiting and try again.');
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Watch connected successfully.'), behavior: SnackBarBehavior.floating),
          );
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
          return;
        }

        final headers = buildRequestHeaders(serverHeaders: customHeaders.value);
        final db = ref.read(appDatabaseProvider);
        await db.addOrUpdateStoredUser(
          loggedInUser.copyWith(
            server: Server.fromExternalAddress(
              externalAddress: normalizedServer,
              headers: headers.isEmpty ? null : headers,
              activeConnection: ServerConnection.external,
            ),
          ),
        );

        await initializeSelectedLibraryAfterLogin(
          db: db,
          userId: loggedInUser.id,
          api: authenticatedApi,
          serverDefaultLibraryId: serverDefaultLibraryId,
        );

        await db.setActiveUserId(loggedInUser.id);
        if (magicConfig != null) {
          clearImportedMagicConfig();
        }

        ref.invalidate(allStoredUsersProvider);
        ref.invalidate(currentUserProvider);
        invalidateUserScopedProviders(ref);

        await ref.read(currentUserProvider.future);
        ref.read(absApiProvider);

        try {
          await db
              .watchGlobalSetting('activeUserId')
              .map((setting) => setting?.value)
              .firstWhere((activeUserId) => activeUserId == loggedInUser.id)
              .timeout(const Duration(seconds: 2));
        } on TimeoutException {
          logger(
            'Timed out waiting for activeUserId to publish ${loggedInUser.id} after sign in.',
            tag: 'SignIn',
            level: InfoLevel.debug,
          );
        }

        await audioHandler.androidAutoAuthenticationChanged(authenticated: true);
        authenticationSucceeded = true;
      } on DioException catch (e) {
        final needsPasswordFallback = magicConfig != null && magicConfigMatches && magicConfig.isPasswordBearing;
        clearImportedMagicConfig();
        setErrorMessage(
          needsPasswordFallback
              ? 'Authentication Code login failed. Enter the account password and try again.'
              : _parseDioErrorMessage(e, fallback: 'Login failed.'),
          details: null,
        );
      } catch (e, s) {
        final needsPasswordFallback = magicConfig != null && magicConfigMatches && magicConfig.isPasswordBearing;
        clearImportedMagicConfig();
        final storageError = isAuthSecretsUnavailableError(e)
            ? authSecretsUnavailableMessage(operation: 'saved', keyringLocked: isKeyringLockedError(e))
            : null;
        setErrorMessage(
          storageError != null
              ? 'Login could not be completed. $storageError'
              : needsPasswordFallback
              ? 'Authentication Code login failed. Enter the account password and try again.'
              : 'Login failed: $e',
          details: storageError == null ? _buildLoginErrorDetails(error: e, stackTrace: s) : null,
        );
      } finally {
        isLoading.value = false;
      }

      if (authenticationSucceeded && context.mounted) {
        context.go('/');
      }
    }

    Future<void> startOpenIdConnect() async {
      setErrorMessage(null);
      ref.read(oidcStateProvider.notifier).clearError();

      final normalizedServer = _normalizeServerAddress(serverAddressController.text.trim());
      if (normalizedServer == null) {
        setErrorMessage('Please enter a valid server address first');
        return;
      }
      _setControllerTextKeepingCursor(serverAddressController, normalizedServer);

      final currentStatus = await ensureStatusForServer(normalizedServer, showErrors: true);
      if (currentStatus == null) {
        setErrorMessage(statusError.value ?? 'Unable to verify server status');
        return;
      }

      final allowsOpenId = currentStatus.authMethods.contains('openid');
      if (!allowsOpenId) {
        setErrorMessage('OpenID Connect is not enabled on this server');
        return;
      }

      try {
        await ref
            .read(oidcStateProvider.notifier)
            .initiateOidc(serverUrl: normalizedServer, customHeaders: customHeaders.value);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You should be redirected to your browser to complete the OpenID Connect login'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        final formatted = formatOidcError(e);
        if (formatted is Exception) {
          final msg = formatted.toString().replaceFirst('Exception: ', '');
          setErrorMessage(msg);
        } else {
          setErrorMessage('Failed to start OpenID Connect: $formatted');
        }
      }
    }

    useEffect(() {
      if (!autoSignInAfterAuthenticationCode.value || importedMagicConfig.value == null) {
        return null;
      }

      autoSignInAfterAuthenticationCode.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          unawaited(validateAndSignIn());
        }
      });
      return null;
    }, [autoSignInAfterAuthenticationCode.value]);

    useEffect(() {
      void onServerChanged() {
        if (importedMagicConfig.value != null) {
          return;
        }

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

    useEffect(() {
      if (isWearPairing) {
        final prefillServer = signInQuery['serverUrl'];
        final prefillUsername = signInQuery['username'];
        if (prefillServer != null && prefillServer.isNotEmpty && serverAddressController.text.isEmpty) {
          serverAddressController.text = prefillServer;
        }
        if (prefillUsername != null && prefillUsername.isNotEmpty && usernameController.text.isEmpty) {
          usernameController.text = prefillUsername;
        }
      }
      return null;
    }, const []);

    useEffect(() {
      if (pendingMagicConfig != null) {
        unawaited(importMagicConfig(pendingMagicConfig));
      }
      return null;
    }, [pendingMagicConfig]);

    final activeStatus = status.value;
    final importedCodeNeedsPassword = importedMagicConfig.value?.isPasswordBearing == false;
    final isForcedAaosAuth = signInQuery['authRequired'] == '1' && AaosService.instance.currentState.isAutomotiveDevice;
    final allowsLocal = activeStatus == null || activeStatus.authMethods.contains('local');
    final allowsOpenId = (activeStatus?.authMethods.contains('openid') ?? false) && !isWearPairing;
    const allowsApiKey = true;
    final customMessage = activeStatus?.authFormData?.authLoginCustomMessage;
    final openIdButtonText = activeStatus?.authFormData?.authOpenIDButtonText ?? 'Continue with OpenID Connect';
    final keyringErrorMessage = keyringUnavailable
        ? authSecretsUnavailableMessage(
            operation: 'loaded',
            keyringLocked: keyringLockedFromRoute || (keyringError != null && isKeyringLockedError(keyringError)),
          )
        : null;
    final displayedErrorMessage = keyringErrorMessage ?? errorMessage.value ?? oidcError;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: !isForcedAaosAuth,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: Stack(
          children: [
            Positioned(
              top: -100,
              right: -70,
              child: GlowOrb(size: 250, color: colorScheme.primary.withValues(alpha: 0.16)),
            ),
            Positioned(
              bottom: -90,
              left: -55,
              child: GlowOrb(size: 220, color: colorScheme.tertiary.withValues(alpha: 0.14)),
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
                            if (hasStoredUsers && !isForcedAaosAuth) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: (isLoading.value || oidcLoading)
                                      ? null
                                      : () {
                                          if (context.canPop()) {
                                            context.pop();
                                          } else {
                                            context.go('/');
                                          }
                                        },
                                  tooltip: 'Back',
                                  icon: const Icon(Icons.arrow_back_rounded),
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                            Text(
                              'Yaabsa',
                              textAlign: TextAlign.center,
                              style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isWearPairing
                                  ? 'Sign in to connect your Wear OS watch'
                                  : 'Sign in to your Audiobookshelf server',
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 22),
                            TextField(
                              controller: serverAddressController,
                              enabled: !isLoading.value && !oidcLoading && !importedCodeNeedsPassword,
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(
                                labelText: 'Server Address',
                                hintText: 'https://your-audiobookshelf.example',
                                prefixIcon: const Icon(Icons.dns_outlined),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SignInServerStatus(
                              isLoading: isStatusLoading.value,
                              status: activeStatus,
                              error: statusError.value,
                            ),
                            if (customMessage != null && customMessage.trim().isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Html(
                                data: customMessage,
                                onLinkTap: (url, _, _) {
                                  if (url != null) {
                                    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                  }
                                },
                              ),
                            ],
                            if (kIsWeb)
                              Text("""Web support is not supported. It is possible, but any issues should not be reported as issues. You can report any issues in the discussion here: https://github.com/Vito0912/yaabsa/discussions/59
                              """, style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
                            SignInAuthSection(
                              useApiKey: useApiKey.value,
                              isLoading: isLoading.value || oidcLoading,
                              allowsLocal: allowsLocal,
                              allowsOpenId: allowsOpenId,
                              openIdButtonText: openIdButtonText,
                              usernameController: usernameController,
                              passwordController: passwordController,
                              passwordFocusNode: passwordFocusNode,
                              lockImportedIdentity: importedCodeNeedsPassword,
                              apiKeyController: apiKeyController,
                              onValidateAndSignIn: validateAndSignIn,
                              onStartOpenIdConnect: startOpenIdConnect,
                            ),
                            if (displayedErrorMessage != null) ...[
                              const SizedBox(height: 12),
                              SignInErrorPanel(
                                message: displayedErrorMessage,
                                stackTraceDetails: keyringErrorMessage == null ? loginErrorDetails.value : null,
                                onRetry: keyringErrorMessage == null ? null : () => ref.invalidate(currentUserProvider),
                              ),
                            ],
                            SignInAdvancedOptions(
                              isExpanded: advancedOptionsExpanded.value,
                              onExpandedChanged: (value) => advancedOptionsExpanded.value = value,
                              isLoading: isLoading.value || oidcLoading,
                              allowsApiKey: allowsApiKey,
                              useApiKey: useApiKey.value,
                              onUseApiKeyChanged: (value) {
                                useApiKey.value = value;
                                setErrorMessage(null);
                                if (value) {
                                  advancedOptionsExpanded.value = true;
                                }
                              },
                              onImportMagicConfig: promptMagicConfigImport,
                              customHeaders: customHeaders.value,
                              onAddHeader: () => showHeaderEditor(),
                              onEditHeader: (headerName) => showHeaderEditor(originalHeaderName: headerName),
                              onRemoveHeader: removeHeader,
                            ),
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
      ),
    );
  }
}

String? _normalizeServerAddress(String input) {
  final trimmedInput = input.trim();
  if (trimmedInput.isEmpty) return null;

  final lowerInput = trimmedInput.toLowerCase();
  final hasExplicitHttpScheme = RegExp(r'^https?://').hasMatch(lowerInput);
  final hasExplicitScheme = lowerInput.contains('://');
  final isIncompleteHttpScheme =
      lowerInput == 'http' || lowerInput == 'https' || RegExp(r'^https?:/{0,2}$').hasMatch(lowerInput);
  if (isIncompleteHttpScheme || (hasExplicitScheme && !hasExplicitHttpScheme)) return null;

  final withScheme = hasExplicitHttpScheme ? trimmedInput : 'https://$trimmedInput';
  final uri = Uri.tryParse(withScheme);
  final scheme = uri?.scheme.toLowerCase();

  if (uri == null || !uri.hasAuthority || uri.host.isEmpty || (scheme != 'http' && scheme != 'https')) {
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

String _buildLoginErrorDetails({required Object error, required StackTrace stackTrace}) {
  final buffer = StringBuffer()
    ..writeln('Error: $error')
    ..writeln('Type: ${error.runtimeType}');

  buffer
    ..writeln('Stack trace:')
    ..writeln(stackTrace.toString());

  return buffer.toString();
}

void _setControllerTextKeepingCursor(TextEditingController controller, String text) {
  if (controller.text == text) return;
  controller.value = controller.value.copyWith(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
    composing: TextRange.empty,
  );
}
