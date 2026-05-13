String formatByteSize(num bytes, {int decimals = 1}) {
  if (bytes <= 0) {
    return '0 B';
  }

  const units = <String>['B', 'KB', 'MB', 'GB', 'TB'];
  var value = bytes.toDouble();
  var unitIndex = 0;
  while (value >= 1024 && unitIndex < units.length - 1) {
    value /= 1024;
    unitIndex += 1;
  }

  final precision = unitIndex == 0 ? 0 : decimals;
  return '${value.toStringAsFixed(precision)} ${units[unitIndex]}';
}

String formatByteRate(num bytesPerSecond, {int decimals = 1}) {
  if (bytesPerSecond <= 0) {
    return '--';
  }
  return '${formatByteSize(bytesPerSecond, decimals: decimals)}/s';
}

String formatByteProgress({required int transferredBytes, required int totalBytes, int decimals = 1}) {
  if (totalBytes <= 0) {
    return '${formatByteSize(transferredBytes, decimals: decimals)} / --';
  }
  return '${formatByteSize(transferredBytes, decimals: decimals)} / ${formatByteSize(totalBytes, decimals: decimals)}';
}
