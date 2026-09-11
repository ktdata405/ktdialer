import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_colors.dart';
import 'features/contacts/presentation/providers/contact_provider.dart';
import 'features/dialer/presentation/providers/dialer_provider.dart';
import 'features/call/presentation/providers/call_provider.dart';
import 'features/dialer/presentation/screens/dialer_screen.dart';
import 'features/contacts/presentation/screens/contacts_screen.dart';
import 'features/call_logs/presentation/screens/call_logs_screen.dart';
import 'features/call/presentation/screens/call_screen.dart';
import 'features/call_logs/presentation/providers/call_log_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => DialerProvider()),
        ChangeNotifierProvider(create: (_) => CallProvider()),
        ChangeNotifierProvider(create: (_) => CallLogProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.darkTheme,
      home: const MainContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainContainer extends StatelessWidget {
  const MainContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final callProvider = Provider.of<CallProvider>(context);
    
    return Stack(
      children: [
        const MainScreen(),
        if (callProvider.callState != CallState.idle)
          const CallScreen(),
      ],
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isDialpadVisible = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.contacts,
      Permission.phone,
      Permission.microphone,
    ].request();
    
    if (await Permission.phone.isGranted) {
      // Refresh call logs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: const [
              CallLogsScreen(),
              ContactsScreen(),
            ],
          ),
          if (_isDialpadVisible)
            GestureDetector(
              onTap: () => setState(() => _isDialpadVisible = false),
              child: Container(
                color: Colors.black45,
              ),
            ),
          if (_isDialpadVisible)
            Align(
              alignment: Alignment.bottomCenter,
              child: DialerScreen(onClose: () => setState(() => _isDialpadVisible = false)),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _isDialpadVisible = false;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.call_outlined),
            activeIcon: Icon(Icons.call),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Contacts',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                // Logic to add a new contact
              },
              child: const Icon(Icons.add, size: 32),
            )
          : (_isDialpadVisible ? null : FloatingActionButton(
              onPressed: () => setState(() => _isDialpadVisible = true),
              child: const Icon(Icons.dialpad, size: 28),
            )),
    );
  }
}
