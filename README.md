# Pusher Beams for Flutter
![Pub Version](https://img.shields.io/pub/v/pusher_beams)
![GitHub](https://img.shields.io/github/license/pusher/flutter_pusher_beams)
[![likes](https://badges.bar/pusher_beams/likes)](https://pub.dev/packages/pusher_beams/score)
[![popularity](https://badges.bar/pusher_beams/popularity)](https://pub.dev/packages/pusher_beams/score)
[![pub points](https://badges.bar/pusher_beams/pub%20points)](https://pub.dev/packages/pusher_beams/score)

Official Flutter Plugin for [Pusher Beams](https://pusher.com/beams) using [Pigeon](https://pub.dev/packages/pigeon) for platform plugin interface and [Federated Plugin Architecture](https://docs.google.com/document/d/1LD7QjmzJZLCopUrFAAE98wOUQpjmguyGTN2wd_89Srs/edit?usp=sharing).

- [Dart](https://dart.dev/) >= 2.12.x
- [Flutter](https://flutter.dev/) >= 2.x.x

## Table of Contents
- [Architecture](#architecture)
- [Flutter Support](#flutter-support)
- [Platform Support](#platform-support)
    - [Web Support](#web-support)
    - [Mobile Support](#mobile-support)
- [Example](#example)
- [Before Installing](#before-installing)
    - [Android Additional](#android-additional)
    - [iOS Additional](#ios-additional)
- [Installation](#installation)
- [Initialization](#initialization)
- [API Reference](#api-reference)
- [License](#license)


## Architecture
This plugin was developed based on the [Federated Plugin Architecture](https://docs.google.com/document/d/1LD7QjmzJZLCopUrFAAE98wOUQpjmguyGTN2wd_89Srs/edit?usp=sharing), the following packages are included in the plugin:

- [pusher_beams](https://github.com/pusher/flutter_pusher_beams/tree/master/packages/pusher_beams): This is intended to be the main or _app-facing package_. **You must install this package in order to use it**.
- [pusher_beams_platform_interface](https://github.com/pusher/flutter_pusher_beams/tree/master/packages/pusher_beams_platform_interface): This is the _platform package interface_ that glues [pusher_beams](https://github.com/pusher/flutter_pusher_beams/tree/master/packages/pusher_beams) and platform packages.
- [pusher_beams_android](https://github.com/pusher/flutter_pusher_beams/tree/master/packages/pusher_beams_android): This is a _platform package_ which implements Android code.
- [pusher_beams_ios](https://github.com/pusher/flutter_pusher_beams/tree/master/packages/pusher_beams_ios): This is a _platform package_ which implements the iOS code
- [pusher_beams_web](https://github.com/pusher/flutter_pusher_beams/tree/master/packages/pusher_beams_web): This is a _platform package_ which implements the Web code.

## Flutter Support
This is the comparison table of functions implemented within this plugin according to the native libraries. ([Android](https://pusher.com/docs/beams/reference/android/), [iOS](https://pusher.com/docs/beams/reference/ios/), [Web](https://pusher.com/docs/beams/reference/web/))

|                      | **iOS** | **Android** | **Web** |
|----------------------|-----|---------|-----|
| [addDeviceInterest]()    | ✅   | ✅       | ✅   |
| [clearAllState]()        | ✅   | ✅       | ✅   |
| [clearDeviceInterests]() | ✅   | ✅       | ✅   |
| [getDeviceInterests]()   | ✅   | ✅       | ✅   |
| [onInterestChanges]()    | ✅   | ✅       | ⬜️   |
| [removeDeviceInterest]() | ✅   | ✅       | ✅   |
| [setDeviceInterests]()   | ✅   | ✅       | ✅   |
| [setUserId]()            | ✅   | ✅       | ✅   |
| [start]()                | ✅   | ✅       | ✅   |
| [stop]()                 | ✅   | ✅       | ✅   |

## Platform Support
This plugin supports Web, Android and iOS platforms.

### Web Support
- Chrome (mobile & desktop)
- Safari (mobile & desktop)
- Edge (mobile & desktop)
- Firefox (mobile & desktop)

[See Web FAQ](https://docs.flutter.dev/development/platform-integration/web#which-web-browsers-are-supported-by-flutter)

### Mobile Support

- iOS 10 and above
- Android 4.4 and above (>= SDK Version 19)

## Example
A fully example using this plugin can be found in this repository, implementing a basic use of most of the functionality included in this plugin.

[See Example](https://github.com/pusher/flutter_pusher_beams/tree/master/packages/pusher_beams/example)

## Before Installing
In order to install this plugin, you must:

- Install [firebase_core](https://pub.dev/packages/firebase_core) package from [FlutterFire](https://firebase.flutter.dev/). ([See details](https://firebase.flutter.dev/docs/overview#installation))
- Install [firebase_messaging](https://pub.dev/packages/firebase_messaging) package from [FlutterFire](https://firebase.flutter.dev/). ([See details](https://firebase.flutter.dev/docs/messaging/overview#installation))
- Follow the instructions to initialize and configure Firebase on your Flutter application. ([See Details](https://firebase.flutter.dev/docs/overview#initializing-flutterfire)).
  - If you're installing this plugin within a fresh Flutter Application, you might use the [CLI initialization](https://firebase.flutter.dev/docs/cli)
  - If you're already using FlutterFire before the [dart-only initialization](https://firebase.flutter.dev/docs/overview#initializing-flutterfire), you may want to [migrate to dart-only](https://firebase.flutter.dev/docs/manual-installation#migrating-to-dart-only-initialization).
  
**Note: You may skip this if you have already installed [FlutterFire](https://firebase.flutter.dev/) and you're implementing [firebase_messaging](https://pub.dev/packages/firebase_messaging)**

### Android Additional
- [Enable Multidex](https://firebase.flutter.dev/docs/manual-installation/android#enabling-multidex) (If your `minSdkVersion` is lower than 21)

### iOS Additional
- [Setup iOS or macOS with Firebase Cloud Messaging](https://firebase.flutter.dev/docs/messaging/apple-integration) (You may want to read this)

## Installation
To install this plugin within you Flutter application, you need to add the package into your `pubspec.yaml`.
```yaml
    dependencies:
      pusher_beams: 1.0.0
```
or with `flutter pub`
```
flutter pub add pusher_beams
```

## Initialization

In order to initialize Pusher Beams, you already have initialized Firebase ([FlutterFire](https://firebase.flutter.dev/)), now you can initialize Pusher Beams using the `start` method as soon as possible (Preferable inside the `main` function).
```dart
void main() async {
  // Some initial code
  // Maybe the firebase initialization...
  
  await PusherBeams.instance.start('YOUR INSTANCE ID');
}
```

Overall, that's all! ✨ Now you can use the methods descirbed in the [API Reference.](#api-reference)

## API Reference

If you want to see the API reference in-depth, you may want to see the [Official API Reference](https://pub.dev/documentation/pusher_beams/latest/) from [pub.dev](https://pub.dev/).

## License

Copyright (c) 2015 Pusher Ltd. See [LICENSE](LICENSE) for details.
