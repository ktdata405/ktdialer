import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/dialer_provider.dart';
import '../widgets/keypad_button.dart';

class DialerScreen extends StatelessWidget {
  final VoidCallback onClose;
  const DialerScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final dialerProvider = Provider.of<DialerProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2C2C2C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(bottom: 24, top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Number Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            height: 60,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                dialerProvider.input,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Keypad
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.3,
              children: [
                KeypadButton(label: '1', subLabel: '', onTap: () => dialerProvider.append('1')),
                KeypadButton(label: '2', subLabel: 'ABC', onTap: () => dialerProvider.append('2')),
                KeypadButton(label: '3', subLabel: 'DEF', onTap: () => dialerProvider.append('3')),
                KeypadButton(label: '4', subLabel: 'GHI', onTap: () => dialerProvider.append('4')),
                KeypadButton(label: '5', subLabel: 'JKL', onTap: () => dialerProvider.append('5')),
                KeypadButton(label: '6', subLabel: 'MNO', onTap: () => dialerProvider.append('6')),
                KeypadButton(label: '7', subLabel: 'PQRS', onTap: () => dialerProvider.append('7')),
                KeypadButton(label: '8', subLabel: 'TUV', onTap: () => dialerProvider.append('8')),
                KeypadButton(label: '9', subLabel: 'WXYZ', onTap: () => dialerProvider.append('9')),
                KeypadButton(label: '*', subLabel: ',', onTap: () => dialerProvider.append('*')),
                KeypadButton(label: '0', subLabel: '+', onTap: () => dialerProvider.append('0')),
                KeypadButton(label: '#', subLabel: ';', onTap: () => dialerProvider.append('#')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Bottom Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Minimalist Grid Icon (representing recent/extra)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 24),
                ),
                // Call Button
                GestureDetector(
                  onTap: dialerProvider.makeCall,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.callButton,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.call, color: Colors.white, size: 36),
                  ),
                ),
                // Backspace
                IconButton(
                  onPressed: dialerProvider.delete,
                  icon: const Icon(Icons.backspace_outlined, color: Colors.white60, size: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
