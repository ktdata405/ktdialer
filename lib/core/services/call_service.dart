import 'package:flutter/services.dart';

class CallService {
  static const MethodChannel _channel = MethodChannel('com.example.ktdialer/call');

  static Future<bool> isDefaultDialer() async {
    try {
      return await _channel.invokeMethod('isDefaultDialer');
    } on PlatformException catch (e) {
      print("Failed to get default dialer status: '${e.message}'.");
      return false;
    }
  }

  static Future<void> requestDefaultDialer() async {
    try {
      await _channel.invokeMethod('requestDefaultDialer');
    } on PlatformException catch (e) {
      print("Failed to request default dialer: '${e.message}'.");
    }
  }

  static Future<void> placeCall(String number) async {
    try {
      await _channel.invokeMethod('placeCall', {'number': number});
    } on PlatformException catch (e) {
      print("Failed to place call: '${e.message}'.");
    }
  }

  static Future<void> answerCall() async {
    try {
      await _channel.invokeMethod('answerCall');
    } on PlatformException catch (e) {
      print("Failed to answer call: '${e.message}'.");
    }
  }

  static Future<void> hangupCall() async {
    try {
      await _channel.invokeMethod('hangupCall');
    } on PlatformException catch (e) {
      print("Failed to hangup call: '${e.message}'.");
    }
  }

  static void setCallHandler(Future<dynamic> Function(MethodCall call) handler) {
    _channel.setMethodCallHandler(handler);
  }
}
