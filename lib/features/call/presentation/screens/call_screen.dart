import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/call_provider.dart';
import '../../../dialer/presentation/providers/dialer_provider.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
    _setupAutoRecord();
  }

  void _setupAutoRecord() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dialerProvider = Provider.of<DialerProvider>(context, listen: false);
      final callProvider = Provider.of<CallProvider>(context, listen: false);

      // Listen for call state changes to trigger auto-record when call becomes active
      callProvider.addListener(() {
        if (mounted &&
            dialerProvider.isAutoRecordEnabled &&
            callProvider.callState == CallState.active &&
            !callProvider.isRecording) {
          callProvider.toggleRecording();
        }
      });

      // Also check immediately in case it's already active (e.g. outgoing call)
      if (dialerProvider.isAutoRecordEnabled &&
          callProvider.callState == CallState.active &&
          !callProvider.isRecording) {
        callProvider.toggleRecording();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final callProvider = Provider.of<CallProvider>(context);

    if (callProvider.callState == CallState.idle) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Contact Info
            Text(
              callProvider.displayName.isEmpty ? "Unknown" : callProvider.displayName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${callProvider.phoneNumber} Service Number",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),
            // Status and Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lte_mobiledata, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Text(
                  callProvider.callState == CallState.active
                      ? callProvider.formattedDuration
                      : _getStatusText(callProvider.callState),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Controls Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CallActionButton(
                        icon: Icons.voicemail,
                        label: callProvider.isRecording ? callProvider.formattedDuration : "Record",
                        isActive: callProvider.isRecording,
                        onPressed: callProvider.toggleRecording,
                        activeColor: Colors.white,
                      ),

                      const SizedBox(width: 32), // Empty space for removed Hold
                      _CallActionButton(
                        icon: Icons.add,
                        label: "Add call",
                        onPressed: () {},
                      ),
                      const SizedBox(width: 32),
                      _CallActionButton(
                        icon: callProvider.isMuted ? Icons.mic_off : Icons.mic,
                        label: "Mute",
                        isActive: callProvider.isMuted,
                        onPressed: callProvider.toggleMute,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CallActionButton(
                        icon: callProvider.isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                        label: "Speaker",
                        isActive: callProvider.isSpeakerOn,
                        onPressed: callProvider.toggleSpeaker,
                      ),
                      // End Call Button
                      _CallActionButton(
                        icon: Icons.call_end,
                        label: "End",
                        onPressed: callProvider.hangup,
                        color: Colors.red,
                        isRound: true,
                      ),
                      _CallActionButton(
                        icon: Icons.dialpad,
                        label: "Dial pad",
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  String _getStatusText(CallState state) {
    switch (state) {
      case CallState.ringing:
        return "Ringing...";
      case CallState.disconnected:
        return "Call Ended";
      default:
        return "";
    }
  }
}

class _CallActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isActive;
  final Color? color;
  final Color? activeColor;
  final bool isRound;
  final bool isSpecial;

  const _CallActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isActive = false,
    this.color,
    this.activeColor,
    this.isRound = false,
    this.isSpecial = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRound
                  ? (color ?? Colors.red)
                  : (isActive
                      ? (activeColor ?? Colors.white)
                      : (color ?? Colors.white.withOpacity(0.1))),
              border: isSpecial ? Border.all(color: Colors.white24, width: 2) : null,
              gradient: isSpecial 
                ? const SweepGradient(
                    colors: [Colors.purple, Colors.blue, Colors.green, Colors.yellow, Colors.red, Colors.purple],
                  )
                : null,
            ),
            child: Icon(
              icon,
              size: 32,
              color: (isActive && !isRound) ? Colors.black : Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
