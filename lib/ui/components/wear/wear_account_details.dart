import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/l10n.dart';

class WearAccountIdentity extends StatelessWidget {
  const WearAccountIdentity({required this.username, required this.roleLabel, super.key});

  final String username;
  final String roleLabel;

  static String formatRole(AppLocalizations localizations, String userType) {
    final role = switch (userType.toLowerCase()) {
      'root' || 'admin' => 'admin',
      'guest' => 'guest',
      _ => 'listener',
    };

    return localizations.accountRoleLabel(role);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final name = username.trim();
    final initial = name.isEmpty ? '?' : name.characters.first.toUpperCase();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
      child: Column(
        children: [
          ExcludeSemantics(
            child: CircleAvatar(
              radius: 26,
              backgroundColor: colors.primaryContainer,
              foregroundColor: colors.onPrimaryContainer,
              child: Text(initial, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            roleLabel,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class WearAccountServerDetails extends StatelessWidget {
  const WearAccountServerDetails({required this.serverUrl, required this.reachable, super.key});

  final String serverUrl;
  final bool reachable;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final uri = Uri.tryParse(serverUrl);
    var displayUrl = context.l10n.statusServerAddressUnavailable;
    if (uri != null && uri.hasAuthority) {
      displayUrl = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.hasPort ? uri.port : null,
        path: uri.path,
      ).toString();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(color: colors.surfaceContainer, borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.dns_outlined, size: 20, color: colors.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.fieldServer,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(displayUrl, style: const TextStyle(fontSize: 12, height: 1.2, decoration: TextDecoration.none)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    reachable ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
                    size: 16,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      reachable ? context.l10n.statusServerAvailable : context.l10n.statusServerUnavailable,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
