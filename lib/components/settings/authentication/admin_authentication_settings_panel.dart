import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:yaabsa/components/common/expressive_expandable_card.dart';
import 'package:yaabsa/components/common/inputs/string_chip_list_input.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/common/inputs/rich_text_quill_field.dart';

class AdminAuthenticationSettingsPanel extends StatelessWidget {
  const AdminAuthenticationSettingsPanel({
    super.key,
    required this.customLoginMessageController,
    required this.issuerUrlController,
    required this.authorizationUrlController,
    required this.tokenUrlController,
    required this.userInfoUrlController,
    required this.jwksUrlController,
    required this.logoutUrlController,
    required this.clientIdController,
    required this.clientSecretController,
    required this.signingAlgorithmController,
    required this.buttonTextController,
    required this.groupClaimController,
    required this.advancedPermsClaimController,
    required this.webCallbackUrl,
    required this.mobileCallbackUrl,
    required this.selectedWebRedirectSubfolder,
    required this.showCustomLoginMessage,
    required this.enableLocalAuth,
    required this.enableOpenIdAuth,
    required this.authOpenIdAutoLaunch,
    required this.authOpenIdAutoRegister,
    required this.obscureClientSecret,
    required this.isSavingSettings,
    required this.isAutoPopulatingOpenId,
    required this.canDisableLocalAuth,
    required this.mobileRedirectUris,
    required this.matchExistingBy,
    required this.signingAlgorithmOptions,
    required this.selectedSigningAlgorithm,
    required this.onFieldChanged,
    required this.onCustomLoginMessageChanged,
    required this.onShowCustomLoginMessageChanged,
    required this.onEnableLocalAuthChanged,
    required this.onEnableOpenIdAuthChanged,
    required this.onAuthOpenIdAutoLaunchChanged,
    required this.onAuthOpenIdAutoRegisterChanged,
    required this.onObscureClientSecretChanged,
    required this.onMobileRedirectUrisChanged,
    required this.onMatchExistingByChanged,
    required this.onSelectedSigningAlgorithmChanged,
    required this.onSelectedWebRedirectSubfolderChanged,
    required this.onAutoPopulateOpenId,
    this.authMethodsError,
    this.issuerUrlError,
    this.authorizationUrlError,
    this.tokenUrlError,
    this.userInfoUrlError,
    this.jwksUrlError,
    this.clientIdError,
    this.clientSecretError,
    this.signingAlgorithmError,
    this.redirectUrisError,
    this.groupClaimError,
    this.advancedPermsClaimError,
    this.subfolderError,
  });

  final QuillController customLoginMessageController;
  final TextEditingController issuerUrlController;
  final TextEditingController authorizationUrlController;
  final TextEditingController tokenUrlController;
  final TextEditingController userInfoUrlController;
  final TextEditingController jwksUrlController;
  final TextEditingController logoutUrlController;
  final TextEditingController clientIdController;
  final TextEditingController clientSecretController;
  final TextEditingController signingAlgorithmController;
  final TextEditingController buttonTextController;
  final TextEditingController groupClaimController;
  final TextEditingController advancedPermsClaimController;
  final String webCallbackUrl;
  final String mobileCallbackUrl;
  final String selectedWebRedirectSubfolder;

  final bool showCustomLoginMessage;
  final bool enableLocalAuth;
  final bool enableOpenIdAuth;
  final bool authOpenIdAutoLaunch;
  final bool authOpenIdAutoRegister;
  final bool obscureClientSecret;
  final bool isSavingSettings;
  final bool isAutoPopulatingOpenId;
  final bool canDisableLocalAuth;

  final List<String> mobileRedirectUris;
  final String matchExistingBy;
  final List<String> signingAlgorithmOptions;
  final String selectedSigningAlgorithm;

  final ValueChanged<String> onFieldChanged;
  final VoidCallback onCustomLoginMessageChanged;
  final ValueChanged<bool> onShowCustomLoginMessageChanged;
  final ValueChanged<bool> onEnableLocalAuthChanged;
  final ValueChanged<bool> onEnableOpenIdAuthChanged;
  final ValueChanged<bool> onAuthOpenIdAutoLaunchChanged;
  final ValueChanged<bool> onAuthOpenIdAutoRegisterChanged;
  final ValueChanged<bool> onObscureClientSecretChanged;
  final ValueChanged<List<String>> onMobileRedirectUrisChanged;
  final ValueChanged<String> onMatchExistingByChanged;
  final ValueChanged<String> onSelectedSigningAlgorithmChanged;
  final ValueChanged<String> onSelectedWebRedirectSubfolderChanged;
  final VoidCallback onAutoPopulateOpenId;

