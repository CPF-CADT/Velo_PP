import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'l10n/app_localizations.dart';
import 'screens/map_screen.dart';
import 'screens/passes_screen.dart';
import 'screens/rides_screen.dart';
import 'widgets/app_header.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = AppConstants.defaultLocale;

  void _changeLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(onLocaleChange: _changeLocale),
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppConstants.supportedLocales,
      theme: AppTheme.getBuildTheme(_locale.languageCode),
    );
  }
}

class MainScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const MainScreen({super.key, required this.onLocaleChange});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentTab = 0;
  String _searchQuery = '';

  String _getCurrentLanguage() {
    final locale = Localizations.localeOf(context);
    return locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Persistent Header
          AppHeader(
            onLocaleChange: widget.onLocaleChange,
            currentLanguage: _getCurrentLanguage(),
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),
          // Screen Content
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                MapScreen(searchQuery: _searchQuery),
                const PassesScreen(),
                const RidesScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: loc.get('map'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.style),
            label: loc.get('passes'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.directions_bike),
            label: loc.get('rides'),
          ),
        ],
      ),
    );
  }
}
