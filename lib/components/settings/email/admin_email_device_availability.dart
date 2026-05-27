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
  switch (normalizeAdminEmailAvailabilityOption(value)) {
    case adminEmailAvailabilityAdminOrUp:
      return 'Admin and up';
    case adminEmailAvailabilityUserOrUp:
      return 'User and up';
    case adminEmailAvailabilityGuestOrUp:
      return 'Guest and up';
    case adminEmailAvailabilitySpecificUsers:
      return 'Specific users';
  }

  return 'Admin and up';
}
