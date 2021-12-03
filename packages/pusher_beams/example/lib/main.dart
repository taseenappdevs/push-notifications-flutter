import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pusher_beams/pusher_beams.dart';

void main() async {
  runApp(const MyApp());

  await PusherBeams.instance.start('fe8d1a3b-49f8-4375-a278-a49e6bb7f020');
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

    testInterestsChanges();
  }

  testInterestsChanges() async {
    if (!kIsWeb) {
      await PusherBeams.instance.onInterestChanges((interests) => {
        print('Interests change: $interests')
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: OutlinedButton(
            onPressed: () async {
              await PusherBeams.instance.clearDeviceInterests();
              await PusherBeams.instance.addDeviceInterest('debug0-hello');
            },
            child: const Text('START'),
          ),
        ),
      ),
    );
  }
}
