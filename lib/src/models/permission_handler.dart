import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static void checkLocationPermission() async {
    var _status = await Permission.location.status;
    print("Location Permission: $_status");
    if (!_status.isGranted) {
      _status = await Permission.location.request();
      print("Location Permission: $_status");
    }
  }

  static void checkStoragePermission() async {
    var _status = await Permission.storage.status;
    print("Storage Permission: $_status");
    if (!_status.isGranted) {
      _status = await Permission.storage.request();
      print("Storage Permission: $_status");
    }
  }

  static void checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();

    print("Location Permission: ${statuses[Permission.location]}");
    print("Storage Permission: ${statuses[Permission.location]}");
  }
}
