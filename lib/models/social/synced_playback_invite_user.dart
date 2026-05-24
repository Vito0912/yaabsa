class SyncedPlaybackInviteUser {
  const SyncedPlaybackInviteUser({required this.userId, required this.displayName, this.isSelf = false});

  final String userId;
  final String displayName;
  final bool isSelf;
}
