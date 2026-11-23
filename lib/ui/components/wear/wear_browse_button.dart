import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/wear/wear_list_item_content.dart';

class WearBrowseButton extends StatelessWidget {
  const WearBrowseButton({
    required this.title,
    required this.onPressed,
    this.subtitle,
    this.icon,
    this.leading,
    this.primary = false,
    this.destructive = false,
    this.supporting,
    this.trailing,
    this.titleLines = 1,
    this.progress,
    this.loading = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? leading;
  final VoidCallback? onPressed;
  final bool primary;
  final bool destructive;
  final Widget? supporting;
  final Widget? trailing;
  final int titleLines;
  final double? progress;
  final bool loading;

  Widget _buildProgressBackground(BuildContext context, Set<WidgetState> states, Widget? child) {
    final value = (progress ?? 0).clamp(0.0, 1.0);
    final color = Theme.of(context).colorScheme.primary.withValues(alpha: 0.25);
    return ClipPath(
      clipper: const ShapeBorderClipper(shape: StadiumBorder()),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: value,
              child: ColoredBox(color: color),
            ),
          ),
          ?child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Color background = colors.surfaceContainerHigh.withValues(alpha: 0.88);
    Color foreground = colors.onSurface;
    if (destructive) {
      background = colors.errorContainer.withValues(alpha: 0.90);
      foreground = colors.onErrorContainer;
    } else if (primary) {
      background = colors.primary.withValues(alpha: 0.95);
      foreground = colors.onPrimary;
    }

    final image = leading;
    Widget? prefix = image;
    if (loading) {
      prefix = const SizedBox.square(
        dimension: 28,
        child: Padding(padding: EdgeInsets.all(4), child: YaabsaCircularProgressIndicator(strokeWidth: 2, size: 20)),
      );
    } else if (prefix == null && icon != null) {
      prefix = Icon(icon, size: 28);
    }

    final hasLeading = prefix != null;
    final suffix = trailing;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          minimumSize: Size.fromHeight(primary ? 56 : 52),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          shape: const StadiumBorder(),
          side: BorderSide.none,
          alignment: hasLeading ? Alignment.centerLeft : Alignment.center,
          backgroundBuilder: progress == null ? null : _buildProgressBackground,
        ),
        child: WearListItemContent(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (prefix != null) ...[prefix, const SizedBox(width: 8)],
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: hasLeading ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          textAlign: hasLeading ? TextAlign.start : TextAlign.center,
                          maxLines: titleLines,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: primary ? 16 : 14, fontWeight: FontWeight.w500, height: 1.15),
                        ),
                        if (subtitle?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            textAlign: hasLeading ? TextAlign.start : TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, height: 1.2, color: foreground.withValues(alpha: 0.75)),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (suffix != null) ...[const SizedBox(width: 6), suffix],
                ],
              ),
              if (supporting != null) ...[const SizedBox(height: 10), supporting!],
            ],
          ),
        ),
      ),
    );
  }
}
