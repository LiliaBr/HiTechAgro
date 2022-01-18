# Hightech Agro Mobile Application

## Build
Generate *.g.dart parts:
```sh
flutter pub run build_runner build --delete-conflicting-outputs
```
Build for iOS:
```sh
flutter build ios
```
Build for Android:
```sh
flutter build appbundle
flutter build apk --split-per-abi
```

If app icon changed, run:
```sh
flutter pub run flutter_launcher_icons:main

