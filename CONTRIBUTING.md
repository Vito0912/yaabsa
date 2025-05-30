## General

While developing, make sure you have a sperate process with the following command running to automatically generate code (for Providers and Database models):
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

TODO: Fix styling because macOS Layout differs and is bad
## Running/Building iOS

Install Flutter on your Mac: https://docs.flutter.dev/get-started/install/macos/mobile-ios

> [!NOTE]
> Note when installing cocoapods that you might want to use brew instead if you run into problems.

Then go into the ios directory and run `pod install`
