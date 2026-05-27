import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';

class AdminEmailSettingsPanel extends StatelessWidget {
  const AdminEmailSettingsPanel({
    super.key,
    required this.hostController,
    required this.portController,
    required this.userController,
    required this.passwordController,
    required this.fromAddressController,
    required this.testAddressController,
    required this.secure,
    required this.rejectUnauthorized,
    required this.obscurePassword,
    required this.isSavingSettings,
    required this.isSendingTest,
    required this.canSaveSettings,
    required this.canSendTest,
    required this.onHostChanged,
    required this.onPortChanged,
    required this.onUserChanged,
    required this.onPasswordChanged,
    required this.onFromAddressChanged,
    required this.onTestAddressChanged,
    required this.onSecureChanged,
    required this.onRejectUnauthorizedChanged,
    required this.onObscurePasswordChanged,
    required this.onSaveSettings,
    required this.onSendTestEmail,
    this.hostError,
    this.portError,
    this.fromAddressError,
    this.testAddressError,
  });

  final TextEditingController hostController;
  final TextEditingController portController;
  final TextEditingController userController;
  final TextEditingController passwordController;
  final TextEditingController fromAddressController;
  final TextEditingController testAddressController;

  final bool secure;
  final bool rejectUnauthorized;
  final bool obscurePassword;

  final bool isSavingSettings;
  final bool isSendingTest;
  final bool canSaveSettings;
  final bool canSendTest;

  final ValueChanged<String> onHostChanged;
  final ValueChanged<String> onPortChanged;
  final ValueChanged<String> onUserChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onFromAddressChanged;
  final ValueChanged<String> onTestAddressChanged;
  final ValueChanged<bool> onSecureChanged;
  final ValueChanged<bool> onRejectUnauthorizedChanged;
  final ValueChanged<bool> onObscurePasswordChanged;
  final VoidCallback onSaveSettings;
  final VoidCallback onSendTestEmail;

  final String? hostError;
  final String? portError;
  final String? fromAddressError;
  final String? testAddressError;

  @override
  Widget build(BuildContext context) {
    final canEditFields = !isSavingSettings && !isSendingTest;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.alternate_email_rounded, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'SMTP Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Configure server email delivery and send a test message to verify connectivity.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 620;
                if (stacked) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StyledTextField(
                        label: 'Host',
                        controller: hostController,
                        enabled: canEditFields,
                        hintText: 'smtp.example.com',
                        errorText: hostError,
                        onChanged: onHostChanged,
                      ),
                      const SizedBox(height: 8),
                      StyledTextField(
                        label: 'Port',
                        controller: portController,
                        enabled: canEditFields,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        hintText: '465',
                        errorText: portError,
                        onChanged: onPortChanged,
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: StyledTextField(
                        label: 'Host',
                        controller: hostController,
                        enabled: canEditFields,
                        hintText: 'smtp.example.com',
                        errorText: hostError,
                        onChanged: onHostChanged,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StyledTextField(
                        label: 'Port',
                        controller: portController,
                        enabled: canEditFields,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        hintText: '465',
                        errorText: portError,
                        onChanged: onPortChanged,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 6),
            LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 620;
                final usernameField = StyledTextField(
                  label: 'Username',
                  controller: userController,
                  enabled: canEditFields,
                  onChanged: onUserChanged,
                );
                final passwordField = StyledTextField(
                  label: 'Password',
                  controller: passwordController,
                  enabled: canEditFields,
                  obscureText: obscurePassword,
                  onChanged: onPasswordChanged,
                  suffixIcon: IconButton(
                    tooltip: obscurePassword ? 'Show password' : 'Hide password',
                    onPressed: canEditFields ? () => onObscurePasswordChanged(!obscurePassword) : null,
                    icon: Icon(obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  ),
                );

                if (stacked) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [usernameField, const SizedBox(height: 8), passwordField],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: usernameField),
                    const SizedBox(width: 8),
                    Expanded(child: passwordField),
                  ],
                );
              },
            ),
            const SizedBox(height: 6),
            LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 620;
                final fromField = StyledTextField(
                  label: 'From Address',
                  controller: fromAddressController,
                  enabled: canEditFields,
                  keyboardType: TextInputType.emailAddress,
                  errorText: fromAddressError,
                  onChanged: onFromAddressChanged,
                );
                final testField = StyledTextField(
                  label: 'Test Address',
                  controller: testAddressController,
                  enabled: canEditFields,
                  keyboardType: TextInputType.emailAddress,
                  errorText: testAddressError,
                  onChanged: onTestAddressChanged,
                );

                if (stacked) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [fromField, const SizedBox(height: 8), testField],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: fromField),
                    const SizedBox(width: 8),
                    Expanded(child: testField),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: const Text('Use secure SMTP connection'),
              value: secure,
              onChanged: canEditFields ? onSecureChanged : null,
            ),
            SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: const Text('Reject unauthorized certificates'),
              subtitle: const Text('Disable only if your SMTP server uses self-signed certificates.'),
              value: rejectUnauthorized,
              onChanged: canEditFields ? onRejectUnauthorizedChanged : null,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: canSendTest ? onSendTestEmail : null,
                  icon: isSendingTest
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.mark_email_read_outlined),
                  label: const Text('Send Test'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: canSaveSettings ? onSaveSettings : null,
                  icon: isSavingSettings
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save_outlined),
                  label: const Text('Save Settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
