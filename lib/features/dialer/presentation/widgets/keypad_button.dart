import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.keypadBackground,
          shape: BoxShape.circle,
        ),
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (subLabel != null)
              Text(
                subLabel!,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
