import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/admin/admin_authentication_settings.dart';
import 'package:yaabsa/components/app/item/editor/library_item_description_codec.dart';
import 'package:yaabsa/api/admin/update_admin_authentication_settings_request.dart';
import 'package:yaabsa/api/magic/magic_config.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/components/settings/authentication/admin_authentication_settings_panel.dart';
import 'package:yaabsa/components/settings/authentication/admin_authentication_settings_validation.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminServerAuthenticationView extends ConsumerStatefulWidget {
  const AdminServerAuthenticationView({super.key});

  @override
  ConsumerState<AdminServerAuthenticationView> createState() => _AdminServerAuthenticationViewState();
}

class _AdminServerAuthenticationViewState extends ConsumerState<AdminServerAuthenticationView> {
  late QuillController _customLoginMessageController;
  final TextEditingController _issuerUrlController = TextEditingController();
  final TextEditingController _authorizationUrlController = TextEditingController();
  final TextEditingController _tokenUrlController = TextEditingController();
  final TextEditingController _userInfoUrlController = TextEditingController();
  final TextEditingController _jwksUrlController = TextEditingController();
  final TextEditingController _logoutUrlController = TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _clientSecretController = TextEditingController();
  final TextEditingController _signingAlgorithmController = TextEditingController();
  final TextEditingController _buttonTextController = TextEditingController();
  final TextEditingController _groupClaimController = TextEditingController();
  final TextEditingController _advancedPermsClaimController = TextEditingController();

  String? _activeUserId;

  bool _isLoading = true;
  bool _isSavingSettings = false;
  bool _isAutoPopulatingOpenId = false;
  bool _hasLoadedSettings = false;
  bool _showCustomLoginMessage = false;
  bool _enableLocalAuth = true;
  bool _enableOpenIdAuth = false;
  bool _authOpenIdAutoLaunch = false;
  bool _authOpenIdAutoRegister = false;
  bool _obscureClientSecret = true;

  List<String> _mobileRedirectUris = const <String>['audiobookshelf://oauth'];
  List<String> _signingAlgorithmOptions = const <String>[];
  String _selectedSigningAlgorithm = '';
  String _matchExistingBy = '';
  String _selectedWebRedirectSubfolder = '/';
  String _callbackUrlBase = 'https://<your.server.com>';
  String _webCallbackUrl = '';
  String _mobileCallbackUrl = '';
  MagicConfigKeyMarker? _magicConfigKeyMarker;

  String? _errorMessage;
  String? _authMethodsError;
  String? _issuerUrlError;
  String? _authorizationUrlError;
  String? _tokenUrlError;
  String? _userInfoUrlError;
  String? _jwksUrlError;
  String? _clientIdError;
  String? _clientSecretError;
  String? _signingAlgorithmError;
  String? _redirectUrisError;
  String? _groupClaimError;
  String? _advancedPermsClaimError;
  String? _subfolderError;

  bool get _canSaveSettings => !_isLoading && !_isSavingSettings && !_isAutoPopulatingOpenId;

  bool get _canDisableLocalAuth {
    if (!_enableOpenIdAuth) {
      return false;
    }

    final l10n = context.l10n;
    final normalizedRedirectUris = AdminAuthenticationSettingsValidation.normalizeRedirectUris(_mobileRedirectUris);
    return AdminAuthenticationSettingsValidation.validateRequired(
              _issuerUrlController.text,
              label: l10n.fieldIssuerUrl,
              localizations: l10n,
            ) ==
            null &&
        AdminAuthenticationSettingsValidation.validateRequired(
              _authorizationUrlController.text,
              label: l10n.fieldAuthorizationUrl,
              localizations: l10n,
            ) ==
            null &&
        AdminAuthenticationSettingsValidation.validateRequired(
              _tokenUrlController.text,
              label: l10n.fieldTokenUrl,
              localizations: l10n,
            ) ==
            null &&
        AdminAuthenticationSettingsValidation.validateRequired(
              _userInfoUrlController.text,
              label: l10n.fieldUserInfoUrl,
              localizations: l10n,
            ) ==
            null &&
        AdminAuthenticationSettingsValidation.validateRequired(
              _jwksUrlController.text,
              label: l10n.fieldJwksUrl,
              localizations: l10n,
            ) ==
            null &&
        AdminAuthenticationSettingsValidation.validateRequired(
              _clientIdController.text,
              label: l10n.fieldClientId,
              localizations: l10n,
            ) ==
            null &&
        AdminAuthenticationSettingsValidation.validateRequired(
              _clientSecretController.text,
              label: l10n.fieldClientSecret,
              localizations: l10n,
            ) ==
            null &&
        AdminAuthenticationSettingsValidation.validateRequired(
              _resolveSigningAlgorithmValue(),
              label: l10n.fieldSigningAlgorithm,
              localizations: l10n,
            ) ==
            null &&
        AdminAuthenticationSettingsValidation.validateRedirectUris(normalizedRedirectUris, localizations: l10n) ==
            null &&
        AdminAuthenticationSettingsValidation.validateSubfolder(_resolveSubfolderPayloadValue(), localizations: l10n) ==
            null;
  }

