import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';

Widget buildOfflineWidget() {
  return Container(
    height: 20,
    color: Colors.red,
    child: Center(
        child: Text(
      'You are offline!',
      style: TextStyle(fontSize: 10),
    )),
  );
}

Widget buildOnlineWidget() {
  return Container(
    height: 20,
    color: Colors.green,
    child: Center(
        child: Text(
      'You are back online!',
      style: TextStyle(fontSize: 10),
    )),
  );
}

void showOfflineToast() {
  showToastWidget(
    buildOfflineWidget(),
    duration: Duration(minutes: 5),
    position: ToastPosition(align: Alignment.bottomCenter, offset: 0),
  );
}

void showOnlineToast() {
  showToastWidget(
    buildOnlineWidget(),
    position: ToastPosition(align: Alignment.bottomCenter, offset: 0),
  );
}

class ConnectivityProvider extends ChangeNotifier {
  bool hasConnection;
  BuildContext context;

  ConnectivityProvider.instance(this.context) {
    Connectivity().onConnectivityChanged.listen(checkConnection);
  }

  Future<void> checkConnection(ConnectivityResult result) async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
        Navigator.of(context).pushNamed('/offline');
        //showOfflineToast();
      }
    } on SocketException catch (_) {
      hasConnection = false;
      Navigator.of(context).pushNamed('/offline');
      //showOfflineToast();
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      if (previousConnection != null && hasConnection) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        showOnlineToast();
      }
      notifyListeners();
    }
  }
}
