library pusher_beams;
import 'dart:async';

import 'package:pusher_beams_platform_interface/method_channel_pusher_beams.dart';
import 'package:pusher_beams_platform_interface/pusher_beams_platform_interface.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class PusherBeams extends PusherBeamsPlatform with CallbackHandlerApi {

  static final Map<String, Function> _callbacks = {};

  static final _pusherBeamsApi = PusherBeamsApi();

  PusherBeams._privateConstructor() {
    CallbackHandlerApi.setup(this);
  }

  static final PusherBeams _instance = PusherBeams._privateConstructor();

  static PusherBeams get instance => _instance;

  @override
  Future<void> addDeviceInterest(String interest) async {
    await _pusherBeamsApi.addDeviceInterest(interest);
  }

  @override
  Future<void> clearAllState() async {
    await _pusherBeamsApi.clearAllState();
    _callbacks.clear();
  }

  @override
  Future<void> clearDeviceInterests() async {
    await _pusherBeamsApi.clearDeviceInterests();
  }

  @override
  Future<List<String?>> getDeviceInterests() {
    return _pusherBeamsApi.getDeviceInterests();
  }

  @override
  Future<void> onInterestChanges(OnInterestsChange callback) async {
    final callbackId = _uuid.v4();

    _callbacks[callbackId] = callback;

    await _pusherBeamsApi.onInterestChanges(callbackId);
  }

  @override
  Future<void> removeDeviceInterest(String interest) async {
    await _pusherBeamsApi.removeDeviceInterest(interest);
  }

  @override
  Future<void> setDeviceInterests(List<String> interests) async {
    await _pusherBeamsApi.setDeviceInterests(interests);
  }

  @override
  Future<void> setUserId(String userId, BeamsAuthProvider provider, OnUserCallback callback) async {
    final callbackId = _uuid.v4();
    _callbacks[callbackId] = callback;

    await _pusherBeamsApi.setUserId(userId, provider, callbackId);
  }

  @override
  Future<void> start(String instanceId) async {
    await _pusherBeamsApi.start(UuidValue(instanceId).toString());
  }

  @override
  Future<void> stop() async {
    await _pusherBeamsApi.stop();
    _callbacks.clear();
  }

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
