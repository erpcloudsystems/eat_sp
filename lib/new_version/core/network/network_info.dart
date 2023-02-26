import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class BaseNetworkInfo {
  /// This function check if the mobile has internet connection or offline.
  Future<bool> get isConnected;
}

class NetworkInfo implements BaseNetworkInfo {
  InternetConnectionChecker deviceStatus;
  NetworkInfo(this.deviceStatus);

  @override
  Future<bool> get isConnected => deviceStatus.hasConnection;
}
