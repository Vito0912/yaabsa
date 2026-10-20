import 'package:material_ui/material_ui.dart';

class ReaderProgressControls extends StatefulWidget {
  const ReaderProgressControls({
    super.key,
    required this.visible,
    required this.ready,
    required this.includeBottomSafeArea,
    required this.progress,
    required this.chapter,
    required this.fraction,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    required this.onContents,
    required this.onToggleControls,
    required this.onSeek,
  });

  final bool visible;
  final bool ready;
  final bool includeBottomSafeArea;
  final String progress;
  final String chapter;
  final double fraction;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onContents;
  final VoidCallback onToggleControls;
  final ValueChanged<double> onSeek;

  @override
  State<ReaderProgressControls> createState() => _ReaderProgressControlsState();
}

class _ReaderProgressControlsState extends State<ReaderProgressControls> {
  double? _pendingFraction;

  @override
  Widget build(BuildContext context) {
    if (!widget.ready) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final visible = widget.visible;
    final fraction = _pendingFraction ?? widget.fraction;

    return Material(
      color: theme.colorScheme.surface,
      elevation: visible ? 2 : 0,
      borderRadius: visible ? const BorderRadius.vertical(top: Radius.circular(24)) : null,
      child: SafeArea(
        top: false,
        bottom: widget.includeBottomSafeArea,
        child: visible
            ? Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Previous page',
                          onPressed: widget.canGoPrevious ? widget.onPrevious : null,
                          icon: const Icon(Icons.chevron_left_rounded),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                widget.chapter,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelLarge,
                              ),
                              Text(
                                _pendingFraction == null ? widget.progress : '${(fraction * 100).round()}%',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Next page',
                          onPressed: widget.canGoNext ? widget.onNext : null,
                          icon: const Icon(Icons.chevron_right_rounded),
                        ),
                      ],
                    ),
                    Semantics(
                      label: 'Reading position',
                      child: Slider(
                        value: fraction,
                        label: '${(fraction * 100).round()}%',
                        onChanged: (value) {
                          setState(() {
                            _pendingFraction = value;
                          });
                        },
                        onChangeEnd: (value) {
                          widget.onSeek(value);
                          setState(() {
                            _pendingFraction = null;
                          });
                        },
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 16,
                      children: [
                        TextButton.icon(
                          onPressed: widget.onContents,
                          icon: const Icon(Icons.format_list_bulleted_rounded, size: 20),
                          label: const Text('Contents & notes'),
                        ),
                        TextButton.icon(
                          onPressed: widget.onToggleControls,
                          icon: const Icon(Icons.fullscreen_rounded, size: 20),
                          label: const Text('Focus'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : InkWell(
                onTap: widget.onToggleControls,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.chapter,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(widget.progress, style: theme.textTheme.labelSmall),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
