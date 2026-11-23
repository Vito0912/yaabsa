import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/wear/wear_browse_button.dart';
import 'package:yaabsa/ui/components/wear/wear_browse_scaffold.dart';

class WearConfirmationScreen extends StatelessWidget {
  const WearConfirmationScreen({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.icon,
    this.destructive = false,
    this.flatScrolling = false,
    this.nowOverride,
    super.key,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final IconData icon;
  final bool destructive;
  final bool flatScrolling;
  final DateTime? nowOverride;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Icon(icon, size: 36, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
        child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
      ),
      WearBrowseButton(title: 'Cancel', icon: Icons.close, onPressed: () => Navigator.of(context).pop(false)),
      WearBrowseButton(
        title: confirmLabel,
        icon: icon,
        destructive: destructive,
        primary: !destructive,
        onPressed: () => Navigator.of(context).pop(true),
      ),
    ];
    return WearBrowseScaffoldView(
      title: title,
      flatScrolling: flatScrolling,
      nowOverride: nowOverride,
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
