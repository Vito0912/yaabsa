import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/cover_loading_placeholder.dart';
import 'package:yaabsa/util/l10n.dart';

void main() {
  testWidgets('shimmer changes pixels without repainting its surrounding content', (tester) async {
    var surroundingPaints = 0;
    const captureKey = ValueKey('cover-loading-capture');

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: yaabsaLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Center(
          child: RepaintBoundary(
            key: captureKey,
            child: _PaintCounter(
              onPaint: () => surroundingPaints++,
              child: const SizedBox(width: 120, height: 160, child: CoverLoadingPlaceholder()),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(captureKey));
    final before = await tester.runAsync(() => _pixels(boundary));
    surroundingPaints = 0;

    await tester.pump(const Duration(milliseconds: 350));

    final after = await tester.runAsync(() => _pixels(boundary));
    expect(before, isNotNull);
    expect(after, isNotNull);
    expect(after, isNot(orderedEquals(before!)));
    expect(surroundingPaints, 0);
    expect(tester.getSize(find.byType(CoverLoadingPlaceholder)), const Size(120, 160));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });
}

Future<Uint8List> _pixels(RenderRepaintBoundary boundary) async {
  final image = await boundary.toImage();
  try {
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    return bytes!.buffer.asUint8List();
  } finally {
    image.dispose();
  }
}

class _PaintCounter extends SingleChildRenderObjectWidget {
  const _PaintCounter({required this.onPaint, required super.child});

  final VoidCallback onPaint;

  @override
  RenderObject createRenderObject(BuildContext context) => _PaintCounterRenderObject(onPaint);

  @override
  void updateRenderObject(BuildContext context, covariant _PaintCounterRenderObject renderObject) {
    renderObject.onPaint = onPaint;
  }
}

class _PaintCounterRenderObject extends RenderProxyBox {
  _PaintCounterRenderObject(this.onPaint);

  VoidCallback onPaint;

  @override
  void paint(PaintingContext context, Offset offset) {
    onPaint();
    super.paint(context, offset);
  }
}
