import 'package:pigeon/pigeon.dart';

class BeamsTokenProvider {
  String? authUrl;
  String? sessionToken;
  Map<String?, String?>? headers;
  Map<String?, String?>? queryParams;
}

@HostApi()
abstract class PusherBeamsApi {
  void start();

  String getDeviceId();

  void addDeviceInterest(String interest);

  void removeDeviceInterest(String interest);

  List<String> getDeviceInterests();

  void setDeviceInterests(List<String> interests);

  void clearDeviceInterests();

  void onInterestChanges(String callbackId);

  void setUserId(String userId, BeamsTokenProvider provider, String callbackId);

  void clearAllState();

  void stop();
}

@FlutterApi()
abstract class CallbackHandlerApi {
  void handleCallback(String callbackId, Map message);
}

@HostApi()
abstract class CallbackCreatorApi {
  void createCallback(String callbackId);
}

