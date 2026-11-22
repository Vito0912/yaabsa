import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/provider/wear/wear_preferences_provider.dart';
import 'package:yaabsa/screens/wear/components/wear_cover.dart';

class WearPlayerBackground extends ConsumerWidget {
  const WearPlayerBackground({required this.coverUri, super.key});

  final Uri? coverUri;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(wearPreferencesProvider.select((value) => value.coverBackground));
    if (!enabled || coverUri == null) {
      return const ColoredBox(color: Colors.black);
    }
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          WearCover(uri: coverUri, size: 256, background: true),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xD9000000), Color(0xCC000000), Color(0xD9000000)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
