@JS('PusherPushNotifications')
library pusher_beams;

import 'dart:html';

import 'package:js/js.dart';

@JS()
@anonymous
class PusherBeamsClientOptions {
  external String get instanceId;
  external ServiceWorkerRegistration? get serviceWorkerRegistration;

  // Must have an unnamed factory constructor with named arguments.
  external factory PusherBeamsClientOptions({String instanceId, ServiceWorkerRegistration? serviceWorkerRegistration});
}

@JS('Client')
class PusherBeamsClient {
  external PusherBeamsClient(PusherBeamsClientOptions options);

  external Future<PusherBeamsClient> start();
  external Future<void> addDeviceInterest(String interest);
  external Future<void> removeDeviceInterest(String interest);
  external Future<List> getDeviceInterests();
  external Future<void> setDeviceInterests(List<String> interests);
  external Future<void> clearDeviceInterests();
  external Future<void> setUserId(String userId, TokenProvider provider);
  external Future<void> clearAllState();
  external Future<void> stop();
}

@JS()
@anonymous
class TokenProviderOptions {
  external String get url;
  external Map? get queryParams;
  external Map? get headers;
  external String? get credentials;

  external factory TokenProviderOptions({String url, Map? queryParams, Map? headers, String? credentials});

}

@JS('TokenProvider')
class TokenProvider {
  external TokenProvider(TokenProviderOptions options);
}