import 'package:flutter/material.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';

import 'package:yaabsa/generated/l10n.dart';

typedef PlayerPlacementVisiblePredicate = bool Function(PlayerComponentPlacement placement);
typedef PlayerPlacementWidgetBuilder = Widget Function(PlayerComponentPlacement placement);
typedef PlayerPlacementMoveCallback = void Function(PlayerComponentType type, int deltaX, int deltaY);
typedef PlayerPlacementResizeCallback = void Function(PlayerComponentType type, int deltaWidth, int deltaHeight);
typedef PlayerPlacementActionCallback = void Function(PlayerComponentType type);

class PlayerGridCanvas extends StatelessWidget {
  const PlayerGridCanvas({
    super.key,
    required this.screenSize,
    required this.profile,
    required this.editMode,
    required this.isPlacementVisible,
    required this.componentBuilder,
    this.onMovePlacement,
    this.onResizePlacement,
    this.onOpenSettings,
    this.onHidePlacement,
  });

  final PlayerLayoutScreenSize screenSize;
  final PlayerLayoutProfile profile;
  final bool editMode;
  final PlayerPlacementVisiblePredicate isPlacementVisible;
  final PlayerPlacementWidgetBuilder componentBuilder;
  final PlayerPlacementMoveCallback? onMovePlacement;
  final PlayerPlacementResizeCallback? onResizePlacement;
  final PlayerPlacementActionCallback? onOpenSettings;
  final PlayerPlacementActionCallback? onHidePlacement;

  @override
  Widget build(BuildContext context) {
    final columns = playerGridColumnsForSize(screenSize);
    final rows = playerGridRowsForSize(screenSize);
    final placements = profile.orderedPlacements.where(isPlacementVisible).toList(growable: false);

    if (placements.isEmpty) {
      return Center(
        child: Text(
          S.current.screensPlayerLayoutPlayerGridCanvasNoComponentsAreVisibleForThis,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const gap = 1.0;
        final usableWidth = constraints.maxWidth;
        final usableHeight = constraints.maxHeight;

        final cellWidth = (usableWidth - ((columns - 1) * gap)) / columns;
        final cellHeight = (usableHeight - ((rows - 1) * gap)) / rows;

        return Stack(
          children: placements
              .map((placement) {
                final left = placement.x * (cellWidth + gap);
                final top = placement.y * (cellHeight + gap);
                final width = placement.width * cellWidth + (placement.width - 1) * gap;
                final height = placement.height * cellHeight + (placement.height - 1) * gap;

                return AnimatedPositioned(
                  key: ValueKey<PlayerComponentType>(placement.type),
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOutCubic,
                  left: left,
                  top: top,
                  width: width,
                  height: height,
                  child: _EditableGridTile(
                    placement: placement,
                    editMode: editMode,
                    cellWidth: cellWidth,
                    cellHeight: cellHeight,
                    onMovePlacement: onMovePlacement,
                    onResizePlacement: onResizePlacement,
                    onOpenSettings: onOpenSettings,
                    onHidePlacement: onHidePlacement,
                    child: componentBuilder(placement),
                  ),
                );
              })
              .toList(growable: false),
        );
      },
    );
  }
}

class _EditableGridTile extends StatefulWidget {
  const _EditableGridTile({
    required this.placement,
    required this.editMode,
    required this.cellWidth,
    required this.cellHeight,
    required this.child,
    required this.onMovePlacement,
    required this.onResizePlacement,
    required this.onOpenSettings,
    required this.onHidePlacement,
  });

  final PlayerComponentPlacement placement;
  final bool editMode;
  final double cellWidth;
  final double cellHeight;
  final Widget child;
  final PlayerPlacementMoveCallback? onMovePlacement;
  final PlayerPlacementResizeCallback? onResizePlacement;
  final PlayerPlacementActionCallback? onOpenSettings;
  final PlayerPlacementActionCallback? onHidePlacement;

  @override
  State<_EditableGridTile> createState() => _EditableGridTileState();
}

class _EditableGridTileState extends State<_EditableGridTile> {
  static const double _edgeResizeZone = 16;

  double _dragX = 0;
  double _dragY = 0;
  _TileGestureMode _gestureMode = _TileGestureMode.move;
  _TileGestureMode _hoverMode = _TileGestureMode.move;

  bool get _isMoveMode => _gestureMode == _TileGestureMode.move;

  bool get _resizesFromLeft =>
      _gestureMode == _TileGestureMode.left ||
      _gestureMode == _TileGestureMode.topLeft ||
      _gestureMode == _TileGestureMode.bottomLeft;

  bool get _resizesFromRight =>
      _gestureMode == _TileGestureMode.right ||
      _gestureMode == _TileGestureMode.topRight ||
      _gestureMode == _TileGestureMode.bottomRight;

  bool get _resizesFromTop =>
      _gestureMode == _TileGestureMode.top ||
      _gestureMode == _TileGestureMode.topLeft ||
      _gestureMode == _TileGestureMode.topRight;

