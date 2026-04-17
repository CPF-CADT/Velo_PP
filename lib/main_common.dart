import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'config/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'l10n/app_localizations.dart';
import 'ui/screens/map/map_screen.dart';
import 'ui/screens/passes/passes_screen.dart';
import 'ui/screens/profile/profile_screen.dart';
import 'ui/screens/rides/rides_screen.dart';
import 'ui/states/app_settings_state.dart';
import 'ui/widgets/app_header.dart';

///
/// Launch the application with the given list of providers.
///
void mainCommon(List<InheritedProvider> providers) {
  runApp(MultiProvider(providers: providers, child: const CommonApp()));
}

class CommonApp extends StatefulWidget {
  const CommonApp({super.key});

  @override
  State<CommonApp> createState() => _CommonAppState();
}

class _CommonAppState extends State<CommonApp> {
  void _changeLocale(Locale newLocale) {
    context.read<AppSettingsState>().setLocale(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsState>();
    final locale = settings.locale ?? AppConstants.defaultLocale;

    return MaterialApp(
      home: MainScreen(onLocaleChange: _changeLocale),
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppConstants.supportedLocales,
      theme: AppTheme.getBuildTheme(locale.languageCode),
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
  int _currentTab = 1;
  static const int _passesTabIndex = 0;
  static const int _mapTabIndex = 1;
  static const int _ridesTabIndex = 2;

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileScreen(onLocaleChange: widget.onLocaleChange),
      ),
    );
  }

  void _openRides() {
    setState(() {
      _currentTab = _ridesTabIndex;
    });
  }

  void _openPasses() {
    setState(() {
      _currentTab = _passesTabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      body: Column(
        children: [
          if (_currentTab != _mapTabIndex)
            AppHeader(onProfileTap: _openProfile),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                const PassesScreen(),
                MapScreen(
                  onProfileTap: _openProfile,
                  onQuickReturnTap: _openRides,
                  onOpenPassesTap: _openPasses,
                ),
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
            icon: const Icon(Icons.style),
            label: loc.get('passes'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: loc.get('map'),
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
