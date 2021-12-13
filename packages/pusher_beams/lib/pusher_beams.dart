library pusher_beams;
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pusher_beams_platform_interface/method_channel_pusher_beams.dart';
import 'package:pusher_beams_platform_interface/pusher_beams_platform_interface.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// App-facing Implementation for [PusherBeamsPlatform] plugin.
/// This is designed to be a singleton and must be consumed with [PusherBeams.instance].
class PusherBeams extends PusherBeamsPlatform with CallbackHandlerApi {

  /// This stores the  id and the [Function] to call back.
  static final Map<String, Function> _callbacks = {};

  static final dynamic _pusherBeamsApi = PusherBeamsPlatform.instance;

  PusherBeams._privateConstructor() {
    if (!kIsWeb) {
      CallbackHandlerApi.setup(this);
    }
  }

  static final PusherBeams _instance = PusherBeams._privateConstructor();

  /// The instance of [PusherBeams].
  static PusherBeams get instance => _instance;

  /// Adds an [interest] in this device.
  /// Throws an [Exception] in case of failure.
  @override
  Future<void> addDeviceInterest(String interest) async {
    await _pusherBeamsApi.addDeviceInterest(interest);
  }

  /// Clear all the state from [PusherBeams] library, leaving an empty state.
  /// Throws an [Exception] in case of failure.
  @override
  Future<void> clearAllState() async {
    await _pusherBeamsApi.clearAllState();

    if (!kIsWeb) {
      _callbacks.clear();
    }
  }

  /// Unsubscribes all interests from this device.
  /// Throws an [Exception] in case of failure.
  @override
  Future<void> clearDeviceInterests() async {
    await _pusherBeamsApi.clearDeviceInterests();
  }

  /// Get the interests registered in this device. Returns a [List] containing the interests as [String].
  /// Throws an [Exception] in case of failure.
  @override
  Future<List<String?>> getDeviceInterests() {
    return _pusherBeamsApi.getDeviceInterests();
  }

  /// Listener which calls back the [OnInterestsChange] function on interests modifications within this device.
  /// **Note:** This is not implemented on web platform
  ///
  /// Throws an [Exception] in case of failure.
  @override
  Future<void> onInterestChanges(OnInterestsChange callback) async {
    final callbackId = _uuid.v4();

    if (!kIsWeb) {
      _callbacks[callbackId] = callback;
    }

    await _pusherBeamsApi.onInterestChanges(kIsWeb ? callback : callbackId);
  }

  /// Removes an [interest] in this device.
  /// Throws an [Exception] in case of failure.
  @override
  Future<void> removeDeviceInterest(String interest) async {
    await _pusherBeamsApi.removeDeviceInterest(interest);
  }

  /// Sets the [interests] provided with a [List].
  /// This overrides and unsubscribe any interests not listed in [interests].
  /// Throws an [Exception] in case of failure.
  @override
  Future<void> setDeviceInterests(List<String> interests) async {
    await _pusherBeamsApi.setDeviceInterests(interests);
  }

  /// Sets authentication for this device, so you can send notifications specifically for this device.
  /// You must create a [BeamsAuthProvider] in order to pass the [provider] argument.
  /// Throws an [Exception] in case of failure.
  @override
  Future<void> setUserId(String userId, BeamsAuthProvider provider, OnUserCallback callback) async {
    final callbackId = _uuid.v4();

    if (!kIsWeb) {
      _callbacks[callbackId] = callback;
    }

    await _pusherBeamsApi.setUserId(userId, provider, kIsWeb ? callback : callbackId);
  }

  /// This function register this device to Pusher Beams service with the given [instanceId].
  ///
  /// You must call this method as soon as possible in your application.
  ///
  /// ```dart
  /// void main() {
  ///     // Some code...
  ///     PusherBeams.instance.start('This is an instanceId')
  /// ]
  /// ```
  ///
  /// Throws an [Exception] in case of failure.
  @override
  Future<void> start(String instanceId) async {
    await _pusherBeamsApi.start(UuidValue(instanceId).toString());
  }

  /// Stops by deleting all the state, remotely and locally.
  /// You must call [PusherBeams.instance.start()] again if you want to receive notifications.
  /// Throws an [Exception] in case of failure.
  @override
  Future<void> stop() async {
    await _pusherBeamsApi.stop();

    if (!kIsWeb) {
      _callbacks.clear();
    }
  }

  /// Handler which receives callbacks from the native platforms.
  /// This currently supports [onInterestChanges] and [setUserId] callbacks
  /// but by default it just call the [Function] set.
  ///
  /// **You're not supposed to use this**
  @override
  void handleCallback(String callbackId, String callbackName, List args) {
    final callback = _callbacks[callbackId]!;

    switch(callbackName) {
      case "onInterestChanges":
        callback((args[0] as List<Object?>).cast<String>());
        return;
      case "setUserId":
        callback(args[0] as String?);
        return;
      default:
        callback();
        return;
    }
  }
}
