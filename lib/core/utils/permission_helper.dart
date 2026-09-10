import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class PermissionHelper {
  static Future<bool> requestContactPermissions() async {
    if (kIsWeb) return true;
    var status = await Permission.contacts.request();
    return status.isGranted;
  }

  static Future<bool> requestPhonePermissions() async {
    if (kIsWeb) return true;
    var status = await Permission.phone.request();
    return status.isGranted;
  }

  static Future<bool> requestMicrophonePermissions() async {
    if (kIsWeb) return true;
    var status = await Permission.microphone.request();
    return status.isGranted;
  }
}
