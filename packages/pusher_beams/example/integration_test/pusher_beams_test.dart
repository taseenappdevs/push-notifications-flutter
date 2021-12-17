import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pusher_beams/pusher_beams.dart';

const instanceId = 'your-instance-id';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const List<String> interestToTest = [
    'test-1',
    'test-2',
    'test-3'
  ];

  const String individualInterest = 'test-4';

  group('$PusherBeams', () {
    tearDown(() {
      PusherBeams.instance.stop();
    });

    testWidgets('start', (WidgetTester tester) async {
      await PusherBeams.instance.start(instanceId);
    });

    testWidgets('setDeviceInterests', (WidgetTester tester) async {
      await PusherBeams.instance.setDeviceInterests(interestToTest);

      final List interests = await PusherBeams.instance.getDeviceInterests();

      expect(interests.length, interestToTest.length);
    });

    testWidgets('getDeviceInterests', (WidgetTester tester) async {
      final List<String?> interests = await PusherBeams.instance.getDeviceInterests();

      expect(interests, []);
    });

    testWidgets('clearDeviceInterests', (WidgetTester tester) async {
      await PusherBeams.instance.clearDeviceInterests();

      final List<String?> interests = await PusherBeams.instance.getDeviceInterests();

      expect(interests.length, 0);
    });

    testWidgets('addDeviceInterest', (WidgetTester tester) async {
      await PusherBeams.instance.addDeviceInterest(individualInterest);

      final List interests = await PusherBeams.instance.getDeviceInterests();

      expect(interests, [individualInterest]);
    });

    testWidgets('clearAllState', (WidgetTester tester) async {
      await PusherBeams.instance.clearAllState();
    });
  });
}