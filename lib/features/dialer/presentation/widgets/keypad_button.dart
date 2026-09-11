import 'package:flutter/material.dart';

class KeypadButton extends StatelessWidget {
  final String label;
  final String? subLabel;
  final VoidCallback onTap;

  const KeypadButton({
    super.key,
    required this.label,
    this.subLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            if (subLabel != null && subLabel!.isNotEmpty)
              Text(
                subLabel!,
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 2,
                  color: Colors.white54,
                ),
              ),
            if (label == '1' && (subLabel == null || subLabel!.isEmpty))
              const Icon(Icons.voicemail, size: 14, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
