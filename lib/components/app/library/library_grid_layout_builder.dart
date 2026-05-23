import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/layout_sizes.dart';
import 'package:yaabsa/util/setting_key.dart';

typedef LibraryGridLayoutWidgetBuilder =
    Widget Function(BuildContext context, AppGridLayout gridLayout, double tileWidth, double scale);

class LibraryGridLayoutBuilder extends ConsumerStatefulWidget {
  const LibraryGridLayoutBuilder({required this.builder, super.key});

  final LibraryGridLayoutWidgetBuilder builder;

  @override
  ConsumerState<LibraryGridLayoutBuilder> createState() => _LibraryGridLayoutBuilderState();
}

class _LibraryGridLayoutBuilderState extends ConsumerState<LibraryGridLayoutBuilder> {
  bool _queuedInitialScalePersist = false;

  void _persistInitialScale(double scale) {
    if (_queuedInitialScalePersist) {
      return;
    }

    _queuedInitialScalePersist = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref.read(settingsManagerProvider.notifier).setGlobalSetting<double>(SettingKeys.libraryGridScale, scale);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaleSettingAsync = ref.watch(globalSettingByKeyProvider(SettingKeys.libraryGridScale));
    final hasResolvedSetting = scaleSettingAsync is AsyncData<String?>;
    final rawScaleValue = scaleSettingAsync.asData?.value;

    return LayoutBuilder(
      builder: (context, constraints) {
        final autoScale = appAutoLibraryGridScaleForWidth(constraints.maxWidth);
        final effectiveScale = rawScaleValue == null
            ? autoScale
            : appNormalizedLibraryGridScale(
                SettingsParser.decodeValue<double>(rawScaleValue, appDefaultLibraryGridScale),
              );

        if (hasResolvedSetting && rawScaleValue == null) {
          _persistInitialScale(autoScale);
        }

        final tileWidth = appLibraryGridTileWidthForScale(effectiveScale);
        final gridLayout = appCenteredGridLayout(constraints.maxWidth, tileWidth: tileWidth);

        return widget.builder(context, gridLayout, tileWidth, effectiveScale);
      },
    );
  }
}
