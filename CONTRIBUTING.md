## General

While developing, make sure you have a sperate process with the following command running to automatically generate code (for Providers and Database models):
```bash
dart run build_runner watch --delete-conflicting-outputs
```

TODO: Fix styling because macOS Layout differs and is bad
## Running/Building iOS

Install Flutter on your Mac: https://docs.flutter.dev/get-started/install/macos/mobile-ios

> [!NOTE]
> Note when installing cocoapods that you might want to use brew instead if you run into problems.

Then go into the ios directory and run `pod install`

## Building

Building and packaging for the different platforms is done through GitHub Actions. Sadly, using fastforge was no longer possible because it had known issues that were not fixed for well over a year and, in general, it lacked some features, such as being able to run commands after pubb get, which were needed. Sadly, this means there is no easy way to build it, other than running the scripts respectivley. Always check them before running! 

The files used to build and package the application, found in the packaging folders, are still heavily inspired by fastforge though.