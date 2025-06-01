 # Yet another ABS App
 ## yaabsa

An improved cross-platform app for Audiobookshelf

## Compatibility Matrix

> [!NOTE]
> For best playback experience merge all audio files into one file.

> [!NOTE]
> - ✅: Feature is available and tested for the platform before the release on at least one personal device.
> - ❓: Feature is available but not tested for the platform before the release. The features should work, but they are not guaranteed to work.
> - ❌: Feature is not available for the platform
> - 🅿️: Feature is planned for the platform, but not yet implemented.
> - L: Low priority feature.
> 
> If a feature already has a 🅿️, ❓, or ✅ and ❌ for the other platforms for the same feature, it is not planned to be implemented, either because it is not possible or not worth the effort for a single platform. However, PRs will not be closed. Issues will

### Library
| Feature            | Android | iOS | Windows | MacOS | Linux |
|--------------------|---------|-----|---------|-------|-------|
| Library (Book)     | ✅       | ✅   | ✅       | ✅     | ✅     |
| Library (Podcast)  | 🅿️     | 🅿️ | 🅿️     | 🅿️   | 🅿️   |
| Personalized/Shelf | ✅       | ✅   | ✅       | ✅     | ✅     |
| Series             | 🅿️     | 🅿️ | 🅿️     | 🅿️   | 🅿️   |
| Collections        | 🅿️     | 🅿️ | 🅿️     | 🅿️   | 🅿️   |
| Playlists          | 🅿️     | 🅿️ | 🅿️     | 🅿️   | 🅿️   |
| Author             | 🅿️     | 🅿️ | 🅿️     | 🅿️   | 🅿️   |
| Narrator           | 🅿️     | 🅿️ | 🅿️     | 🅿️   | 🅿️   |
| Search             | 🅿️     | 🅿️ | 🅿️     | 🅿️   | 🅿️   |
| Stats              | 🅿️     | 🅿️ | 🅿️     | 🅿️   | 🅿️   |

### Player
| Feature                         | Android | iOS | Windows | MacOS | Linux |
|---------------------------------|---------|-----|---------|-------|-------|
| Play/Pause/Seeking/Speed/Volume | ✅       | ✅   | ✅       | ✅     | ✅     |
| Background Playback             | ✅       | ❓   | ✅       | ❓     | ❓     |
| Device Controls                 | ✅       | ❓   | ❌       | ❓     | ❌     |
| (Auto)-Queue                    | ✅       | ✅   | ✅       | ✅     | ✅     |
| Gapless playback                | ✅       | ✅   | ✅       | ❓     | ❓     |
| Buffering                       | ✅       | ✅   | ✅       | ❓     | ❓     |
| Volume Boost                    | ✅       | ❌   | ❌       | ❌     | ❌     |
| Audio ducking                   | ✅       | ❓   | ❌       | ❌     | ❌     |
| Sleep Timer                     | ✅       | ✅   | ✅       | ✅     | ✅     |
| Chapters                        | ✅       | ✅   | ✅       | ✅     | ✅     |
| Play History                    | ✅       | ✅   | ✅       | ✅     | ✅     |
| Shake to rewind                 | ✅       | ✅   | ❌       | ❌     | ❌     |

### E-Reader

| Feature          | Android | iOS | Windows | MacOS | Linux |
|------------------|---------|-----|---------|-------|-------|
| ePUB support     | ✅       | ✅   | ✅       | ❓     | ❓     |
| PDF support      | 🅿️     | 🅿️ | 🅿️     | 🅿️   | 🅿️   |
| Annotations      | ✅       | ✅*  | ✅       | ❓     | ❓     |
| Sync Annotations | ✅       | ✅   | ✅       | ❓     | ❓     |
* You can only load in annotations, but not create new ones.\
(Annotations only available for ePUB files)

### Other Features

| Feature   | Android | iOS   | Windows | MacOS | Linux |
|-----------|---------|-------|---------|-------|-------|
| Sync      | ✅       | ✅     | ✅       | ✅     | ✅     |
| Caching   | ✅       | ✅     | ✅       | ✅     | ✅     |
| Downloads | ✅       | ❓     | ✅       | ❓     | ❓     |
| Headers   | ✅       | ✅     | ✅       | ✅     | ✅     |
| Car       | 🅿️L    | 🅿️LL | ❌       | ❌     | ❌     |
