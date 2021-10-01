import 'package:pigeon/pigeon.dart';

typedef Listener = void Function(Set<String> interests);
typedef Callback = void Function(bool error);

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

  void onInterestChanges();

  void setUserId(String userId, BeamsTokenProvider provider);

  void clearAllState();

  void stop();
}

