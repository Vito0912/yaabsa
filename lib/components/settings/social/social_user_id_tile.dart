import 'package:flutter/material.dart';

class SocialUserIdTile extends StatelessWidget {
  const SocialUserIdTile({
    required this.userId,
    this.username,
    required this.leadingIcon,
    this.subtitle,
    this.trailing,
    this.enabled = true,
    super.key,
  });

  final String userId;
  final String? username;
  final IconData leadingIcon;
  final String? subtitle;
  final Widget? trailing;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final normalizedUsername = username?.trim();
    final usernameLabel = normalizedUsername == null || normalizedUsername.isEmpty
        ? 'Username not available'
        : normalizedUsername;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: enabled
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        child: Icon(leadingIcon, size: 18, color: enabled ? colorScheme.primary : colorScheme.onSurfaceVariant),
      ),
      title: Text(
        usernameLabel,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: enabled ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'UID: $userId',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          if (subtitle != null && subtitle!.isNotEmpty)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
        ],
      ),
      trailing: trailing,
    );
  }
}
