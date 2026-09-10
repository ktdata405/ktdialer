import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_colors.dart';
import 'features/contacts/presentation/providers/contact_provider.dart';
import 'features/dialer/presentation/providers/dialer_provider.dart';
import 'features/dialer/presentation/screens/dialer_screen.dart';
import 'features/contacts/presentation/screens/contacts_screen.dart';
import 'features/call_logs/presentation/screens/call_logs_screen.dart';
import 'core/widgets/responsive_layout.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => DialerProvider()),
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
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
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

  final List<Widget> _screens = [
    const DialerScreen(),
    const CallLogsScreen(),
    const ContactsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        centerTitle: true,
      ),
      body: ResponsiveLayout(
        mobile: _screens[_currentIndex],
        web: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dialpad),
                  label: Text(AppStrings.dialer),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history),
                  label: Text(AppStrings.recent),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.contacts),
                  label: Text(AppStrings.contacts),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: _screens[_currentIndex]),
          ],
        ),
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width < 650
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dialpad),
                  label: AppStrings.dialer,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: AppStrings.recent,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.contacts),
                  label: AppStrings.contacts,
                ),
              ],
            )
          : null,
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                // Logic to add a new contact
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
