import 'dart:math' as math;

const double appGridTileWidth = 176;
const double appGridSpacing = 8;
const double appGridCardAspectRatio = 0.74;
const double appSeriesGridCardAspectRatio = 1.08;
const int appGridMinCrossAxisCount = 1;
const int appGridMaxCrossAxisCount = 10;
const double appDefaultLibraryGridScale = 1.0;
const double appLibraryGridScaleMin = 0.8;
const double appLibraryGridScaleMax = 1.3;
const double appLibraryGridScaleStep = 0.01;
const double appLibraryGridMinTileWidth = appGridTileWidth * appLibraryGridScaleMin;

final List<double> appLibraryGridScaleOptions = _buildLibraryGridScaleOptions();
final List<String> appLibraryGridScaleLabels = _buildLibraryGridScaleLabels(appLibraryGridScaleOptions);

class AppGridLayout {
  const AppGridLayout({required this.crossAxisCount, required this.horizontalPadding});

  final int crossAxisCount;
  final double horizontalPadding;
}

List<double> _buildLibraryGridScaleOptions() {
  final options = <double>[];
  final startStep = (appLibraryGridScaleMin / appLibraryGridScaleStep).round();
  final endStep = (appLibraryGridScaleMax / appLibraryGridScaleStep).round();

  for (var step = startStep; step <= endStep; step++) {
    options.add(step * appLibraryGridScaleStep);
  }

  return options;
}

List<String> _buildLibraryGridScaleLabels(List<double> options) {
  return options.map((scale) => '${(scale * 100).round()}%').toList(growable: false);
}

double appNormalizedLibraryGridScale(double scale) {
  final clamped = scale.clamp(appLibraryGridScaleMin, appLibraryGridScaleMax).toDouble();
  return _quantizeLibraryGridScale(clamped, floorStep: false);
}

double appAutoLibraryGridScaleForWidth(double viewportWidth) {
  final twoColumnTileWidth = (math.max(0.0, viewportWidth) - appGridSpacing * 3) / 2;

  if (twoColumnTileWidth >= appGridTileWidth) {
    return appDefaultLibraryGridScale;
  }

  if (twoColumnTileWidth < appLibraryGridMinTileWidth) {
    return appLibraryGridScaleMin;
  }

  final targetScale = twoColumnTileWidth / appGridTileWidth;
  return _quantizeLibraryGridScale(targetScale, floorStep: true);
}

double appLibraryGridTileWidthForScale(double scale) {
  return appGridTileWidth * appNormalizedLibraryGridScale(scale);
}

double _quantizeLibraryGridScale(double scale, {required bool floorStep}) {
  final scaled = scale / appLibraryGridScaleStep;
  final quantizedSteps = floorStep ? scaled.floorToDouble() : scaled.roundToDouble();
  final quantized = quantizedSteps * appLibraryGridScaleStep;
  return quantized.clamp(appLibraryGridScaleMin, appLibraryGridScaleMax).toDouble();
}

AppGridLayout appCenteredGridLayout(double viewportWidth, {double tileWidth = appGridTileWidth}) {
  final availableWidth = math.max(0, viewportWidth - appGridSpacing * 2);
  final estimatedCount = ((availableWidth + appGridSpacing) / (tileWidth + appGridSpacing)).floor();
  final boundedCount = estimatedCount < appGridMinCrossAxisCount
      ? appGridMinCrossAxisCount
      : (estimatedCount > appGridMaxCrossAxisCount ? appGridMaxCrossAxisCount : estimatedCount);

  final contentWidth = boundedCount * tileWidth + (boundedCount - 1) * appGridSpacing;
  final centeredPadding = math.max(appGridSpacing, (viewportWidth - contentWidth) / 2);

  return AppGridLayout(crossAxisCount: boundedCount, horizontalPadding: centeredPadding);
}
