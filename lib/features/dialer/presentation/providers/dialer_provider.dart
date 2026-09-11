import 'package:flutter/material.dart';
import '../../../../core/services/call_service.dart';

class DialerProvider with ChangeNotifier {
  String _input = '';
  bool _isAutoRecordEnabled = false;

  String get input => _input;
  bool get isAutoRecordEnabled => _isAutoRecordEnabled;

  void append(String value) {
    _input += value;
    notifyListeners();
  }

  void delete() {
    if (_input.isNotEmpty) {
      _input = _input.substring(0, _input.length - 1);
      notifyListeners();
    }
  }

  void clear() {
    _input = '';
    notifyListeners();
  }

  void toggleAutoRecord(bool value) {
    _isAutoRecordEnabled = value;
    notifyListeners();
  }

  Future<void> makeCall() async {
    if (_input.isNotEmpty) {
      await CallService.placeCall(_input);
    }
  }
}
