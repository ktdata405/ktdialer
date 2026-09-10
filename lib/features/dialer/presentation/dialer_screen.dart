import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/utils/common_methods.dart';

class DialerScreen extends StatefulWidget {
  const DialerScreen({super.key});

  @override
  State<DialerScreen> createState() => _DialerScreenState();
}

class _DialerScreenState extends State<DialerScreen> {
  String _input = '';

  void _onPressed(String value) {
    setState(() {
      _input += value;
    });
  }

  void _onDelete() {
    if (_input.isNotEmpty) {
      setState(() {
        _input = _input.substring(0, _input.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              _input,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            children: [
              ...['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'].map(
                (e) => InkWell(
                  onTap: () => _onPressed(e),
                  child: Center(child: Text(e, style: const TextStyle(fontSize: 24, color: AppColors.textPrimary))),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 48), 
              FloatingActionButton(
                onPressed: () => CommonMethods.showSnackBar(context, 'Calling $_input...'),
                backgroundColor: Colors.green,
                child: const Icon(Icons.call),
              ),
              IconButton(
                onPressed: _onDelete,
                icon: const Icon(Icons.backspace, color: Colors.red),
              ),
            ],
          ),
        )
      ],
    );
  }
}
