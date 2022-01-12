import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:pusher_beams/pusher_beams.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PusherBeams.instance
      .start('your-instance-id'); // Supply your own instanceId

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();

    initPusherBeams();
  }

  getSecure() async {
    final BeamsAuthProvider provider = BeamsAuthProvider()
      ..authUrl = 'https://some-auth-url.com/secure'
      ..headers = {'Content-Type': 'application/json'}
      ..queryParams = {'page': '1'}
      ..credentials = 'omit';

    await PusherBeams.instance.setUserId(
        'THIS IS AN USER ID',
        provider,
        (error) => {
              if (error != null) {print(error)}

              // Success! Do something...
            });
  }

  initPusherBeams() async {
    // Let's see our current interests
    print(await PusherBeams.instance.getDeviceInterests());

    // This is not intented to use in web
    if (!kIsWeb) {
      await PusherBeams.instance
          .onInterestChanges((interests) => {print('Interests: $interests')});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton(
                onPressed: () async {
                  await PusherBeams.instance.addDeviceInterest('bananas');
                },
                child: const Text('I like bananas')),
            OutlinedButton(
                onPressed: () async {
                  await PusherBeams.instance.addDeviceInterest('apples');
                },
                child: const Text('I like apples')),
            OutlinedButton(
                onPressed: () async {
                  await PusherBeams.instance.addDeviceInterest('garlic');
                },
                child: const Text('I like garlic')),
            OutlinedButton(
                onPressed: getSecure, child: const Text('Get Secure')),
            OutlinedButton(
                onPressed: () async {
                  await PusherBeams.instance.clearDeviceInterests();
                },
                child: const Text('Clear my interests'))
          ],
        ),
      ),
    );
  }
}
