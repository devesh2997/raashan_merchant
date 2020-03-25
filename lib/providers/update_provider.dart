import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:raashan_merchant/constants.dart';

enum UpdateStatus { Loading, Compulsory, Optional, Safe, Latest }

class UpdateProvider extends ChangeNotifier {
  Firestore _db;
  bool loading;
  bool forceLatest;
  String currentVersion;
  int currentBuild;
  UpdateStatus status;

  UpdateProvider.instance() : _db = Firestore.instance {
    loading = true;
    status = UpdateStatus.Loading;
    _db
        .collection('strategies')
        .document('strategies')
        .snapshots()
        .listen(_onStrategiesDataChanged)
        .onError((e) {
      print(e);
      loading = false;
      status = UpdateStatus.Safe;
    });
  }

  Future<void> _onStrategiesDataChanged(DocumentSnapshot snapshot) async {
    try {
      Map data = snapshot.data;
      data = data['app_updates'];
      forceLatest = data['force_latest'] ?? true;
      // PackageInfo packageInfo = await PackageInfo.fromPlatform();

      // String version = packageInfo.version;
      // String buildNumber = packageInfo.buildNumber;
      String version = '1.0.0';
      String buildNumber = '1';
      currentBuild = int.parse(buildNumber);
      currentVersion = version;

      String s = data['versions'][APP_VERSION] ?? '';
      switch (s.toLowerCase()) {
        case 'compulsory':
          status = UpdateStatus.Compulsory;
          break;
        case 'optional':
          status = UpdateStatus.Optional;
          break;
        case 'safe':
          status = UpdateStatus.Safe;
          break;
        case 'latest':
          status = UpdateStatus.Latest;
          break;
        default:
          status = UpdateStatus.Safe;
      }
    } catch (e) {
      print(e);
      status = UpdateStatus.Safe;
    }

    loading = false;
    notifyListeners();
  }
}
