import 'dart:async';
import 'dart:html' as html;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js_util.dart';
import 'package:pusher_beams_platform_interface/method_channel_pusher_beams.dart';
import 'package:pusher_beams_platform_interface/pusher_beams_platform_interface.dart';
import 'package:pusher_beams_web/pusher_beams.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

/// A web implementation for [PusherBeamsPlatform] plugin.
/// This is designed to be a singleton and must be consumed with [PusherBeams.instance].
class PusherBeams extends PusherBeamsPlatform {
  PusherBeams._privateConstructor();

  static final PusherBeams _instance = PusherBeams._privateConstructor();

  /// The instance of [PusherBeams].
  static PusherBeams get instance => _instance;

  static PusherBeamsClient? _beamsClient;

  static void registerWith(Registrar registrar) {
    PusherBeamsPlatform.instance = PusherBeams.instance;
  }

  /// Adds an [interest] in this device.
  /// Throws [NullRejectionException] or [Exception] in case the JS promise fails.
  @override
  Future<void> addDeviceInterest(String interest) async {
    await promiseToFuture(_beamsClient!.addDeviceInterest(interest));
  }

  /// Clear all the state from [PusherBeams] library, leaving an empty state.
  /// Throws [NullRejectionException] or [Exception] in case the JS promise fails.
  @override
  Future<void> clearAllState() async {
    await promiseToFuture(_beamsClient!.clearAllState());
  }

  /// Unsubscribes all interests from this device.
  /// Throws [NullRejectionException] or [Exception] in case the JS promise fails.
  @override
  Future<void> clearDeviceInterests() async {
    await promiseToFuture(_beamsClient!.clearDeviceInterests());
  }

  /// Get the interests registered in this device. Returns a [List] containing the interests as [String].
  /// Throws [NullRejectionException] or [Exception] in case the JS promise fails.
  @override
  Future<List<String?>> getDeviceInterests() async {
    final List<dynamic> interests =
        await promiseToFuture(_beamsClient!.getDeviceInterests());

    return interests.cast<String?>();
  }

  /// This is not implemented on web platform
  @override
  Future<void> onInterestChanges(OnInterestsChange callback) async {
    throw UnimplementedError('onInterestChanges() is not implemented on web');
  }

  /// Removes an [interest] in this device.
  /// Throws [NullRejectionException] or [Exception] in case the JS promise fails.
  @override
  Future<void> removeDeviceInterest(String interest) async {
    await promiseToFuture(_beamsClient!.removeDeviceInterest(interest));
  }

  /// Sets the [interests] provided with a [List].
  /// This overrides and unsubscribe any interests not listed in [interests].
  /// Throws [NullRejectionException] or [Exception] in case the JS promise fails.
  @override
  Future<void> setDeviceInterests(List<String> interests) async {
    await promiseToFuture(_beamsClient!.setDeviceInterests(interests));
  }

  /// Sets authentication for this device, so you can send notifications specifically for this device.
  /// You must create a [BeamsAuthProvider] in order to pass the [provider] argument.
  /// Throws [NullRejectionException] or [Exception] in case the JS promise fails.
  @override
  Future<void> setUserId(String userId, BeamsAuthProvider provider,
      OnUserCallback callback) async {
    try {
      final TokenProvider tokenProvider = TokenProvider(TokenProviderOptions(
          url: provider.authUrl!,
          queryParams: provider.queryParams,
          headers: provider.headers,
          credentials: provider.credentials));

      await promiseToFuture(_beamsClient!.setUserId(userId, tokenProvider));

      callback(null);
    } catch (err) {
      callback(err.toString());
    }
  }

  /// Adds an [html.ScriptElement] to the main page with the Pusher Beams SDK for web.
  /// Then it register this device to Pusher Beams service with the given [instanceId].
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
  /// Throws [NullRejectionException] or [Exception] in case the JS promise fails.
  @override
  Future<void> start(String instanceId) async {
    final instanceUuid = UuidValue(instanceId).toString();

    _beamsClient ??=
        PusherBeamsClient(PusherBeamsClientOptions(instanceId: instanceUuid));

    await promiseToFuture(_beamsClient!.start());
  }

  /// Stops by deleting all the state, remotely and locally.
  /// You must call [PusherBeams.instance.start()] again if you want to receive notifications.
  /// Throws [NullRejectionException] or [Exception] in case the JS promise fails.
  @override
  Future<void> stop() async {
    await promiseToFuture(_beamsClient!.stop());
    _beamsClient = null;
  }
}
