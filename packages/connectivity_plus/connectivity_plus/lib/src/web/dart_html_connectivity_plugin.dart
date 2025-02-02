import 'dart:async';
import 'dart:js_interop';
import 'package:web/helpers.dart';
import 'package:web/web.dart' as html show window;

import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';

import '../connectivity_plus_web.dart';

/// The web implementation of the ConnectivityPlatform of the Connectivity plugin.
class DartHtmlConnectivityPlugin extends ConnectivityPlusWebPlugin {
  /// Checks the connection status of the device.
  @override
  Future<ConnectivityResult> checkConnectivity() async {
    return (html.window.navigator.onLine ?? false)
        ? ConnectivityResult.wifi
        : ConnectivityResult.none;
  }

  StreamController<ConnectivityResult>? _connectivityResult;

  /// Returns a Stream of ConnectivityResults changes.
  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    if (_connectivityResult == null) {
      _connectivityResult = StreamController<ConnectivityResult>.broadcast();
      // Fallback to dart:html window.onOnline / window.onOffline
      html.window.ononline = (Event event) {
        _connectivityResult!.add(ConnectivityResult.wifi);
      }.toJS;
      html.window.onoffline = (Event event) {
        _connectivityResult!.add(ConnectivityResult.none);
      }.toJS;
    }
    return _connectivityResult!.stream;
  }
}
