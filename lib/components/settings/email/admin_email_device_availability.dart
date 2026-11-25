import 'package:yaabsa/util/l10n.dart';

const String adminEmailAvailabilityAdminOrUp = 'adminOrUp';
const String adminEmailAvailabilityUserOrUp = 'userOrUp';
const String adminEmailAvailabilityGuestOrUp = 'guestOrUp';
const String adminEmailAvailabilitySpecificUsers = 'specificUsers';

const List<String> adminEmailAvailabilityOptions = <String>[
  adminEmailAvailabilityAdminOrUp,
  adminEmailAvailabilityUserOrUp,
  adminEmailAvailabilityGuestOrUp,
  adminEmailAvailabilitySpecificUsers,
];

String normalizeAdminEmailAvailabilityOption(String? value) {
  final normalized = (value ?? '').trim();
  if (normalized == 'adminAndUp') {
    return adminEmailAvailabilityAdminOrUp;
  }
  if (adminEmailAvailabilityOptions.contains(normalized)) {
    return normalized;
  }
  return adminEmailAvailabilityAdminOrUp;
}

String adminEmailAvailabilityLabel(String? value) {
  return currentAppLocalizations().emailDeviceAvailabilityName(normalizeAdminEmailAvailabilityOption(value));
}
