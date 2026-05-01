import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInAuthSection extends StatelessWidget {
  const SignInAuthSection({
    super.key,
    required this.useApiKey,
    required this.isLoading,
    required this.allowsLocal,
    required this.allowsOpenId,
    required this.openIdButtonText,
    required this.usernameController,
    required this.passwordController,
    required this.apiKeyController,
    required this.onValidateAndSignIn,
    required this.onStartOpenIdConnect,
  });

  final bool useApiKey;
  final bool isLoading;
  final bool allowsLocal;
  final bool allowsOpenId;
  final String openIdButtonText;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController apiKeyController;
  final VoidCallback onValidateAndSignIn;
  final VoidCallback onStartOpenIdConnect;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (useApiKey) ...[
          const SizedBox(height: 12),
          TextField(
            controller: apiKeyController,
            enabled: !isLoading,
            obscureText: true,
            onSubmitted: (_) => onValidateAndSignIn(),
            decoration: InputDecoration(
              labelText: 'API Key',
              prefixIcon: const Icon(Icons.key_rounded),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: isLoading ? null : onValidateAndSignIn,
            icon: isLoading
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary),
                  )
                : const Icon(Icons.vpn_key_rounded),
            label: Text(isLoading ? 'Signing in...' : 'Connect with API Key'),
          ),
        ] else if (allowsLocal) ...[
          const SizedBox(height: 18),
          AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: usernameController,
                  enabled: !isLoading,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.username, AutofillHints.email],
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  enabled: !isLoading,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    TextInput.finishAutofillContext(shouldSave: true);
                    onValidateAndSignIn();
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.password_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: isLoading
                ? null
                : () {
                    TextInput.finishAutofillContext(shouldSave: true);
                    onValidateAndSignIn();
                  },
            icon: isLoading
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary),
                  )
                : const Icon(Icons.login_rounded),
            label: Text(isLoading ? 'Signing in...' : 'Sign In'),
          ),
        ],
        if (!useApiKey && allowsOpenId) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: isLoading ? null : onStartOpenIdConnect,
            icon: const Icon(Icons.shield_outlined),
            label: Text(openIdButtonText),
          ),
        ],
        if (!useApiKey && !allowsLocal && !allowsOpenId) ...[
          const SizedBox(height: 12),
          Text(
            'No supported authentication method is enabled on this server.',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
          ),
        ],
      ],
    );
  }
}