  bool _isAdminType(String? userType) {
    final normalizedType = (userType ?? '').trim().toLowerCase();
    return normalizedType == 'admin' || normalizedType == 'root';
  }

  @override
  void initState() {
    super.initState();
    _customLoginMessageController = QuillController.basic();
    _refreshCallbackPreviews();
  }

  @override
  void dispose() {
    _customLoginMessageController.dispose();
    _issuerUrlController.dispose();
    _authorizationUrlController.dispose();
    _tokenUrlController.dispose();
    _userInfoUrlController.dispose();
    _jwksUrlController.dispose();
    _logoutUrlController.dispose();
    _clientIdController.dispose();
    _clientSecretController.dispose();
    _signingAlgorithmController.dispose();
    _buttonTextController.dispose();
    _groupClaimController.dispose();
    _advancedPermsClaimController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _normalizeWebRedirectSubfolder(String? value) {
    final normalized = (value ?? '').trim();
    if (normalized == '/audiobookshelf') {
      return '/audiobookshelf';
    }
    return '/';
  }

  String _resolveSubfolderPayloadValue() {
    return _selectedWebRedirectSubfolder == '/' ? '' : _selectedWebRedirectSubfolder;
  }

  String _resolveSubfolderSegment() {
    final payloadValue = _resolveSubfolderPayloadValue();
    if (payloadValue.isEmpty) {
      return '';
    }
    return payloadValue.startsWith('/') ? payloadValue : '/$payloadValue';
  }

  String _resolveCallbackBase(String? serverUrl) {
    final raw = (serverUrl ?? '').trim();
    if (raw.isEmpty) {
      return 'https://<your.server.com>';
    }

    final uri = Uri.tryParse(raw);
    if (uri == null || uri.host.isEmpty || uri.scheme.isEmpty) {
      return 'https://<your.server.com>';
    }

    final withoutQuery = uri.replace(query: null, fragment: null);
    final path = withoutQuery.path == '/' ? '' : withoutQuery.path;
    final base = '${withoutQuery.scheme}://${withoutQuery.authority}$path';
    return base.endsWith('/') ? base.substring(0, base.length - 1) : base;
  }

  void _refreshCallbackPreviews() {
    final segment = _resolveSubfolderSegment();
    _webCallbackUrl = '$_callbackUrlBase$segment/auth/openid/callback';
    _mobileCallbackUrl = '$_callbackUrlBase$segment/auth/openid/mobile-redirect';
  }

  void _clearValidationErrors() {
    _authMethodsError = null;
    _issuerUrlError = null;
    _authorizationUrlError = null;
    _tokenUrlError = null;
    _userInfoUrlError = null;
    _jwksUrlError = null;
    _clientIdError = null;
    _clientSecretError = null;
    _signingAlgorithmError = null;
    _redirectUrisError = null;
    _groupClaimError = null;
    _advancedPermsClaimError = null;
    _subfolderError = null;
  }

  void _onFieldChanged(String _) {
    _refreshCallbackPreviews();
    setState(() {
      _errorMessage = null;
      _authMethodsError = null;
      _issuerUrlError = null;
      _authorizationUrlError = null;
      _tokenUrlError = null;
      _userInfoUrlError = null;
      _jwksUrlError = null;
      _clientIdError = null;
      _clientSecretError = null;
      _signingAlgorithmError = null;
      _groupClaimError = null;
      _advancedPermsClaimError = null;
      _subfolderError = null;
    });
  }

  void _onMobileRedirectUrisChanged(List<String> values) {
    setState(() {
      _mobileRedirectUris = AdminAuthenticationSettingsValidation.normalizeRedirectUris(values);
      _redirectUrisError = null;
      _errorMessage = null;
    });
  }

  void _onMatchExistingByChanged(String value) {
    setState(() {
      _matchExistingBy = value;
      _errorMessage = null;
    });
  }

  void _onSelectedSigningAlgorithmChanged(String value) {
    setState(() {
      _selectedSigningAlgorithm = value;
      _signingAlgorithmController.text = value;
      _signingAlgorithmError = null;
      _errorMessage = null;
    });
  }

  void _onSelectedWebRedirectSubfolderChanged(String value) {
    setState(() {
      _selectedWebRedirectSubfolder = _normalizeWebRedirectSubfolder(value);
      _subfolderError = null;
      _errorMessage = null;
      _refreshCallbackPreviews();
    });
  }

  void _onCustomLoginMessageChanged() {
    if (_errorMessage == null) {
      return;
    }

    setState(() {
      _errorMessage = null;
    });
  }

  Future<void> _onEnableLocalAuthChanged(bool nextValue) async {
    if (nextValue) {
      if (!mounted) {
        return;
      }

      setState(() {
        _enableLocalAuth = true;
        _authMethodsError = null;
        _errorMessage = null;
      });
      return;
    }

    if (!_canDisableLocalAuth) {
      _showMessage(context.l10n.errorConfigureOpenIdBeforeDisablingLocalAuthentication);
      return;
    }

    final shouldDisable = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(dialogContext.l10n.headingDisableLocalAuthentication),
          content: Text(dialogContext.l10n.confirmDisableLocalAuthentication),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(dialogContext.l10n.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(dialogContext.l10n.actionDisableLocalAuthentication),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldDisable != true) {
      return;
    }

    setState(() {
      _enableLocalAuth = false;
      _authMethodsError = null;
      _errorMessage = null;
    });
  }

  Future<void> _loadAuthenticationSettings({required bool showLoading}) async {
    final localizations = context.l10n;
    final api = ref.read(absApiProvider);
    if (api == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _hasLoadedSettings = true;
        _errorMessage = localizations.errorNoActiveApiClient;
      });
      return;
    }