  bool get _resizesFromBottom =>
      _gestureMode == _TileGestureMode.bottom ||
      _gestureMode == _TileGestureMode.bottomLeft ||
      _gestureMode == _TileGestureMode.bottomRight;

  _TileGestureMode _resolveGestureMode(Offset position, Size size) {
    final nearLeft = position.dx <= _edgeResizeZone;
    final nearRight = position.dx >= size.width - _edgeResizeZone;
    final nearTop = position.dy <= _edgeResizeZone;
    final nearBottom = position.dy >= size.height - _edgeResizeZone;

    if (nearLeft && nearTop) {
      return _TileGestureMode.topLeft;
    }
    if (nearRight && nearTop) {
      return _TileGestureMode.topRight;
    }
    if (nearLeft && nearBottom) {
      return _TileGestureMode.bottomLeft;
    }
    if (nearRight && nearBottom) {
      return _TileGestureMode.bottomRight;
    }
    if (nearLeft) {
      return _TileGestureMode.left;
    }
    if (nearRight) {
      return _TileGestureMode.right;
    }
    if (nearTop) {
      return _TileGestureMode.top;
    }
    if (nearBottom) {
      return _TileGestureMode.bottom;
    }
    return _TileGestureMode.move;
  }

  void _applyHorizontalStep(int step) {
    if (step == 0) {
      return;
    }

    if (_isMoveMode) {
      widget.onMovePlacement?.call(widget.placement.type, step, 0);
      return;
    }

    if (_resizesFromLeft) {
      widget.onMovePlacement?.call(widget.placement.type, step, 0);
      widget.onResizePlacement?.call(widget.placement.type, -step, 0);
      return;
    }

    if (_resizesFromRight) {
      widget.onResizePlacement?.call(widget.placement.type, step, 0);
    }
  }

  void _applyVerticalStep(int step) {
    if (step == 0) {
      return;
    }

    if (_isMoveMode) {
      widget.onMovePlacement?.call(widget.placement.type, 0, step);
      return;
    }

    if (_resizesFromTop) {
      widget.onMovePlacement?.call(widget.placement.type, 0, step);
      widget.onResizePlacement?.call(widget.placement.type, 0, -step);
      return;
    }

    if (_resizesFromBottom) {
      widget.onResizePlacement?.call(widget.placement.type, 0, step);
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (widget.onMovePlacement == null && widget.onResizePlacement == null) {
      return;
    }

    _dragX += details.delta.dx;
    _dragY += details.delta.dy;

    final thresholdX = widget.cellWidth / 2;
    final thresholdY = widget.cellHeight / 2;

    while (_dragX.abs() >= thresholdX && thresholdX > 0) {
      final step = _dragX > 0 ? 1 : -1;
      _applyHorizontalStep(step);
      _dragX -= step * thresholdX;
    }

    while (_dragY.abs() >= thresholdY && thresholdY > 0) {
      final step = _dragY > 0 ? 1 : -1;
      _applyVerticalStep(step);
      _dragY -= step * thresholdY;
    }
  }

  void _resetDrag() {
    _dragX = 0;
    _dragY = 0;
  }

  MouseCursor _cursorForMode(_TileGestureMode mode) {
    switch (mode) {
      case _TileGestureMode.left:
      case _TileGestureMode.right:
        return SystemMouseCursors.resizeLeftRight;
      case _TileGestureMode.top:
      case _TileGestureMode.bottom:
        return SystemMouseCursors.resizeUpDown;
      case _TileGestureMode.topLeft:
      case _TileGestureMode.bottomRight:
        return SystemMouseCursors.resizeUpLeftDownRight;
      case _TileGestureMode.topRight:
      case _TileGestureMode.bottomLeft:
        return SystemMouseCursors.resizeUpRightDownLeft;
      case _TileGestureMode.move:
        return SystemMouseCursors.move;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.editMode) {
      return widget.child;
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        IgnorePointer(
          ignoring: true,
          child: Opacity(opacity: widget.placement.visible ? 1 : 0.45, child: widget.child),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.placement.visible
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
                    : Theme.of(context).colorScheme.outlineVariant,
                width: 1.1,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: MouseRegion(
            cursor: _cursorForMode(_hoverMode),
            onHover: (event) {
              final size = context.size ?? Size.zero;
              final nextMode = _resolveGestureMode(event.localPosition, size);
              if (nextMode != _hoverMode && mounted) {
                setState(() {
                  _hoverMode = nextMode;
                });
              }
            },
            onExit: (_) {
              if (_hoverMode != _TileGestureMode.move && mounted) {
                setState(() {
                  _hoverMode = _TileGestureMode.move;
                });
              }
            },
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (DragStartDetails details) {
                _resetDrag();
                final size = context.size ?? Size.zero;
                _gestureMode = _resolveGestureMode(details.localPosition, size);
              },
              onPanUpdate: _handleDragUpdate,
              onPanEnd: (_) {
                _gestureMode = _TileGestureMode.move;
                _resetDrag();
              },
              onPanCancel: () {
                _gestureMode = _TileGestureMode.move;
                _resetDrag();
              },
            ),
          ),
        ),
        Positioned(
          left: 2,
          top: 2,
          right: 2,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.placement.type.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
              PopupMenuButton<_TileComponentAction>(
                tooltip: S.current.screensPlayerLayoutPlayerGridCanvasComponentActions,
                onSelected: (_TileComponentAction action) {
                  switch (action) {
                    case _TileComponentAction.settings:
                      widget.onOpenSettings?.call(widget.placement.type);
                    case _TileComponentAction.hide:
                      widget.onHidePlacement?.call(widget.placement.type);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<_TileComponentAction>>[
                  PopupMenuItem<_TileComponentAction>(
                    value: _TileComponentAction.settings,
                    child: Text(S.current.screensPlayerLayoutPlayerGridCanvasSettings),
                  ),
                  PopupMenuItem<_TileComponentAction>(
                    value: _TileComponentAction.hide,
                    child: Text(S.current.screensPlayerLayoutPlayerGridCanvasRemoveFromLayout),
                  ),
                ],
                icon: const Icon(Icons.more_horiz_rounded, size: 18),
              ),
            ],
          ),
        ),
        Positioned(
          right: 1,
          bottom: 1,
          child: _EditorToolbar(
            onMoveLeft: () => widget.onMovePlacement?.call(widget.placement.type, -1, 0),
            onMoveRight: () => widget.onMovePlacement?.call(widget.placement.type, 1, 0),
            onMoveUp: () => widget.onMovePlacement?.call(widget.placement.type, 0, -1),
            onMoveDown: () => widget.onMovePlacement?.call(widget.placement.type, 0, 1),
            onNarrower: () => widget.onResizePlacement?.call(widget.placement.type, -1, 0),
            onWider: () => widget.onResizePlacement?.call(widget.placement.type, 1, 0),
            onShorter: () => widget.onResizePlacement?.call(widget.placement.type, 0, -1),
            onTaller: () => widget.onResizePlacement?.call(widget.placement.type, 0, 1),
          ),
        ),
      ],
    );
  }
}

