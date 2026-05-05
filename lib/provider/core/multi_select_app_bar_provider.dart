import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'multi_select_app_bar_provider.g.dart';

class MultiSelectAppBarAction {
  const MultiSelectAppBarAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.enabled = true,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool enabled;
}

class MultiSelectAppBarState {
  const MultiSelectAppBarState({
    required this.ownerKey,
    required this.selectedCount,
    required this.actions,
    required this.onClearSelection,
    this.isBusy = false,
  });

  final String ownerKey;
  final int selectedCount;
  final List<MultiSelectAppBarAction> actions;
  final VoidCallback onClearSelection;
  final bool isBusy;
}

@Riverpod(keepAlive: true)
class MultiSelectAppBar extends _$MultiSelectAppBar {
  @override
  MultiSelectAppBarState? build() => null;

  void update(MultiSelectAppBarState nextState) {
    state = nextState;
  }

  void clear() {
    state = null;
  }

  void clearIfOwner(String ownerKey) {
    if (state?.ownerKey == ownerKey) {
      state = null;
    }
  }
}
