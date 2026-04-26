# yaabsa

An improved unofficial cross-platform app for Audiobookshelf

## Usage of AI

As I myself criticize the lack of disclosure about AI, which most ABS apps now use, I want to be clear that later in the making of the app, AI/LLMs were used in the development process. I still know the API endpoints used very well and have already helped a ton of people with API usage.

## Feature, features, features

Below is a list of all features, but I want to *highlight* a few, as this client has features that are only and or very rarely found in other clients:

- eBook/PDF support **with** _syncable_ annotations (EPUBs only)
- subtitle support **with** karaoke-style highlighting support (later planned to be extended like Whispersync)
- Support for all platforms Linux, Android, (iOS, macOS: TBA), Windows with responsive design

## Compatibility Matrix

> [!NOTE]
> For best playback experience merge all audio files into one file.

> [!NOTE]
>
> - ✅: Feature is available and tested for the platform before the release on at least one personal device.
> - ❓: Feature is available but not tested for the platform before the release. The features should work, but they are not guaranteed to work.
> - ❌: Feature is not available for the platform
> - 🅿️: Feature is planned for the platform, but not yet implemented.
> - L: Low priority feature.
>
> If a feature already has a 🅿️, ❓, or ✅ and ❌ for the other platforms for the same feature, it is not planned to be implemented, either because it is not possible or not worth the effort for a single platform. However, PRs will not be closed. Issues will

### Library

| Feature            | Android | iOS | Windows | MacOS | Linux |
| ------------------ | ------- | --- | ------- | ----- | ----- |
| Library (Book)     | ✅      | ✅  | ✅      | ✅    | ✅    |
| Library (Podcast)  | ✅      | ✅  | ✅      | ✅    | ✅    |
| Personalized/Shelf | ✅      | ✅  | ✅      | ✅    | ✅    |
| Series             | ✅      | ✅  | ✅      | ✅    | ✅    |
| Collections        | ✅      | ✅  | ✅      | ✅    | ✅    |
| Playlists          | ✅      | ✅  | ✅      | ✅    | ✅    |
| Author             | ✅      | ✅  | ✅      | ✅    | ✅    |
| Narrator           | ✅      | ✅  | ✅      | ✅    | ✅    |
| Search             | ✅      | ✅  | ✅      | ✅    | ✅    |
| Stats              | 🅿️      | 🅿️  | 🅿️      | 🅿️    | 🅿️    |

### Player

| Feature                         | Android | iOS | Windows | MacOS | Linux |
| ------------------------------- | ------- | --- | ------- | ----- | ----- |
| Play/Pause/Seeking/Speed/Volume | ✅      | ❓  | ❓      | ❓    | ✅    |
| Background Playback             | ✅      | ❓  | ❓      | ❓    | ❓    |
| Device Controls                 | ✅      | ❓  | ❌      | ❓    | ❌    |
| (Auto)-Queue                    | ✅      | ❓  | ❓      | ❓    | ✅    |
| Gapless playback                | ✅      | ❓  | ❓      | ❓    | ❓    |
| Buffering                       | ✅      | ❓  | ❓      | ❓    | ❓    |
| Volume Boost                    | ✅      | ❌  | ❌      | ❌    | ❌    |
| Audio ducking                   | ✅      | ❓  | ❌      | ❌    | ❌    |
| Sleep Timer                     | ✅      | ❓  | ❓      | ❓    | ✅    |
| Chapters                        | ✅      | ❓  | ❓      | ❓    | ✅    |
| Play History                    | ✅      | ❓  | ❓      | ❓    | ✅    |
| Shake to rewind                 | ✅      | ❓  | ❌      | ❌    | ❌    |

### E-Reader

| Feature          | Android | iOS  | Windows | MacOS | Linux |
| ---------------- | ------- | ---- | ------- | ----- | ----- |
| ePUB support     | ✅      | ✅   | 🅿️      | ❓    | 🅿️    |
| PDF support      | ✅      | 🅿️   | 🅿️      | ❓    | ✅    |
| Annotations      | ✅      | ✅\* | 🅿️      | ❓    | ✅    |
| Sync Annotations | ✅      | ✅   | ❓      | ❓    | ✅    |

\* You can only load in annotations, but not create new ones for ePUBs

### Other Features

| Feature   | Android | iOS  | Windows | MacOS | Linux |
| --------- | ------- | ---- | ------- | ----- | ----- |
| Sync      | ✅      | ✅   | ✅      | ✅    | ✅    |
| Caching   | ✅      | ✅   | ✅      | ✅    | ✅    |
| Downloads | ✅      | ❓   | ❓      | ❓    | ✅    |
| Headers   | ❌      | ❌   | ❌      | ❌    | ❌    |
| Car       | ✅      | 🅿️L  | ❌      | ❌    | ❌    |


## Platform hints

The releases are used daily on Android and Linux. Other OSes should not break, but they are not tested more deeply. Issues with iOS should be easy to catch since, while not used daily, it is still used.

### Linux

For the best experience and security, please use the Flatpak. It includes everything you need and is easy to remove later.
The Snap package is currently broken and might be removed in the future.
For all other installation methods, you need to make sure that the correct dependencies are installed on your system. If the app starts with a black screen, please set the ENV `YAABSA_RELEASE_CONSOLE_LOG=1`, as this will log issues if you start the application from the terminal.
In general, you need the following dependencies:
- libmpv
- libsecret