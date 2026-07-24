# yaabsa

[![Build test for all platforms](https://github.com/Vito0912/yaabsa/actions/workflows/build.yml/badge.svg)](https://github.com/Vito0912/yaabsa/actions/workflows/build.yml)

An unofficial cross-platform app for Audiobookshelf

## Installation

[![Sponsor Vito0912](https://img.shields.io/badge/Sponsor-Vito0912-152082?style=for-the-badge&logo=github-sponsors&logoColor=white)](https://github.com/sponsors/Vito0912)

![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white) [![Play Store (Open Beta)](https://img.shields.io/badge/Google_Play-414141?style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=de.vito0912.yaabsa)

* Download the newest app file from the releases page or use the Play Store link above to join the beta.
* There are 3 versions:
  * `Auto`: This is for Android Auto. Even if you do not use Android Auto, this is the version to use for all other Android devices.
  * `AAOS`: This is for Android Automotive OS. This version only works with Android Automotive OS. It does not work with Android Auto or other Android devices.
  * `Wear`: This is for Wear OS. This version only works with Wear OS. It does not work with Android Auto or other Android devices. `Wear` requires the app to be installed on your phone to sign in and, for now, to choose what you play. Playing and syncing does not depend on the phone.

> [!WARNING]
> `Wear` is in an alpha stage of development. If you use Wear OS regularly, please consider helping by creating issues or pull requests.

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black) [![Flatpak](https://img.shields.io/badge/Flatpak-4A90E2?style=for-the-badge&logo=flatpak&logoColor=white)](https://Vito0912.github.io/yaabsa/de.vito0912.yaabsa.flatpakrepo) [![AUR (Community maintained)](https://img.shields.io/badge/AUR_(Community_maintained)-333333?style=for-the-badge&logo=arch-linux&logoColor=1793D1)](https://aur.archlinux.org/packages/yaabsa-bin/)

* _Use the Flatpak (recommended)_:

  ```bash
  flatpak remote-add --if-not-exists yaabsa https://Vito0912.github.io/yaabsa/de.vito0912.yaabsa.flatpakrepo --user
  flatpak install yaabsa de.vito0912.yaabsa --user
  ```

* The [AUR package](https://aur.archlinux.org/packages/yaabsa-bin/) is maintained by [@caitlynrw](https://github.com/caitlynrw). Thanks!
* For all other installation methods, please refer to the [Platform hints](#platform-hints) section below and download them from the releases page.

![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white) [![TestFlight](https://img.shields.io/badge/TestFlight-00C7B7?style=for-the-badge&logo=testflight&logoColor=white)](https://testflight.apple.com/join/fSyXDKFf)

* Join the beta via TestFlight using the button above.
* Alternatively, download the latest app bundle from the releases page.

![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white) [![TestFlight](https://img.shields.io/badge/TestFlight-00C7B7?style=for-the-badge&logo=testflight&logoColor=white)](https://testflight.apple.com/join/fSyXDKFf)

* Join the beta via TestFlight using the button above.
* Alternatively, download the latest IPA from the releases page to use it with tools like AltStore.

![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)

* Download the latest installer from the releases page. _(Microsoft Store availability will follow)._

[![Web](https://img.shields.io/badge/Web-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://yaabsa.de)

* **IMPORTANT**: You need to add `https://yaabsa.de` (or the domain you host the web version on) to the list of allowed origins in ABS, before you can connect with the web version. Please see the [ABS docs](https://audiobookshelf.org/docs/documentation/server-management/cors) on how. If you use `http` for Audiobookshelf, please see the note about mixed content.
* The web version is provided, but it is not officially supported. I do not test it, and it might not work correctly. Please do not report problems as issues. Instead, start a new thread in the [web discussion](https://github.com/Vito0912/yaabsa/discussions/59).

## Usage of AI

As I myself criticize the lack of disclosure about AI, which most ABS apps now use, I want to be clear that later in the making of the app, AI/LLMs were used in the development process. I still know the API endpoints used very well and have already helped a ton of people with API usage.

## Features, features, features

Below is a list of all features, but I want to _highlight_ a few, as this client has features that are only and or very rarely found in other clients:

* **First** client that supports Android Automotive (AAOS) for Audiobookshelf (ABS)
* Basic eBook/PDF support **with** _syncable_ annotations
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
| Music\*            | ✅      | ✅  | ✅      | ✅    | ✅    |

\* This is no official library type and just changes behaviour in the app, making it more suitable for music libraries.

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

| Feature            | Android | iOS  | Windows | MacOS | Linux |
| ------------------ | ------- | ---- | ------- | ----- | ----- |
| ePUB support       | ✅      | ❓   | ❓      | ❓    | ❌    |
| MOBI support       | ✅      | ❓   | ❓      | ❓    | ❌    |
| CBZ support        | ✅      | ❓   | ❓      | ❓    | ❌    |
| KF8 (AZW3) support | ✅      | ❓   | ❓      | ❓    | ❌    |
| FB2 support        | ✅      | ❓   | ❓      | ❓    | ❌    |
| PDF support        | ✅      | 🅿️   | 🅿️      | ✅    | ✅    |
| Annotations        | ✅      | ✅   | 🅿️      | ✅    | ✅    |
| Sync Annotations   | ✅      | ✅   | ❓      | ✅    | ✅    |
| Media Overlays\*\* | ✅      | ✅   | ✅      | ✅    | ❌    |

\*\* Media Overlays allow a whispersync-like experience for eBooks. This allows you to read and listen to your book at the same time. Please note that the player support is way more limited than for normal audiobooks. Media Overlays need to be added manually before adding them to ABS. I do maintain a soft fork of ABS that will have the capabilities to embed the audiofile into the eBook.

### Other Features

| Feature             | Android | iOS  | Windows | MacOS | Linux |
| ------------------- | ------- | ---- | ------- | ----- | ----- |
| Sync                | ✅      | ✅   | ✅      | ✅    | ✅    |
| Caching             | ✅      | ✅   | ✅      | ✅    | ✅    |
| Downloads           | ✅      | ✅   | ❓      | ✅\*  | ✅    |
| Headers             | ✅      | ✅   | ✅      | ✅    | ✅    |
| Tray/Statusbar Icon | ❌      | ❌   | ❓      | ✅    | ✅    |
| Car                 | ✅      | ✅   | ❌      | ❌    | ❌    |
| Android Automotive  | ✅      | ❌   | ❌      | ❌    | ❌    |
| Widgets             | ✅      | 🅿️   | ❌      | ❌    | ❌    |
| OIDC Login\*\*      | ✅      | ❓   | ✅      | ❓    | ✅    |

\* Only supports the default download location, due to sandboxing limitations. Will be addressed in the future.\
\*\* You need to add `yaabsa://oauth` to the list of "Allowed Mobile Redirect URIs" in the OIDC settings of ABS. Please see the [ABS docs](https://audiobookshelf.org/docs/documentation/server-management/oidc-authentication#manual-configuration) for more information.

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
| Embedding/Encoding    | ✅      | ✅   | ✅      | ✅    | ✅    |
| Open RSS feeds        | 🅿️      | 🅿️   | 🅿️      | 🅿️    | 🅿️    |
| Send to E-Reader      | 🅿️      | 🅿️   | 🅿️      | 🅿️    | 🅿️    |

| Feature               | Android | iOS  | Windows | MacOS | Linux |
| --------------------- | ------- | ---- | ------- | ----- | ----- |
| User management       | ✅      | ✅   | ✅      | ✅    | ✅    |
| Metadata utils        | ✅      | ✅   | ✅      | ✅    | ✅    |
| Listening Sessions\*  | ✅      | ✅   | ✅      | ✅    | ✅    |
| Server Settings       | ✅      | ✅   | ✅      | ✅    | ✅    |
| Library Management    | ✅      | ✅   | ✅      | ✅    | ✅    |
| API Key Management    | ✅      | ✅   | ✅      | ✅    | ✅    |
| Manage Backups        | ✅      | ✅   | ✅      | ✅    | ✅    |
| Server Logs           | ✅      | ✅   | ✅      | ✅    | ✅    |
| Email/E-Reader        | ✅      | ✅   | ✅      | ✅    | ✅    |
| RSS Feeds             | ✅      | ✅   | ✅      | ✅    | ✅    |
| Authentication        | ✅      | ✅   | ✅      | ✅    | ✅    |

\* Also allows editing sessions

## Platform hints

The releases are used daily on Android and Linux. Other OSes should not break, but they are not tested more deeply. Issues with iOS should be easy to catch since, while not used daily, it is still used.

### Linux requirements

For the best experience and security, please use the Flatpak. It includes everything you need and is easy to remove later.
The Snap package is currently broken and might be removed in the future.
For all other installation methods, you need to make sure that the correct dependencies are installed on your system. If the app starts with a black screen, please set the ENV `YAABSA_RELEASE_CONSOLE_LOG=1`, as this will log issues if you start the application from the terminal.
In general, you need the following dependencies:

* libmpv
* libsecret
