import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/dialer_provider.dart';
import '../widgets/keypad_button.dart';

class DialerScreen extends StatelessWidget {
  const DialerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dialerProvider = Provider.of<DialerProvider>(context);

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    dialerProvider.input,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(AppStrings.recordOption),
                    Switch(
                      value: dialerProvider.isAutoRecordEnabled,
                      onChanged: dialerProvider.toggleAutoRecord,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
                KeypadButton(label: '*', subLabel: '', onTap: () => dialerProvider.append('*')),
                KeypadButton(label: '0', subLabel: '+', onTap: () => dialerProvider.append('0')),
                KeypadButton(label: '#', subLabel: '', onTap: () => dialerProvider.append('#')),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 64),
              FloatingActionButton.large(
                onPressed: dialerProvider.makeCall,
                backgroundColor: AppColors.callButton,
                child: const Icon(Icons.call, size: 40),
              ),
              IconButton(
                onPressed: dialerProvider.delete,
                icon: const Icon(Icons.backspace_outlined, size: 32, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
