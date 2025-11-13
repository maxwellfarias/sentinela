
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sentinela/utils/network/connection_checker.dart';

class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnection internetConnection;
  ConnectionCheckerImpl(this.internetConnection);

  @override
  Future<bool> get isConnected async =>
      await internetConnection.hasInternetAccess;
}
