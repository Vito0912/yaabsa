import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/me/request/login_request.dart';
import 'package:yaabsa/api/me/server.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/settings/custom_headers_editor.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/auth/widgets/sign_in_header_editor_dialog.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/network/dio_factory.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';

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
  Map<String, String> _customHeaders = <String, String>{};

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
    _customHeaders = Map<String, String>.from(user.server?.headers ?? const <String, String>{});
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
      headers: _customHeaders.isEmpty ? null : Map<String, String>.from(_customHeaders),
      activeConnection: nextConnection,
    );
  }

  Future<void> _editHeader({String? originalHeaderName}) async {
    final result = await showSignInHeaderEditorDialog(
      context: context,
      existingHeaders: _customHeaders,
      originalHeaderName: originalHeaderName,
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      final nextHeaders = Map<String, String>.from(_customHeaders);
      if (originalHeaderName != null && originalHeaderName != result.name) {
        nextHeaders.remove(originalHeaderName);
      }
      nextHeaders[result.name] = result.value;
      _customHeaders = nextHeaders;
    });
  }

  void _removeHeader(String headerName) {
    setState(() {
      _customHeaders = Map<String, String>.from(_customHeaders)..remove(headerName);
    });
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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter a valid external server URL.')));
      return;
    }

    final localInput = _localServerController.text.trim();
    final normalizedLocal = localInput.isEmpty ? null : _normalizeServerAddress(localInput);
    if (localInput.isNotEmpty && normalizedLocal == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter a valid local server URL or leave it blank.')));
      return;
    }

    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final wantsCredentialUpdate = username != currentUser.username || password.trim().isNotEmpty;

    if (wantsCredentialUpdate && password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter password to update username or credentials.')));
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
        final loginResponse = await _buildServerApi(normalizedExternal, serverHeaders: updatedServer.headers)
            .getMeApi()
            .login(
              loginRequest: LoginRequest(username: username, password: password),
              returnTokens: true,
            );

        final loginData = loginResponse.data;
        if (loginData == null) {
          throw const FormatException('Credential validation returned no data.');
        }

        if (loginData.user.id != currentUser.id) {
          throw const FormatException('Credentials belong to a different account. Use Add Account instead.');
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

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Server settings saved.')));
      _passwordController.clear();
    } on DioException catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_parseDioErrorMessage(e, fallback: 'Failed to save server settings.'))));
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save server settings: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildSettingsSection(BuildContext context, {required String title, required Widget child}) {
    final theme = Theme.of(context);

    return SettingsNavigationSection(
      title: title,
      showSectionTitle: false,
      topPadding: 0,
      horizontalPadding: 0,
      children: [
        Padding(
          padding: EdgeInsets.all(context.isMobile ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionFields(BuildContext context) {
    final externalField = StyledTextFormField(
      controller: _externalServerController,
      keyboardType: TextInputType.url,
      enabled: !_isSaving,
      label: 'External server URL',
      hintText: 'https://your-audiobookshelf.example',
      prefixIcon: const Icon(Icons.public_rounded),
      validator: (value) {
        final normalized = _normalizeServerAddress((value ?? '').trim());
        return normalized == null ? 'Enter a valid external URL.' : null;
      },
    );
    final localField = StyledTextFormField(
      controller: _localServerController,
      keyboardType: TextInputType.url,
      enabled: !_isSaving,
      label: 'Local server URL',
      hintText: 'Optional · http://192.168.1.25:13378',
      prefixIcon: const Icon(Icons.lan_rounded),
      validator: (value) {
        final trimmed = (value ?? '').trim();
        if (trimmed.isEmpty) {
          return null;
        }
        final normalized = _normalizeServerAddress(trimmed);
        return normalized == null ? 'Enter a valid local URL or leave blank.' : null;
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        context.isMobile
            ? Column(children: [externalField, const SizedBox(height: 12), localField])
            : Row(
                children: [
                  Expanded(child: externalField),
                  const SizedBox(width: 12),
                  Expanded(child: localField),
                ],
              ),
        const SizedBox(height: 12),
        Text(
          'When a local address is available, the app prefers it and falls back to the external address when needed.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildCredentialsFields(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StyledTextFormField(
          controller: _usernameController,
          enabled: !_isSaving,
          label: 'Username',
          prefixIcon: const Icon(Icons.person_outline_rounded),
          validator: (value) => (value ?? '').trim().isEmpty ? 'Username cannot be empty.' : null,
        ),
        const SizedBox(height: 12),
        StyledTextFormField(
          controller: _passwordController,
          enabled: !_isSaving,
          obscureText: _obscurePassword,
          label: 'Password',
          hintText: 'Only needed when changing credentials',
          prefixIcon: const Icon(Icons.password_rounded),
          suffixIcon: IconButton(
            tooltip: _obscurePassword ? 'Show password' : 'Hide password',
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
        const SizedBox(height: 12),
        Text(
          'Leave the password empty to keep your current credentials.',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, User user) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _isSaving ? null : () => _save(user),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        icon: _isSaving
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary),
              )
            : const Icon(Icons.save_outlined),
        label: Text(_isSaving ? 'Saving changes…' : 'Save changes'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return SettingsPageScaffold(
      title: 'Server Connection',
      maxWidth: 820,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        currentUserAsync.when(
          data: (user) {
            if (user == null) {
              final colorScheme = Theme.of(context).colorScheme;
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  margin: EdgeInsets.zero,
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(Icons.person_off_rounded, size: 40, color: colorScheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        const Text('No active user'),
                        const SizedBox(height: 4),
                        Text(
                          'Sign in before editing server settings.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            _initializeFromUser(user);

            return Padding(
              padding: EdgeInsets.fromLTRB(context.isMobile ? 12 : 20, 8, context.isMobile ? 12 : 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSettingsSection(context, title: 'Server endpoints', child: _buildConnectionFields(context)),
                    const SizedBox(height: 12),
                    _buildSettingsSection(
                      context,
                      title: 'Account credentials',
                      child: _buildCredentialsFields(context),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsSection(
                      context,
                      title: 'Custom headers',
                      child: CustomHeadersEditor(
                        headers: _customHeaders,
                        enabled: !_isSaving,
                        onAdd: () => _editHeader(),
                        onEdit: (name) => _editHeader(originalHeaderName: name),
                        onRemove: _removeHeader,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSaveButton(context, user),
                  ],
                ),
              ),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Padding(padding: const EdgeInsets.all(20), child: Text('Failed to load user: $error')),
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