    if (showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final response = await api.getAdminApi().getAuthenticationSettings();
      final nextSettings = response.data ?? const AdminAuthenticationSettings();
      final nextRedirectUris = AdminAuthenticationSettingsValidation.normalizeRedirectUris(
        nextSettings.authOpenIdMobileRedirectUris.isEmpty
            ? const <String>['audiobookshelf://oauth']
            : nextSettings.authOpenIdMobileRedirectUris,
      );

      if (!mounted) {
        return;
      }

      _magicConfigKeyMarker =
          MagicConfigKeyMarker.extract(nextSettings.authLoginCustomMessage) ??
          MagicConfigKeyMarker.fromSerializedName(
            MagicConfigKeyMarker.extractFromSanitizedHtml(nextSettings.authLoginCustomMessage),
          );
      final customMessageDocument = quillDocumentFromHtml(
        MagicConfigKeyMarker.visibleHtml(nextSettings.authLoginCustomMessage),
      );
      _customLoginMessageController.dispose();
      _customLoginMessageController = QuillController(
        document: customMessageDocument,
        selection: const TextSelection.collapsed(offset: 0),
      );
      _issuerUrlController.text = nextSettings.authOpenIdIssuerUrl ?? '';
      _authorizationUrlController.text = nextSettings.authOpenIdAuthorizationUrl ?? '';
      _tokenUrlController.text = nextSettings.authOpenIdTokenUrl ?? '';
      _userInfoUrlController.text = nextSettings.authOpenIdUserInfoUrl ?? '';
      _jwksUrlController.text = nextSettings.authOpenIdJwksUrl ?? '';
      _logoutUrlController.text = nextSettings.authOpenIdLogoutUrl ?? '';
      _clientIdController.text = nextSettings.authOpenIdClientId ?? '';
      _clientSecretController.text = nextSettings.authOpenIdClientSecret ?? '';
      _signingAlgorithmController.text = nextSettings.authOpenIdTokenSigningAlgorithm ?? '';
      _buttonTextController.text = nextSettings.authOpenIdButtonText ?? '';
      _groupClaimController.text = nextSettings.authOpenIdGroupClaim ?? '';
      _advancedPermsClaimController.text = nextSettings.authOpenIdAdvancedPermsClaim ?? '';
      _selectedWebRedirectSubfolder = _normalizeWebRedirectSubfolder(nextSettings.authOpenIdSubfolderForRedirectUrls);

      _refreshCallbackPreviews();

      setState(() {
        _showCustomLoginMessage =
            MagicConfigKeyMarker.visibleHtml(nextSettings.authLoginCustomMessage)?.trim().isNotEmpty ?? false;
        _enableLocalAuth = nextSettings.localAuthEnabled;
        _enableOpenIdAuth = nextSettings.openIdAuthEnabled;
        _authOpenIdAutoLaunch = nextSettings.authOpenIdAutoLaunch;
        _authOpenIdAutoRegister = nextSettings.authOpenIdAutoRegister;
        _mobileRedirectUris = nextRedirectUris;
        _matchExistingBy = nextSettings.authOpenIdMatchExistingBy ?? '';
        _selectedSigningAlgorithm = nextSettings.authOpenIdTokenSigningAlgorithm ?? '';
        _signingAlgorithmOptions = const <String>[];
        _errorMessage = null;
        _clearValidationErrors();
        _isLoading = false;
        _hasLoadedSettings = true;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _hasLoadedSettings = true;
        _errorMessage = listManagementErrorMessage(
          error,
          fallback: localizations.errorLoadAuthenticationSettingsFailed,
        );
      });
    }
  }

  Future<void> _rotateMagicKey() async {
    if (_magicConfigKeyMarker == null || _isSavingSettings || _isLoading) {
      return;
    }

    final localizations = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.headingRotateAuthenticationCodeKey),
        content: Text(dialogContext.l10n.confirmRotateAuthenticationCodeKey),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.l10n.actionRotateAuthenticationCodeKey),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(localizations.errorNoActiveApiClient);
      return;
    }

    setState(() {
      _isSavingSettings = true;
      _errorMessage = null;
    });

    try {
      final settings = (await api.getAdminApi().getAuthenticationSettings()).data;
      final currentMarker =
          MagicConfigKeyMarker.extract(settings?.authLoginCustomMessage) ??
          MagicConfigKeyMarker.fromSerializedName(
            MagicConfigKeyMarker.extractFromSanitizedHtml(settings?.authLoginCustomMessage),
          );
      if (currentMarker == null) {
        _showMessage(localizations.errorAuthenticationCodeKeyUnavailable);
        return;
      }

      final marker = MagicConfigKeyMarker.generate();
      await api.getAdminApi().updateAuthenticationSettings(
        payload: UpdateAdminAuthenticationSettingsRequest(
          authLoginCustomMessage: MagicConfigKeyMarker.appendToHtml(settings?.authLoginCustomMessage, marker),
        ),
      );
      final savedSettings = (await api.getAdminApi().getAuthenticationSettings()).data;
      final savedMarker =
          MagicConfigKeyMarker.extract(savedSettings?.authLoginCustomMessage) ??
          MagicConfigKeyMarker.fromSerializedName(
            MagicConfigKeyMarker.extractFromSanitizedHtml(savedSettings?.authLoginCustomMessage),
          );
      if (savedMarker == null || savedMarker.encodedKey != marker.encodedKey) {
        throw FormatException(localizations.errorAuthenticationCodeKeyRotationNotPreserved);
      }
      if (!mounted) {
        return;
      }
      _showMessage(localizations.statusAuthenticationCodeKeyRotated);
      await _loadAuthenticationSettings(showLoading: false);
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = listManagementErrorMessage(
            error,
            fallback: localizations.errorRotateAuthenticationCodeKeyFailed,
          );
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSavingSettings = false;
        });
      }
    }
  }

  String _resolveSigningAlgorithmValue() {
    if (_signingAlgorithmOptions.isNotEmpty) {
      if (_selectedSigningAlgorithm.trim().isNotEmpty) {
        return _selectedSigningAlgorithm.trim();
      }
      return _signingAlgorithmOptions.first;
    }

    return _signingAlgorithmController.text.trim();
  }

  bool _validateSettings({required bool showErrors}) {
    final l10n = context.l10n;
    String? authMethodsError;
    String? issuerUrlError;
    String? authorizationUrlError;
    String? tokenUrlError;
    String? userInfoUrlError;
    String? jwksUrlError;
    String? clientIdError;
    String? clientSecretError;
    String? signingAlgorithmError;
    String? redirectUrisError;
    String? groupClaimError;
    String? advancedPermsClaimError;
    String? subfolderError;

    if (!_enableLocalAuth && !_enableOpenIdAuth) {
      authMethodsError = l10n.errorAuthenticationMethodsRequired;
    }

    if (_enableOpenIdAuth) {
      issuerUrlError = AdminAuthenticationSettingsValidation.validateRequired(
        _issuerUrlController.text,
        label: l10n.fieldIssuerUrl,
        localizations: l10n,
      );
      authorizationUrlError = AdminAuthenticationSettingsValidation.validateRequired(
        _authorizationUrlController.text,
        label: l10n.fieldAuthorizationUrl,
        localizations: l10n,
      );
      tokenUrlError = AdminAuthenticationSettingsValidation.validateRequired(
        _tokenUrlController.text,
        label: l10n.fieldTokenUrl,
        localizations: l10n,
      );
      userInfoUrlError = AdminAuthenticationSettingsValidation.validateRequired(
        _userInfoUrlController.text,
        label: l10n.fieldUserInfoUrl,
        localizations: l10n,
      );
      jwksUrlError = AdminAuthenticationSettingsValidation.validateRequired(
        _jwksUrlController.text,
        label: l10n.fieldJwksUrl,
        localizations: l10n,
      );
      clientIdError = AdminAuthenticationSettingsValidation.validateRequired(
        _clientIdController.text,
        label: l10n.fieldClientId,
        localizations: l10n,
      );
      clientSecretError = AdminAuthenticationSettingsValidation.validateRequired(
        _clientSecretController.text,
        label: l10n.fieldClientSecret,
        localizations: l10n,
      );
      signingAlgorithmError = AdminAuthenticationSettingsValidation.validateRequired(
        _resolveSigningAlgorithmValue(),
        label: l10n.fieldSigningAlgorithm,
        localizations: l10n,
      );
      redirectUrisError = AdminAuthenticationSettingsValidation.validateRedirectUris(
        _mobileRedirectUris,
        localizations: l10n,
      );
      groupClaimError = AdminAuthenticationSettingsValidation.validateClaim(
        _groupClaimController.text,
        label: l10n.fieldGroupClaim,
        localizations: l10n,
      );
      advancedPermsClaimError = AdminAuthenticationSettingsValidation.validateClaim(
        _advancedPermsClaimController.text,
        label: l10n.fieldAdvancedPermissionClaim,
        localizations: l10n,
      );
      subfolderError = AdminAuthenticationSettingsValidation.validateSubfolder(
        _resolveSubfolderPayloadValue(),
        localizations: l10n,
      );
    }

    if (showErrors) {
      setState(() {
        _authMethodsError = authMethodsError;
        _issuerUrlError = issuerUrlError;
        _authorizationUrlError = authorizationUrlError;
        _tokenUrlError = tokenUrlError;
        _userInfoUrlError = userInfoUrlError;
        _jwksUrlError = jwksUrlError;
        _clientIdError = clientIdError;
        _clientSecretError = clientSecretError;
        _signingAlgorithmError = signingAlgorithmError;
        _redirectUrisError = redirectUrisError;
        _groupClaimError = groupClaimError;
        _advancedPermsClaimError = advancedPermsClaimError;
        _subfolderError = subfolderError;
      });
    }

    return authMethodsError == null &&
        issuerUrlError == null &&
        authorizationUrlError == null &&
        tokenUrlError == null &&
        userInfoUrlError == null &&
        jwksUrlError == null &&
        clientIdError == null &&
        clientSecretError == null &&
        signingAlgorithmError == null &&
        redirectUrisError == null &&
        groupClaimError == null &&
        advancedPermsClaimError == null &&
        subfolderError == null;
  }

  UpdateAdminAuthenticationSettingsRequest _buildUpdateRequest() {
    final subfolder = _resolveSubfolderPayloadValue();
    final normalizedRedirectUris = AdminAuthenticationSettingsValidation.normalizeRedirectUris(_mobileRedirectUris);
    final visibleCustomLoginMessageHtml = _showCustomLoginMessage ? _currentCustomLoginMessageHtml() : null;
    final customLoginMessageHtml = _magicConfigKeyMarker == null
        ? visibleCustomLoginMessageHtml
        : MagicConfigKeyMarker.appendToHtml(visibleCustomLoginMessageHtml, _magicConfigKeyMarker!);

    return UpdateAdminAuthenticationSettingsRequest(
      authLoginCustomMessage: customLoginMessageHtml,
      authActiveAuthMethods: <String>[if (_enableLocalAuth) 'local', if (_enableOpenIdAuth) 'openid'],
      authOpenIdIssuerUrl: AdminAuthenticationSettingsValidation.normalizeNullable(_issuerUrlController.text),
      authOpenIdAuthorizationUrl: AdminAuthenticationSettingsValidation.normalizeNullable(
        _authorizationUrlController.text,
      ),
      authOpenIdTokenUrl: AdminAuthenticationSettingsValidation.normalizeNullable(_tokenUrlController.text),
      authOpenIdUserInfoUrl: AdminAuthenticationSettingsValidation.normalizeNullable(_userInfoUrlController.text),
      authOpenIdJwksUrl: AdminAuthenticationSettingsValidation.normalizeNullable(_jwksUrlController.text),
      authOpenIdLogoutUrl: AdminAuthenticationSettingsValidation.normalizeNullable(_logoutUrlController.text),
      authOpenIdClientId: AdminAuthenticationSettingsValidation.normalizeNullable(_clientIdController.text),
      authOpenIdClientSecret: AdminAuthenticationSettingsValidation.normalizeNullable(_clientSecretController.text),
      authOpenIdTokenSigningAlgorithm: AdminAuthenticationSettingsValidation.normalizeNullable(
        _resolveSigningAlgorithmValue(),
      ),
      authOpenIdButtonText: AdminAuthenticationSettingsValidation.normalizeNullable(_buttonTextController.text),
      authOpenIdAutoLaunch: _authOpenIdAutoLaunch,
      authOpenIdAutoRegister: _authOpenIdAutoRegister,
      authOpenIdMatchExistingBy: _matchExistingBy.trim().isEmpty ? null : _matchExistingBy.trim(),
      authOpenIdMobileRedirectUris: normalizedRedirectUris,
      authOpenIdGroupClaim: AdminAuthenticationSettingsValidation.normalizeNullable(_groupClaimController.text),
      authOpenIdAdvancedPermsClaim: AdminAuthenticationSettingsValidation.normalizeNullable(
        _advancedPermsClaimController.text,
      ),
      authOpenIdSubfolderForRedirectUrls: subfolder,
    );
  }

  String? _currentCustomLoginMessageHtml() {
    final plainText = _customLoginMessageController.document.toPlainText().trim();
    if (plainText.isEmpty) {
      return null;
    }
    return quillDocumentToHtml(_customLoginMessageController.document);
  }

  Future<void> _saveSettings() async {
    if (_isSavingSettings || _isLoading) {
      return;
    }

    final localizations = context.l10n;

    if (!_validateSettings(showErrors: true)) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      if (mounted) {
        setState(() {
          _errorMessage = localizations.errorNoActiveApiClient;
        });
      }
      return;
    }

    setState(() {
      _isSavingSettings = true;
      _errorMessage = null;
    });

    try {
      final response = await api.getAdminApi().updateAuthenticationSettings(payload: _buildUpdateRequest());

      if (!mounted) {
        return;
      }

      if (response.data?.updated ?? false) {
        _showMessage(localizations.statusAuthenticationSettingsSaved);
      } else {
        _showMessage(localizations.statusNoChangesWereNecessary);
      }

      await _loadAuthenticationSettings(showLoading: false);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = listManagementErrorMessage(
          error,
          fallback: localizations.errorSaveAuthenticationSettingsFailed,
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSavingSettings = false;
        });
      }
    }
  }

  Future<void> _autoPopulateOpenId() async {
    if (_isAutoPopulatingOpenId || _isLoading || _isSavingSettings) {
      return;
    }

    final localizations = context.l10n;

    final normalizedIssuer = AdminAuthenticationSettingsValidation.normalizeIssuerUrlForLookup(
      _issuerUrlController.text,
    );
    if (normalizedIssuer.isEmpty) {
      setState(() {
        _issuerUrlError = localizations.validationFieldRequired(localizations.fieldIssuerUrl);
      });
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      if (mounted) {
        setState(() {
          _errorMessage = localizations.errorNoActiveApiClient;
        });
      }
      return;
    }

    setState(() {
      _isAutoPopulatingOpenId = true;
      _errorMessage = null;
    });

    try {
      final response = await api.getAdminApi().getOpenIdIssuerConfiguration(issuer: normalizedIssuer);
      final config = response.data;

      if (!mounted || config == null) {
        return;
      }

      final algorithms = config.signingAlgorithms
          .where((entry) => entry.trim().isNotEmpty)
          .toSet()
          .toList(growable: false);

      setState(() {
        if ((config.issuer ?? '').trim().isNotEmpty) {
          _issuerUrlController.text = config.issuer!.trim();
        }
        if ((config.authorizationEndpoint ?? '').trim().isNotEmpty) {
          _authorizationUrlController.text = config.authorizationEndpoint!.trim();
        }
        if ((config.tokenEndpoint ?? '').trim().isNotEmpty) {
          _tokenUrlController.text = config.tokenEndpoint!.trim();
        }
        if ((config.userInfoEndpoint ?? '').trim().isNotEmpty) {
          _userInfoUrlController.text = config.userInfoEndpoint!.trim();
        }
        if ((config.endSessionEndpoint ?? '').trim().isNotEmpty) {
          _logoutUrlController.text = config.endSessionEndpoint!.trim();
        }
        if ((config.jwksUri ?? '').trim().isNotEmpty) {
          _jwksUrlController.text = config.jwksUri!.trim();
        }

        if (algorithms.isNotEmpty) {
          _signingAlgorithmOptions = algorithms;
          if (!_signingAlgorithmOptions.contains(_selectedSigningAlgorithm)) {
            _selectedSigningAlgorithm = _signingAlgorithmOptions.first;
          }
          _signingAlgorithmController.text = _selectedSigningAlgorithm;
        } else {
          _signingAlgorithmOptions = const <String>[];
        }

        _issuerUrlError = null;
        _authorizationUrlError = null;
        _tokenUrlError = null;
        _userInfoUrlError = null;
        _jwksUrlError = null;
        _signingAlgorithmError = null;
      });

      _showMessage(localizations.statusOpenIdFieldsPopulated);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = listManagementErrorMessage(
          error,
          fallback: localizations.errorAutoPopulateOpenIdConfigurationFailed,
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isAutoPopulatingOpenId = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(context.l10n.statusNoActiveUserForAuthenticationSettings),
          );
        }

        if (!_isAdminType(currentUser.type)) {
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(context.l10n.statusAdminRequiredForAuthenticationSettings),
          );
        }

        final nextCallbackBase = _resolveCallbackBase(currentUser.server?.url);
        if (_callbackUrlBase != nextCallbackBase) {
          _callbackUrlBase = nextCallbackBase;
          _refreshCallbackPreviews();
        }

        if (_activeUserId != currentUser.id) {
          _activeUserId = currentUser.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(_loadAuthenticationSettings(showLoading: true));
          });
        }

        if (_isLoading && !_hasLoadedSettings) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: YaabsaCircularProgressIndicator()),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLoading) const YaabsaLinearProgressIndicator(minHeight: 2),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 20),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => unawaited(_loadAuthenticationSettings(showLoading: true)),
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(context.l10n.actionRefresh),
                        ),
                        if (_magicConfigKeyMarker != null)
                          OutlinedButton.icon(
                            onPressed: _isLoading || _isSavingSettings ? null : _rotateMagicKey,
                            icon: const Icon(Icons.key_outlined),
                            label: Text(context.l10n.actionRotateAuthenticationCodeKey),
                          ),
                      ],
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: AdminAuthenticationSettingsPanel(
                      customLoginMessageController: _customLoginMessageController,
                      issuerUrlController: _issuerUrlController,
                      authorizationUrlController: _authorizationUrlController,
                      tokenUrlController: _tokenUrlController,
                      userInfoUrlController: _userInfoUrlController,
                      jwksUrlController: _jwksUrlController,
                      logoutUrlController: _logoutUrlController,
                      clientIdController: _clientIdController,
                      clientSecretController: _clientSecretController,
                      signingAlgorithmController: _signingAlgorithmController,
                      buttonTextController: _buttonTextController,
                      groupClaimController: _groupClaimController,
                      advancedPermsClaimController: _advancedPermsClaimController,
                      webCallbackUrl: _webCallbackUrl,
                      mobileCallbackUrl: _mobileCallbackUrl,
                      selectedWebRedirectSubfolder: _selectedWebRedirectSubfolder,
                      showCustomLoginMessage: _showCustomLoginMessage,
                      enableLocalAuth: _enableLocalAuth,
                      enableOpenIdAuth: _enableOpenIdAuth,
                      authOpenIdAutoLaunch: _authOpenIdAutoLaunch,
                      authOpenIdAutoRegister: _authOpenIdAutoRegister,
                      obscureClientSecret: _obscureClientSecret,
                      isSavingSettings: _isSavingSettings,
                      isAutoPopulatingOpenId: _isAutoPopulatingOpenId,
                      canDisableLocalAuth: _canDisableLocalAuth,
                      mobileRedirectUris: _mobileRedirectUris,
                      matchExistingBy: _matchExistingBy,
                      signingAlgorithmOptions: _signingAlgorithmOptions,
                      selectedSigningAlgorithm: _selectedSigningAlgorithm,
                      onFieldChanged: _onFieldChanged,
                      onCustomLoginMessageChanged: _onCustomLoginMessageChanged,
                      onShowCustomLoginMessageChanged: (nextValue) {
                        setState(() {
                          _showCustomLoginMessage = nextValue;
                          _errorMessage = null;
                        });
                      },
                      onEnableLocalAuthChanged: (nextValue) {
                        unawaited(_onEnableLocalAuthChanged(nextValue));
                      },
                      onEnableOpenIdAuthChanged: (nextValue) {
                        setState(() {
                          _enableOpenIdAuth = nextValue;
                          _authMethodsError = null;
                          _errorMessage = null;
                        });
                      },
                      onAuthOpenIdAutoLaunchChanged: (nextValue) {
                        setState(() {
                          _authOpenIdAutoLaunch = nextValue;
                          _errorMessage = null;
                        });
                      },
                      onAuthOpenIdAutoRegisterChanged: (nextValue) {
                        setState(() {
                          _authOpenIdAutoRegister = nextValue;
                          _errorMessage = null;
                        });
                      },
                      onObscureClientSecretChanged: (nextValue) {
                        setState(() {
                          _obscureClientSecret = nextValue;
                        });
                      },
                      onMobileRedirectUrisChanged: _onMobileRedirectUrisChanged,
                      onMatchExistingByChanged: _onMatchExistingByChanged,
                      onSelectedSigningAlgorithmChanged: _onSelectedSigningAlgorithmChanged,
                      onSelectedWebRedirectSubfolderChanged: _onSelectedWebRedirectSubfolderChanged,
                      onAutoPopulateOpenId: _autoPopulateOpenId,
                      authMethodsError: _authMethodsError,
                      issuerUrlError: _issuerUrlError,
                      authorizationUrlError: _authorizationUrlError,
                      tokenUrlError: _tokenUrlError,
                      userInfoUrlError: _userInfoUrlError,
                      jwksUrlError: _jwksUrlError,
                      clientIdError: _clientIdError,
                      clientSecretError: _clientSecretError,
                      signingAlgorithmError: _signingAlgorithmError,
                      redirectUrisError: _redirectUrisError,
                      groupClaimError: _groupClaimError,
                      advancedPermsClaimError: _advancedPermsClaimError,
                      subfolderError: _subfolderError,
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.7)),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final stacked = constraints.maxWidth < 760;
                    final saveButton = FilledButton.icon(
                      onPressed: _canSaveSettings ? _saveSettings : null,
                      icon: _isSavingSettings
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: YaabsaCircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(context.l10n.actionSaveAuthenticationSettings),
                    );

                    if (stacked) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_enableOpenIdAuth)
                            Text(
                              context.l10n.hintOpenIdChangesMayRequireRestart,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          if (_enableOpenIdAuth) const SizedBox(height: 8),
                          SizedBox(width: double.infinity, child: saveButton),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        if (_enableOpenIdAuth)
                          Expanded(
                            child: Text(
                              context.l10n.hintOpenIdChangesMayRequireRestart,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          ),
                        if (_enableOpenIdAuth) const SizedBox(width: 12),
                        saveButton,
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: YaabsaCircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Text(
          context.l10n.errorLoadUserAuthenticationSettingsFailed(error.toString()),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
