import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:permission_handler/permission_handler.dart';

class CallLogProvider with ChangeNotifier {
  List<CallLogEntry> _callLogs = [];
  bool _isLoading = false;

  List<CallLogEntry> get callLogs => _callLogs;
  bool get isLoading => _isLoading;

  Future<void> fetchCallLogs() async {
    _isLoading = true;
    notifyListeners();

    if (await Permission.phone.request().isGranted && 
        await Permission.contacts.request().isGranted) {
      Iterable<CallLogEntry> entries = await CallLog.get();
      _callLogs = entries.toList();
    }

    _isLoading = false;
    notifyListeners();
  }
}
