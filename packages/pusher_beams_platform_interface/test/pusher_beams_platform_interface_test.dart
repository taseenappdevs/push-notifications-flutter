import 'package:flutter_test/flutter_test.dart';
import 'package:pusher_beams_platform_interface/method_channel_pusher_beams.dart';
import 'package:pusher_beams_platform_interface/pusher_beams_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(PusherBeamsPlatform, () {
    test('disallows implementing interface', () {
      expect(
            () {
              PusherBeamsPlatform.instance = IllegalImplementation();
        },
        throwsNoSuchMethodError,
      );
    });
  });
}

class IllegalImplementation implements PusherBeamsPlatform {
  // Intentionally declare self as not a mock to trigger the
  // compliance check.
  @override
  bool get isMock => false;

  @override
  Future<void> addDeviceInterest(String interest) {
    throw UnimplementedError();
  }

  @override
  Future<void> clearAllState() {
    throw UnimplementedError();
  }

  @override
  Future<void> clearDeviceInterests() {
    throw UnimplementedError();
  }

  @override
  Future<List<String?>> getDeviceInterests() {
    throw UnimplementedError();
  }

  @override
  Future<void> onInterestChanges(OnInterestsChange callback) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeDeviceInterest(String interest) {
    throw UnimplementedError();
  }

  @override
  Future<void> setDeviceInterests(List<String> interests) {
    throw UnimplementedError();
  }

  @override
  Future<void> setUserId(String userId, BeamsAuthProvider provider, OnUserCallback callback) {
    throw UnimplementedError();
  }

  @override
  Future<void> start(String instanceId) {
    throw UnimplementedError();
  }

  @override
  Future<void> stop() {
    throw UnimplementedError();
  }

}