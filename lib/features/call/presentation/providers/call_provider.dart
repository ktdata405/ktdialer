import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/services/call_service.dart';

enum CallState { idle, ringing, active, disconnected }

class CallProvider with ChangeNotifier {
  CallState _callState = CallState.idle;
  String _phoneNumber = '';
  String _displayName = '';
  
  // Call Stats
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isOnHold = false;
  bool _isRecording = false;
  
  // Duration tracking
  Duration _duration = Duration.zero;
  Timer? _timer;

  CallState get callState => _callState;
  String get phoneNumber => _phoneNumber;
  String get displayName => _displayName;
  bool get isMuted => _isMuted;
  bool get isSpeakerOn => _isSpeakerOn;
  bool get isOnHold => _isOnHold;
  bool get isRecording => _isRecording;
  Duration get duration => _duration;

  String get formattedDuration {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(_duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(_duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  CallProvider() {
    CallService.setCallHandler(_handleMethodCall);
  }

  void _startTimer() {
    _timer?.cancel();
    _duration = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _duration = Duration(seconds: timer.tick);
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<dynamic> _handleMethodCall(dynamic call) async {
    switch (call.method) {
      case 'onCallAdded':
        _phoneNumber = call.arguments['number'] ?? 'Unknown';
        _displayName = call.arguments['name'] ?? 'Service Number';
        _callState = CallState.ringing;
        _duration = Duration.zero;
        // Reset recording state for new call
        _isRecording = false;
        notifyListeners();
        break;
      case 'onStateChanged':
        final state = call.arguments['state'];
        // 2 = Ringing, 3 = Dialing, 4 = Active, 7 = Disconnected
        if (state == 2 || state == 3) {
          _callState = CallState.ringing;
          _stopTimer();
        } else if (state == 4) {
          if (_callState != CallState.active) {
            _startTimer();
          }
          _callState = CallState.active;
        } else if (state == 7) {
          _callState = CallState.disconnected;
          _stopTimer();
        }
        notifyListeners();
        break;
      case 'onCallRemoved':
        _callState = CallState.disconnected;
        _stopTimer();
        notifyListeners();
        Future.delayed(const Duration(seconds: 2), () {
          _callState = CallState.idle;
          _phoneNumber = '';
          _displayName = '';
          _isRecording = false;
          _isMuted = false;
          _isSpeakerOn = false;
          notifyListeners();
        });
        break;
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    // CallService implementation for native mute would go here
    notifyListeners();
  }

  void toggleSpeaker() {
    _isSpeakerOn = !_isSpeakerOn;
    // CallService implementation for native speaker would go here
    notifyListeners();
  }

  void toggleHold() {
    _isOnHold = !_isOnHold;
    // CallService implementation for native hold would go here
    notifyListeners();
  }

  void toggleRecording() {
    _isRecording = !_isRecording;
    // CallService implementation for native recording would go here
    notifyListeners();
  }

  Future<void> answer() async {
    await CallService.answerCall();
  }

  Future<void> hangup() async {
    await CallService.hangupCall();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