enum _TileGestureMode { move, left, right, top, bottom, topLeft, topRight, bottomLeft, bottomRight }

enum _TileComponentAction { settings, hide }

class _EditorToolbar extends StatelessWidget {
  const _EditorToolbar({
    required this.onMoveLeft,
    required this.onMoveRight,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onNarrower,
    required this.onWider,
    required this.onShorter,
    required this.onTaller,
  });

  final VoidCallback onMoveLeft;
  final VoidCallback onMoveRight;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onNarrower;
  final VoidCallback onWider;
  final VoidCallback onShorter;
  final VoidCallback onTaller;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Wrap(
          spacing: 1,
          runSpacing: 1,
          children: <Widget>[
            _TinyToolButton(
              icon: Icons.arrow_back_rounded,
              tooltip: S.current.screensPlayerLayoutPlayerGridCanvasMoveLeft,
              onPressed: onMoveLeft,
            ),
            _TinyToolButton(
              icon: Icons.arrow_upward_rounded,
              tooltip: S.current.screensPlayerLayoutPlayerGridCanvasMoveUp,
              onPressed: onMoveUp,
            ),
            _TinyToolButton(
              icon: Icons.arrow_downward_rounded,
              tooltip: S.current.screensPlayerLayoutPlayerGridCanvasMoveDown,
              onPressed: onMoveDown,
            ),
            _TinyToolButton(
              icon: Icons.arrow_forward_rounded,
              tooltip: S.current.screensPlayerLayoutPlayerGridCanvasMoveRight,
              onPressed: onMoveRight,
            ),
            _TinyToolButton(
              icon: Icons.width_normal_rounded,
              tooltip: S.current.screensPlayerLayoutPlayerGridCanvasNarrower,
              onPressed: onNarrower,
            ),
            _TinyToolButton(
              icon: Icons.width_wide_rounded,
              tooltip: S.current.screensPlayerLayoutPlayerGridCanvasWider,
              onPressed: onWider,
            ),
            _TinyToolButton(
              icon: Icons.vertical_align_top_rounded,
              tooltip: S.current.screensPlayerLayoutPlayerGridCanvasShorter,
              onPressed: onShorter,
            ),
            _TinyToolButton(
              icon: Icons.vertical_align_bottom_rounded,
              tooltip: S.current.screensPlayerLayoutPlayerGridCanvasTaller,
              onPressed: onTaller,
            ),
          ],
        ),
      ),
    );
  }
}

class _TinyToolButton extends StatelessWidget {
  const _TinyToolButton({required this.icon, required this.tooltip, required this.onPressed});

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        iconSize: 13,
        splashRadius: 13,
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}
