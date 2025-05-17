import 'package:buchshelfly/database/app_database.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSwitcher extends ConsumerWidget {
  const UserSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final allUsersAsync = ref.watch(allStoredUsersProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    final double horizontalPadding = isMobile ? 12.0 : 18.0;
    final double verticalPadding = isMobile ? 8.0 : 12.0;
    final double borderRadius = isMobile ? 20.0 : 10.0;
    final double avatarRadius = isMobile ? 15.0 : 18.0;
    final double avatarFontSize = isMobile ? 11.0 : 13.0;
    final double usernameFontSize = isMobile ? 14.0 : 16.0;
    final double spacingAfterAvatar = isMobile ? 8.0 : 10.0;
    final double spacingBeforeText = isMobile ? 0 : 2.0;
    final double spacingAfterText = isMobile ? 4.0 : 8.0;
    final double dropdownIconSize = isMobile ? 20.0 : 22.0;

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          // Consider a more styled placeholder or an "Add User" button
          return const Center(child: Text('No user selected'));
        }

        return allUsersAsync.when(
          data: (allUsers) {
            if (allUsers.isEmpty) {
              // Consider a more styled placeholder
              return const Center(child: Text('No users available'));
            }

            return PopupMenuButton<String>(
              tooltip: 'Switch User', // Added tooltip for accessibility
              offset: const Offset(0, 50), // Adjust offset if needed
              shape: RoundedRectangleBorder(
                // Consistent rounded corners for the menu itself
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              onSelected: (userId) async {
                if (userId == currentUser.id) return; // No change needed

                final db = ref.read(appDatabaseProvider);
                await db.setActiveUserId(userId);
              },
              itemBuilder:
                  (context) =>
                      allUsers
                          .map(
                            (user) => PopupMenuItem<String>(
                              value: user.id,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                child: Text(
                                  user.username,
                                  style: TextStyle(
                                    fontWeight:
                                        user.id == currentUser.id
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    color:
                                        user.id == currentUser.id
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                            : Theme.of(
                                              context,
                                            ).textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
              child: Material(
                // Wrap with Material for InkWell splash if desired,
                // or keep Container if specific shape/clipping is paramount.
                color: Colors.transparent, // Make material transparent
                child: InkWell(
                  // Optional: Add InkWell for visual feedback on tap
                  borderRadius: BorderRadius.circular(borderRadius),
                  onTap:
                      null, // PopupMenuButton handles tap, this is for splash
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).chipTheme.backgroundColor ??
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(
                        color:
                            Theme.of(
                              context,
                            ).chipTheme.secondarySelectedColor ??
                            Theme.of(context).colorScheme.outlineVariant,
                        width: 1.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            currentUser.username.isNotEmpty
                                ? currentUser.username[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: avatarFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: spacingAfterAvatar),
                        if (spacingBeforeText > 0)
                          SizedBox(width: spacingBeforeText),
                        Flexible(
                          // Ensure text doesn't overflow if too long
                          child: Text(
                            currentUser.username,
                            style: TextStyle(
                              fontSize: usernameFontSize,
                              fontWeight: FontWeight.w500,
                              color:
                                  Theme.of(context).textTheme.labelLarge?.color,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: spacingAfterText),
                        Icon(
                          Icons
                              .arrow_drop_down_rounded, // A slightly softer icon
                          size: dropdownIconSize,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
