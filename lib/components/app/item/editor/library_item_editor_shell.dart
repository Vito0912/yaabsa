import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/globals.dart';

class LibraryItemEditorShell extends StatefulWidget {
  const LibraryItemEditorShell({
    super.key,
    required this.itemTitle,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelectDestination,
    required this.showItemNavigation,
    required this.onPreviousItem,
    required this.onNextItem,
    required this.onClose,
    required this.child,
    this.onBackToSelector,
  });

  final String itemTitle;
  final List<({String label, IconData icon})> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelectDestination;
  final bool showItemNavigation;
  final VoidCallback? onPreviousItem;
  final VoidCallback? onNextItem;
  final VoidCallback onClose;
  final Widget child;
  final VoidCallback? onBackToSelector;

  @override
  State<LibraryItemEditorShell> createState() => _LibraryItemEditorShellState();
}

class _LibraryItemEditorShellState extends State<LibraryItemEditorShell> {
  var _showMobileDestinations = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (context.isMobile) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Stack(
              children: [
                SizedBox(width: double.infinity, height: _showMobileDestinations ? 0 : constraints.maxHeight),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: constraints.maxHeight,
                  child: Offstage(
                    offstage: _showMobileDestinations,
                    child: TickerMode(
                      enabled: !_showMobileDestinations,
                      child: Material(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(18),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            _buildMobileHeader(context, showSelector: false),
                            Expanded(child: widget.child),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (_showMobileDestinations)
                  Material(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMobileHeader(context, showSelector: true),
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView(
                            shrinkWrap: true,
                            primary: false,
                            padding: const EdgeInsets.all(12),
                            children: [
                              for (var index = 0; index < widget.destinations.length; index++)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Material(
                                    color: widget.selectedIndex == index
                                        ? colorScheme.secondaryContainer
                                        : colorScheme.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    clipBehavior: Clip.antiAlias,
                                    child: ListTile(
                                      leading: Icon(widget.destinations[index].icon),
                                      title: Text(widget.destinations[index].label),
                                      trailing: const Icon(Icons.chevron_right_rounded),
                                      selected: widget.selectedIndex == index,
                                      selectedColor: colorScheme.onSecondaryContainer,
                                      onTap: () {
                                        setState(() {
                                          _showMobileDestinations = false;
                                        });
                                        widget.onSelectDestination(index);
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 96,
          child: Material(
            color: colorScheme.surfaceContainerLow,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (var index = 0; index < widget.destinations.length; index++)
                  _EditorRailDestination(
                    label: widget.destinations[index].label,
                    icon: widget.destinations[index].icon,
                    selected: widget.selectedIndex == index,
                    onTap: () => widget.onSelectDestination(index),
                  ),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Column(
            children: [
              Material(
                color: colorScheme.surfaceContainerLow,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                  child: Row(
                    children: [
                      Expanded(child: Text('Edit item', style: theme.textTheme.titleSmall)),
                      if (widget.showItemNavigation) ...[
                        IconButton(
                          onPressed: widget.onPreviousItem,
                          tooltip: 'Previous item',
                          icon: const Icon(Icons.arrow_back_rounded, size: 20),
                        ),
                        IconButton(
                          onPressed: widget.onNextItem,
                          tooltip: 'Next item',
                          icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                        ),
                      ],
                      IconButton(
                        onPressed: widget.onClose,
                        tooltip: 'Close editor',
                        icon: const Icon(Icons.close_rounded, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(child: widget.child),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHeader(BuildContext context, {required bool showSelector}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          if (!showSelector)
            IconButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                widget.onBackToSelector?.call();
                setState(() {
                  _showMobileDestinations = true;
                });
              },
              tooltip: 'Back to editor sections',
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          Expanded(
            child: Text(
              showSelector ? widget.itemTitle : widget.destinations[widget.selectedIndex].label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (showSelector && widget.showItemNavigation) ...[
            IconButton(
              onPressed: widget.onPreviousItem,
              tooltip: 'Previous item',
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
            ),
            IconButton(
              onPressed: widget.onNextItem,
              tooltip: 'Next item',
              icon: const Icon(Icons.arrow_forward_rounded, size: 20),
            ),
          ],
          IconButton(onPressed: widget.onClose, tooltip: 'Close editor', icon: const Icon(Icons.close_rounded)),
        ],
      ),
    );
  }
}

class _EditorRailDestination extends StatelessWidget {
  const _EditorRailDestination({required this.label, required this.icon, required this.selected, required this.onTap});

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final foregroundColor = selected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant;

    return Semantics(
      selected: selected,
      button: true,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 32,
                  decoration: BoxDecoration(
                    color: selected ? colorScheme.secondaryContainer : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: foregroundColor, size: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: foregroundColor,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
