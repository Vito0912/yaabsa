import 'dart:math' as math;

const double appGridTileWidth = 176;
const double appGridSpacing = 8;
const double appGridCardAspectRatio = 0.74;
const double appSeriesGridCardAspectRatio = 1.08;
const int appGridMinCrossAxisCount = 1;
const int appGridMaxCrossAxisCount = 10;

class AppGridLayout {
  const AppGridLayout({required this.crossAxisCount, required this.horizontalPadding});

  final int crossAxisCount;
  final double horizontalPadding;
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
