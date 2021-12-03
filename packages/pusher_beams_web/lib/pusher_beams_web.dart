import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js_util.dart';
import 'package:pusher_beams_platform_interface/method_channel_pusher_beams.dart';
import 'package:pusher_beams_platform_interface/pusher_beams_platform_interface.dart';
import 'package:pusher_beams_web/pusher_beams.dart';
import 'package:uuid/uuid.dart';

const uuid =  Uuid();

/// A web implementation of the PusherBeamsWeb plugin.
class PusherBeams extends PusherBeamsPlatform {
  PusherBeams._privateConstructor();

  static final PusherBeams _instance = PusherBeams._privateConstructor();

  static PusherBeams get instance => _instance;

  static PusherBeamsClient? _beamsClient;
  static bool _scriptReady = false;

  static void registerWith(Registrar registrar) {
    PusherBeamsPlatform.instance = PusherBeams.instance;
  }

  @override
  Future<void> addDeviceInterest(String interest) async {
    await promiseToFuture(_beamsClient!.addDeviceInterest(interest));
  }

  @override
  Future<void> clearAllState() async {
    await promiseToFuture(_beamsClient!.clearAllState());
  }

  @override
  Future<void> clearDeviceInterests() async {
    await promiseToFuture(_beamsClient!.clearDeviceInterests());
  }

  @override
  Future<List<String?>> getDeviceInterests() async {
    final List<dynamic> interests = await promiseToFuture(_beamsClient!.getDeviceInterests());

    return interests.cast<String?>();
  }

  @override
  Future<void> onInterestChanges(OnInterestsChange callback) async {
    throw UnimplementedError('onInterestChanges() is not implemented on web');
  }

  @override
  Future<void> removeDeviceInterest(String interest) async {
    await promiseToFuture(_beamsClient!.removeDeviceInterest(interest));
  }

  @override
  Future<void> setDeviceInterests(List<String> interests) async {
    await promiseToFuture(_beamsClient!.setDeviceInterests(interests));
  }

  @override
  Future<void> setUserId(String userId, BeamsAuthProvider provider, OnUserCallback callback) async {
    try {
      final TokenProvider tokenProvider = TokenProvider(TokenProviderOptions(
          url: provider.authUrl!,
          queryParams: provider.queryParams,
          headers: provider.headers,
          credentials: provider.credentials
      ));

      await promiseToFuture(_beamsClient!.setUserId(userId, tokenProvider));

      callback(null);
    } catch (err) {
      callback(err.toString());
    }
  }

  @override
  Future<void> start(String instanceId) async {
    final instanceUuid = UuidValue(instanceId).toString();

    if (!_scriptReady) {
      final pusherBeamsTag = html.ScriptElement();
      pusherBeamsTag.src = 'https://js.pusher.com/beams/1.0/push-notifications-cdn.js';

      final headElement = html.querySelector('head');
      headElement!.insertBefore(pusherBeamsTag, headElement.lastChild!);

      await pusherBeamsTag.onLoad.first;
      _scriptReady = true;
    }

    _beamsClient ??= PusherBeamsClient(PusherBeamsClientOptions(
        instanceId: instanceUuid
    ));

    await promiseToFuture(_beamsClient!.start());
  }

  @override
  Future<void> stop() async {
    await promiseToFuture(_beamsClient!.stop());
    _beamsClient = null;
  }
}
