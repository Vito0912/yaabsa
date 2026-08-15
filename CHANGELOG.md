# Changelog

## 1.9.0

This release upgrades to Flutter 3.47

### Added

- Encoder now defaults to copy when already acc or opus
- Running encoding tasks are now clickable and single file status can be shown
- Replaced cached_network_image with way faster cached_network_image_ce package, which should make browsing even faster
- Dynamic subtitles for library items, series and authors
- Better text, UI quality for desktop platforms due to Flutter upgrade
- macOS now gets published as a signed DMG file
- Setting to play random episodes for podcasts, collections and playlists

### Fixed

- If an book has been deleted it now redirects correctly
- Progress listened in the background now correctly updates the progress in all views
- Closing the session now only overwrites newer progress if unsynced progress is still queued
- Clicking on other overlapping context menus now does not hide the mini player
- Author covers now only get fetched when there should be a cover available

## 1.8.0

### Added

- Zooming for the reader

### Changed

- Added a completly new player design, which now is enabled by default. You can always switch back to the custom design via the settings. Some custom designs may need to be changed due to some changes for the seek and control buttons.
- Bookmarks have been reworked and should be more clear now
- Added new events for the local history and redesigned the local history to be more clear and easier to use
- Speed can now also be set to sub 0.1 increments

## 1.7.0

### Added

- (Linux) Support for Volume boost
- Added Latest Episodes

### Fixed

- (Android) Fixed a playback crash when registering audio effects on some devices
- (Android) Bluetooth auto-resume now should always work

## 1.6.0

### Added

- Show text for the OAuth process if yaabsa is not in the Allowed Mobile Redirect URIs list
- (Windows) Add support for media controls
- (Desktop) Add support for skip buttons to seek instead

### Fixed

- (Android) The widget did not sync when the app was in the background and started by auto-resume

## 1.5.2

### Fixed

- (Android) Fixes manifest values being wrong for auto and aaos builds and remove bluethooth requirement for auto-resume feature

## 1.5.1

### Added

- (Android) You can now choose which Bluetooth devices trigger auto-resume
- Reader improvements: tapping is better, and pages no longer turn when you press notes, select or annotate at the sides
- Early, alpha-stage support for WearOS by @soster20

### Fixed

- (Android) Now uses existing progress when not using auto-resume/widget after some time
- (iOS) Downloads should now work after an update
- More options for shake sensitivity
- (iOS) Skip buttons work again. This will also invert bluethooth behaviour. If you have any issues, please report them
- (iOS) CarPlay should now work without needing to unlock your phone. Please test this and report any remaining issues
- Annotations no longer disappear when you move to a new chapter in the reader
- Better performance when not using Android Auto or CarPlay

## 1.5.0

### Added

- Option to download all non started/non finished episodes of a podcast.
- The shelf view now does not have a extra loading indicator.
- (iOS) Now shops fast forward/rewind by default
- (Android) option to auto resume playback when connecting a Bluetooth audio device.

### Fixed

- When playback is paused, but the sleep timer is active, shaking does now not reset the sleep timer anymore.
- Podcasts only allowed one episode to be downloaded at a time.
- Downloaded Playback does now work for multiple episodes of the same podcast.
- Fixed an issue where the reader would not load when a file was sent using compression (Thanks to @Garrett3Nelson for helping).
- Always showing 10 seconds as fast forward/rewind duration.

## 1.4.9

### Added

- TTS controls for speed, language and voice.
- Support for skip buttons in mini player.
- Show download button while loading

### Fixed

- Jumping back to old position on timeouts.
- Now playing widget spanning two rows.
- Navigation elements hid some actions.
- Opening the app from a widget showed a black screen.

## 1.4.8

Stub
