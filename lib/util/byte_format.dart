import 'package:intl/intl.dart';
import 'package:yaabsa/util/l10n.dart';

String formatByteSize(num bytes, {int decimals = 1, AppLocalizations? localizations}) {
  final l10n = localizations ?? currentAppLocalizations();
  if (bytes <= 0) {
    final formattedZero = NumberFormat.decimalPatternDigits(locale: l10n.localeName, decimalDigits: 0).format(0);
    return l10n.byteSize(formattedZero, l10n.byteUnitBytes);
  }

  final units = <String>[
    l10n.byteUnitBytes,
    l10n.byteUnitKilobytes,
    l10n.byteUnitMegabytes,
    l10n.byteUnitGigabytes,
    l10n.byteUnitTerabytes,
  ];
  var value = bytes.toDouble();
  var unitIndex = 0;
  while (value >= 1024 && unitIndex < units.length - 1) {
    value /= 1024;
    unitIndex += 1;
  }

  final precision = unitIndex == 0 ? 0 : decimals;
  final formattedValue = NumberFormat.decimalPatternDigits(
    locale: l10n.localeName,
    decimalDigits: precision,
  ).format(value);
  return l10n.byteSize(formattedValue, units[unitIndex]);
}

String formatByteRate(num bytesPerSecond, {int decimals = 1, AppLocalizations? localizations}) {
  final l10n = localizations ?? currentAppLocalizations();
  if (bytesPerSecond <= 0) {
    return '--';
  }
  final formattedSize = formatByteSize(bytesPerSecond, decimals: decimals, localizations: l10n);
  return l10n.transferRatePerSecond(formattedSize);
}

String formatByteProgress({
  required int transferredBytes,
  required int totalBytes,
  int decimals = 1,
  AppLocalizations? localizations,
}) {
  final l10n = localizations ?? currentAppLocalizations();
  if (totalBytes <= 0) {
    final transferredSize = formatByteSize(transferredBytes, decimals: decimals, localizations: l10n);
    return l10n.byteTransferProgress(transferredSize, '--');
  }
  final transferredSize = formatByteSize(transferredBytes, decimals: decimals, localizations: l10n);
  final totalSize = formatByteSize(totalBytes, decimals: decimals, localizations: l10n);
  return l10n.byteTransferProgress(transferredSize, totalSize);
}