  final String? authMethodsError;
  final String? issuerUrlError;
  final String? authorizationUrlError;
  final String? tokenUrlError;
  final String? userInfoUrlError;
  final String? jwksUrlError;
  final String? clientIdError;
  final String? clientSecretError;
  final String? signingAlgorithmError;
  final String? redirectUrisError;
  final String? groupClaimError;
  final String? advancedPermsClaimError;
  final String? subfolderError;

  bool get _canEditFields => !isSavingSettings && !isAutoPopulatingOpenId;

  Widget _buildErrorText(BuildContext context, String? errorText) {
    if (errorText == null || errorText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        errorText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context, {required String label, required String value}) async {
    if (value.trim().isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$label copied.')));
  }

  Widget _buildCallbackUrlRow(BuildContext context, {required String label, required String value}) {
    final canCopy = value.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: SelectableText(value.trim().isEmpty ? '-' : value, style: Theme.of(context).textTheme.bodyMedium),
            ),
            IconButton(
              tooltip: 'Copy URL',
              onPressed: canCopy ? () => _copyToClipboard(context, label: label, value: value) : null,
              icon: const Icon(Icons.copy_rounded),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExpressiveExpandableCard(
          margin: EdgeInsets.zero,
          title: 'Custom Login Message',
          icon: Icons.message_outlined,
          initiallyExpanded: true,
          children: [
            SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: const Text('Show custom login message'),
              value: showCustomLoginMessage,
              onChanged: _canEditFields ? onShowCustomLoginMessageChanged : null,
            ),
            if (showCustomLoginMessage) ...[
              const SizedBox(height: 8),
              RichTextQuillField(
                label: 'Login Message',
                controller: customLoginMessageController,
                enabled: _canEditFields,
                editorHeight: 100,
                onChanged: onCustomLoginMessageChanged,
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        ExpressiveExpandableCard(
          margin: EdgeInsets.zero,
          title: 'Auth',
          icon: Icons.security_rounded,
          initiallyExpanded: false,
          children: [
            SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: const Text('Enable local authentication'),
              value: enableLocalAuth,
              onChanged: _canEditFields && (!enableLocalAuth || canDisableLocalAuth) ? onEnableLocalAuthChanged : null,
            ),
            if (enableLocalAuth && !canDisableLocalAuth)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'OpenID must be configured before local authentication can be disabled.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: const Text('Enable OpenID authentication'),
              value: enableOpenIdAuth,
              onChanged: _canEditFields ? onEnableOpenIdAuthChanged : null,
            ),
            if (enableOpenIdAuth) ...[
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  final stacked = constraints.maxWidth < 760;
                  final issuerField = StyledTextField(
                    label: 'Issuer URL',
                    controller: issuerUrlController,
                    enabled: _canEditFields,
                    errorText: issuerUrlError,
                    onChanged: onFieldChanged,
                  );

                  final autoPopulateButton = FilledButton.icon(
                    onPressed: _canEditFields ? onAutoPopulateOpenId : null,
                    icon: isAutoPopulatingOpenId
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.auto_fix_high_rounded),
                    label: const Text('Auto-populate'),
                  );

                  if (stacked) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [issuerField, const SizedBox(height: 8), autoPopulateButton],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: issuerField),
                      const SizedBox(width: 8),
                      Padding(padding: const EdgeInsets.only(top: 2), child: autoPopulateButton),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              StyledTextField(
                label: 'Authorize URL',
                controller: authorizationUrlController,
                enabled: _canEditFields,
                errorText: authorizationUrlError,
                onChanged: onFieldChanged,
              ),
              const SizedBox(height: 8),
              StyledTextField(
                label: 'Token URL',
                controller: tokenUrlController,
                enabled: _canEditFields,
                errorText: tokenUrlError,
                onChanged: onFieldChanged,
              ),
              const SizedBox(height: 8),
              StyledTextField(
                label: 'Userinfo URL',
                controller: userInfoUrlController,
                enabled: _canEditFields,
                errorText: userInfoUrlError,
                onChanged: onFieldChanged,
              ),
              const SizedBox(height: 8),
              StyledTextField(
                label: 'JWKS URL',
                controller: jwksUrlController,
                enabled: _canEditFields,
                errorText: jwksUrlError,
                onChanged: onFieldChanged,
              ),
              const SizedBox(height: 8),
              StyledTextField(
                label: 'Logout URL',
                controller: logoutUrlController,
                enabled: _canEditFields,
                onChanged: onFieldChanged,
              ),
              const SizedBox(height: 8),
              StyledTextField(
                label: 'Client ID',
                controller: clientIdController,
                enabled: _canEditFields,
                errorText: clientIdError,
                onChanged: onFieldChanged,
              ),
              const SizedBox(height: 8),
              StyledTextField(
                label: 'Client Secret',
                controller: clientSecretController,
                enabled: _canEditFields,
                errorText: clientSecretError,
                obscureText: obscureClientSecret,
                onChanged: onFieldChanged,
                suffixIcon: IconButton(
                  tooltip: obscureClientSecret ? 'Show secret' : 'Hide secret',
                  onPressed: _canEditFields ? () => onObscureClientSecretChanged(!obscureClientSecret) : null,
                  icon: Icon(obscureClientSecret ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                ),
              ),
              const SizedBox(height: 8),
              if (signingAlgorithmOptions.isNotEmpty)
                YaabsaDropdownField<String>(
                  label: 'Signing Algorithm',
                  value: signingAlgorithmOptions.contains(selectedSigningAlgorithm)
                      ? selectedSigningAlgorithm
                      : signingAlgorithmOptions.first,
                  enabled: _canEditFields,
                  onChanged: (next) {
                    if (next != null) {
                      onSelectedSigningAlgorithmChanged(next);
                    }
                  },
                  items: signingAlgorithmOptions
                      .map((entry) => DropdownMenuItem<String>(value: entry, child: Text(entry)))
                      .toList(growable: false),
                )
              else
                StyledTextField(
                  label: 'Signing Algorithm',
                  controller: signingAlgorithmController,
                  enabled: _canEditFields,
                  errorText: signingAlgorithmError,
                  onChanged: onFieldChanged,
                ),
              if (signingAlgorithmOptions.isNotEmpty) _buildErrorText(context, signingAlgorithmError),
              const SizedBox(height: 8),
              StringChipListInput(
                label: 'Mobile Redirect URIs',
                values: mobileRedirectUris,
                enabled: _canEditFields,
                hintText: 'audiobookshelf://oauth',
                helperText: 'Add one URI per entry. Use * only as a single standalone entry.',
                onChanged: onMobileRedirectUrisChanged,
              ),
              _buildErrorText(context, redirectUrisError),
              const SizedBox(height: 8),
              YaabsaDropdownField<String>(
                label: 'Web Redirect Subfolder',
                value: const <String>['/', '/audiobookshelf'].contains(selectedWebRedirectSubfolder)
                    ? selectedWebRedirectSubfolder
                    : '/',
                enabled: _canEditFields,
                onChanged: (next) {
                  if (next != null) {
                    onSelectedWebRedirectSubfolderChanged(next);
                  }
                },
                items: const [
                  DropdownMenuItem<String>(value: '/', child: Text('/')),
                  DropdownMenuItem<String>(value: '/audiobookshelf', child: Text('/audiobookshelf')),
                ],
              ),
              _buildErrorText(context, subfolderError),
              const SizedBox(height: 8),
              _buildCallbackUrlRow(context, label: 'Web Callback URL', value: webCallbackUrl),
              const SizedBox(height: 8),
              _buildCallbackUrlRow(context, label: 'Mobile Callback URL', value: mobileCallbackUrl),
              const SizedBox(height: 8),
              StyledTextField(
                label: 'OpenID Button Text',
                controller: buttonTextController,
                enabled: _canEditFields,
                onChanged: onFieldChanged,
              ),
              const SizedBox(height: 8),
              YaabsaDropdownField<String>(
                label: 'Match Existing Users By',
                value: const <String>['', 'email', 'username'].contains(matchExistingBy) ? matchExistingBy : '',
                enabled: _canEditFields,
                onChanged: (next) => onMatchExistingByChanged(next ?? ''),
                items: const [
                  DropdownMenuItem<String>(value: '', child: Text('Do not match')),
                  DropdownMenuItem<String>(value: 'email', child: Text('Match by email')),
                  DropdownMenuItem<String>(value: 'username', child: Text('Match by username')),
                ],
              ),
              const SizedBox(height: 8),
              SwitchListTile.adaptive(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: const Text('Auto-launch OpenID login'),
                subtitle: const Text('Automatically redirect users to OpenID sign-in on the login page.'),
                value: authOpenIdAutoLaunch,
                onChanged: _canEditFields ? onAuthOpenIdAutoLaunchChanged : null,
              ),
              SwitchListTile.adaptive(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: const Text('Auto-register OpenID users'),
                subtitle: const Text('Create local users automatically when OpenID users sign in for the first time.'),
                value: authOpenIdAutoRegister,
                onChanged: _canEditFields ? onAuthOpenIdAutoRegisterChanged : null,
              ),
              const SizedBox(height: 8),
              StyledTextField(
                label: 'Group Claim',
                controller: groupClaimController,
                enabled: _canEditFields,
                hintText: 'groups',
                errorText: groupClaimError,
                onChanged: onFieldChanged,
              ),
              const SizedBox(height: 8),
              StyledTextField(
                label: 'Advanced Permission Claim',
                controller: advancedPermsClaimController,
                enabled: _canEditFields,
                hintText: 'abspermissions',
                errorText: advancedPermsClaimError,
                onChanged: onFieldChanged,
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        if (authMethodsError != null && authMethodsError!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              authMethodsError!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }
}
