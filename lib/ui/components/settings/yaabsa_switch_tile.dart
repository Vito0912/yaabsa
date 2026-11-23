import 'package:material_ui/material_ui.dart';

class YaabsaSwitchTile extends StatelessWidget {
  const YaabsaSwitchTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.secondary,
    this.controlAffinity,
    this.dense,
    this.contentPadding,
  }) : adaptive = false;

  const YaabsaSwitchTile.adaptive({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.secondary,
    this.controlAffinity,
    this.dense,
    this.contentPadding,
  }) : adaptive = true;

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final Widget? secondary;
  final ListTileControlAffinity? controlAffinity;
  final bool? dense;
  final EdgeInsetsGeometry? contentPadding;
  final bool adaptive;

  @override
  Widget build(BuildContext context) {
    if (adaptive) {
      return SwitchListTile.adaptive(
        value: value,
        onChanged: onChanged,
        title: title,
        subtitle: subtitle,
        secondary: secondary,
        controlAffinity: controlAffinity,
        dense: dense,
        contentPadding: contentPadding,
      );
    }

    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: title,
      subtitle: subtitle,
      secondary: secondary,
      controlAffinity: controlAffinity,
      dense: dense,
      contentPadding: contentPadding,
    );
  }
}
