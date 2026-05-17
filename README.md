# yaabsa

[![Build test for all platforms](https://github.com/Vito0912/yaabsa/actions/workflows/build.yml/badge.svg)](https://github.com/Vito0912/yaabsa/actions/workflows/build.yml)

An improved unofficial cross-platform app for Audiobookshelf

## Installation

![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white) [![Play Store](https://img.shields.io/badge/Google_Play-414141?style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=de.vito0912.yaabsa) [![Play Store Beta](https://img.shields.io/badge/Internal_Test-ff8400?style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/apps/testing/de.vito0912.yaabsa)

* Currently, access is invite‑only. To join the beta, email me at fito0912(@)duck.com (or the mail at my GitHub profile) with the email address you use for the Play Store. After I add you to the internal test, you can use the links above to access the app. Please also mention if you just want to access the normal, AAOS or both versions of the app.
* Download the latest APK from the releases page. Note that `AAOS` are only compatible with Android Automotive.

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black) [![Flatpak](https://img.shields.io/badge/Flatpak-4A90E2?style=for-the-badge&logo=flatpak&logoColor=white)](https://Vito0912.github.io/yaabsa/de.vito0912.yaabsa.flatpakrepo)

* _Use the Flatpak (recommended)_:

  ```bash
  flatpak remote-add --if-not-exists yaabsa https://Vito0912.github.io/yaabsa/de.vito0912.yaabsa.flatpakrepo --user
  flatpak install yaabsa de.vito0912.yaabsa --user
  ```

* For all other installation methods, please refer to the [Platform hints](#platform-hints) section below and download them from the releases page.

![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white) [![TestFlight](https://img.shields.io/badge/TestFlight-00C7B7?style=for-the-badge&logo=testflight&logoColor=white)](https://testflight.apple.com/join/fSyXDKFf)

* Join the beta via TestFlight using the button above.
* Alternatively, download the latest app bundle from the releases page.

![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white) [![TestFlight](https://img.shields.io/badge/TestFlight-00C7B7?style=for-the-badge&logo=testflight&logoColor=white)](https://testflight.apple.com/join/fSyXDKFf)

* Join the beta via TestFlight using the button above.
* Alternatively, download the latest IPA from the releases page to use it with tools like AltStore.

![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)

* Download the latest installer from the releases page. _(Microsoft Store availability will follow)._

## Usage of AI

As I myself criticize the lack of disclosure about AI, which most ABS apps now use, I want to be clear that later in the making of the app, AI/LLMs were used in the development process. I still know the API endpoints used very well and have already helped a ton of people with API usage.

## Features, features, features

Below is a list of all features, but I want to _highlight_ a few, as this client has features that are only and or very rarely found in other clients:

* **First** and **only** client that supports Android Automotive with desktop/large displays in mind (support for while-driving experience planned)
* eBook/PDF support **with** _syncable_ annotations
* subtitle support **with** karaoke-style highlighting support (later planned to be extended like Whispersync)
* Support for all platforms Linux, Android, Android Automotive, iOS, macOS, Windows with responsive design
* More actions directly via the notification player
* You can **customize the player** components and move them around

> [!NOTE]
> Please note that this client is a mainly personal project I started because it lacks features\
> There are many options now, most of them just vibe-coded, and I do not want to add another app to the pile. This App by no means is AI-free, but not vibed  
> If you find this app or see me mention it in a thread because of one of its unique features, please note that, since it is a personal project, any changes are very personal/opiniated.
>
> If you have better **ideas** for **design**, I am open to restructuring or redesigning the app

## Compatibility Matrix

> [!NOTE]
>
> * ✅: Feature is available and tested for the platform before the release on at least one personal device.
> * ❓: Feature is available but not tested for the platform before the release. The features should work, but they are not guaranteed to work.
> * ❌: Feature is not available for the platform, due to missing libraries. It does not mean that it will never be available
> * 🅿️: Feature is planned for the platform, but not yet implemented.
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
| Stats              | ✅      | ✅  | ✅      | ✅    | ✅    |

### Player

| Feature                         | Android | iOS | Windows | MacOS | Linux |
| ------------------------------- | ------- | --- | ------- | ----- | ----- |
| Play/Pause/Seeking/Speed/Volume | ✅      | ✅  | ❓      | ✅    | ✅    |
| Background Playback             | ✅      | ✅  | ❓      | ✅    | ✅    |
| Device Controls                 | ✅      | ✅  | ❌      | ✅    | ❌    |
| (Auto)-Queue                    | ✅      | ✅  | ❓      | ✅    | ✅    |
| Gapless playback                | ✅      | ✅  | ❓      | ✅    | ✅    |
| Buffering                       | ✅      | ✅  | ❓      | ✅    | ❓    |
| Volume Boost                    | ✅      | ❌  | ❌      | ❌    | ❌    |
| Audio ducking                   | ✅      | ❓  | ❌      | ❌    | ❌    |
| Sleep Timer                     | ✅      | ✅  | ❓      | ✅    | ✅    |
| Chapters                        | ✅      | ✅  | ❓      | ✅    | ✅    |
| Play History                    | ✅      | ✅  | ❓      | ✅    | ✅    |
| Shake to rewind                 | ✅      | ✅  | ❌      | ❌    | ❌    |
| Cast                            | ✅      | ❓  | ❌      | ❌    | ❌    |
| Auto-Download next in queue     | 🅿️      | 🅿️  | 🅿️      | 🅿️    | 🅿️    |
| Auto-Resume                     | ✅      | ✅  | ✅      | ✅    | ✅    |
| Subtitles (karaoke-style)       | ✅      | ✅  | ✅      | ✅    | ✅    |

### E-Reader

| Feature          | Android | iOS  | Windows | MacOS | Linux |
| ---------------- | ------- | ---- | ------- | ----- | ----- |
| ePUB support     | ✅      | ✅   | 🅿️      | 🅿️    | ❌    |
| PDF support      | ✅      | 🅿️   | 🅿️      | ✅    | ✅    |
| Annotations      | ✅      | ✅\* | 🅿️      | ✅    | ✅    |
| Sync Annotations | ✅      | ✅   | ❓      | ✅    | ✅    |

\* You can only load in annotations, but not create new ones for ePUBs

### Server Management

| Feature               | Android | iOS  | Windows | MacOS | Linux |
| --------------------- | ------- | ---- | ------- | ----- | ----- |
| Manage Playlists      | ✅      | ✅   | ✅      | ✅    | ✅    |
| Manage Collections    | ✅      | ✅   | ✅      | ✅    | ✅    |
| Edit items            | ✅      | ✅   | ✅      | ✅    | ✅    |
| Delete items          | ✅      | ✅   | ✅      | ✅    | ✅    |
| Upload items          | ✅      | ✅   | ✅      | ✅    | ✅    |
| Match items           | ✅      | ✅   | ✅      | ✅    | ✅    |
| Bulk editing          | 🅿️      | 🅿️   | 🅿️      | 🅿️    | 🅿️    |
| User management       | ✅      | ✅   | ✅      | ✅    | ✅    |
| Embedding/Encoding    | ✅      | ✅   | ✅      | ✅    | ✅    |
| Metadata utils        | ✅      | ✅   | ✅      | ✅    | ✅    |
| Listening Sessions\*  | ✅      | ✅   | ✅      | ✅    | ✅    |

\* Also allows editing sessions

### Other Features

| Feature             | Android | iOS  | Windows | MacOS | Linux |
| ------------------- | ------- | ---- | ------- | ----- | ----- |
| Sync                | ✅      | ✅   | ✅      | ✅    | ✅    |
| Caching             | ✅      | ✅   | ✅      | ✅    | ✅    |
| Downloads           | ✅      | ❓   | ❓      | ✅\*  | ✅    |
| Headers             | ✅      | ✅   | ✅      | ✅    | ✅    |
| Tray/Statusbar Icon | ❌      | ❌   | ❓      | ❓    | ✅    |
| Car                 | ✅      | 🅿️   | ❌      | ❌    | ❌    |
| Android Automotive  | ✅\**   | ❌   | ❌      | ❌    | ❌    |
| Widgets             | ✅      | 🅿️   | ❌      | ❌    | 🅿️    |

\* Only supports the default download location, due to sandboxing limitations. Will be addressed in the future.\
\** On most cars, only the park experience works currently. More support is planned.

## Platform hints

The releases are used daily on Android and Linux. Other OSes should not break, but they are not tested more deeply. Issues with iOS should be easy to catch since, while not used daily, it is still used.

### Linux requirements

For the best experience and security, please use the Flatpak. It includes everything you need and is easy to remove later.
The Snap package is currently broken and might be removed in the future.
For all other installation methods, you need to make sure that the correct dependencies are installed on your system. If the app starts with a black screen, please set the ENV `YAABSA_RELEASE_CONSOLE_LOG=1`, as this will log issues if you start the application from the terminal.
In general, you need the following dependencies:

* libmpv
* libsecret
