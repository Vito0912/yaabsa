import 'package:flutter/material.dart';
import 'package:yaabsa/generated/l10n.dart';

class UserSwitcherAvatar extends StatelessWidget {
  const UserSwitcherAvatar({super.key, required this.username, required this.compact, required this.serverReachable});

  final String? username;
  final bool compact;
  final bool? serverReachable;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final avatarRadius = compact ? 13.0 : 14.0;
    final indicatorSize = compact ? 9.0 : 10.0;
    final displayInitial = username != null && username!.isNotEmpty ? username![0].toUpperCase() : 'U';

    Color indicatorColor;
    String indicatorTooltip;
    if (serverReachable == true) {
      indicatorColor = const Color(0xFF2E7D32);
      indicatorTooltip = l10n.componentsAppUserSwitcherAvatarServerReachable;
    } else if (serverReachable == false) {
      indicatorColor = colorScheme.error;
      indicatorTooltip = l10n.componentsAppUserSwitcherAvatarServerConnectionProblems;
    } else {
      indicatorColor = colorScheme.outline;
      indicatorTooltip = l10n.componentsAppUserSwitcherAvatarCheckingServerStatus;
    }

    return Tooltip(
      message: indicatorTooltip,
      waitDuration: const Duration(milliseconds: 450),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: colorScheme.primary,
            child: Text(
              displayInitial,
              style: TextStyle(color: colorScheme.onPrimary, fontSize: compact ? 10 : 11, fontWeight: FontWeight.w600),
            ),
          ),
          Positioned(
            right: -1,
            bottom: -1,
            child: Container(
              width: indicatorSize,
              height: indicatorSize,
              decoration: BoxDecoration(
                color: indicatorColor,
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.surfaceContainerHigh, width: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
