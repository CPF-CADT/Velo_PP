import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  late Map<String, Map<String, String>> translations = {
    'appTitle': {'en': 'PhnomPenhVELO', 'km': 'វេល៉ូភ្នំពេញ'},
    'searchHint': {
      'en': 'find stations near you',
      'km': 'ស្វែងរកស្ថានីយនៅជិតអ្នក',
    },
    'locationError': {
      'en': 'Enable location services',
      'km': 'បើកសេវាកម្មទីតាំង',
    },
    'permissionError': {
      'en': 'Location permission denied',
      'km': 'ការអនុញ្ញាតទីតាំងត្រូវបានបដិសេធ',
    },
    'retry': {'en': 'Retry', 'km': 'ព្យាយាមម្តងទៀត'},
    'available': {'en': 'Available', 'km': 'ដែលមាន'},
    'quickSelect': {'en': 'Quick Select', 'km': 'ជ្រើសរហ័ស'},
    'bikes': {'en': 'Bikes', 'km': 'ម៉ូតូកង់'},
    'distance': {'en': 'Distance', 'km': 'ចម្ងាយ'},
    'address': {'en': 'Address', 'km': 'អាសយដ្ឋាន'},
    'select': {'en': 'Select', 'km': 'ជ្រើសរើស'},
    'navigate': {'en': 'Navigate', 'km': 'ទិសដៅ'},
    'nearestBike': {'en': 'Nearest bike', 'km': 'កង់ជិតបំផុត'},
    'noStationsAvailable': {
      'en': 'No available stations nearby',
      'km': 'មិនមានស្ថានីយនៅជិតដែលអាចប្រើបាន',
    },
    'map': {'en': 'Map', 'km': 'ផែនទី'},
    'passes': {'en': 'Passes', 'km': 'កញ្ចប់'},
    'rides': {'en': 'Rides', 'km': 'ការជិះ'},
    'profile': {'en': 'Profile', 'km': 'ប្រវត្តិ'},
    'userProfile': {'en': 'User Profile', 'km': 'ប្រវត្តិអ្នកប្រើ'},
    'userSettings': {'en': 'User Settings', 'km': 'ការកំណត់អ្នកប្រើ'},
    'language': {'en': 'Language', 'km': 'ភាសា'},
    'english': {'en': 'English', 'km': 'អង់គ្លេស'},
    'khmer': {'en': 'Khmer', 'km': 'ខ្មែរ'},
    'email': {'en': 'Email', 'km': 'អ៊ីមែល'},
    'phone': {'en': 'Phone', 'km': 'ទូរស័ព្ទ'},
    'memberSince': {'en': 'Member since', 'km': 'សមាជិកតាំងពី'},
    'bike': {'en': 'Bike', 'km': 'កង់'},
    'hoursShort': {'en': 'hrs', 'km': 'ម៉ោង'},
    'activePass': {'en': 'Active pass', 'km': 'កញ្ចប់សកម្ម'},
    'genericError': {'en': 'Something went wrong', 'km': 'មានបញ្ហាកើតឡើង'},
    'station': {'en': 'Station', 'km': 'ស្ថានីយ'},
    'away': {'en': 'away', 'km': 'ឆ្ងាយ'},
    'selectStation': {
      'en': 'Tap a station to view details',
      'km': 'ចុចលើស្ថានីយដើម្បីមើលលម្អិត',
    },
    'navigateToStation': {
      'en': 'Opening navigation to station',
      'km': 'បើកទិសដៅទៅស្ថានីយ',
    },
    'noPassesYet': {
      'en': 'No passes available yet',
      'km': 'មិនមានកញ្ចប់ដែលមាន',
    },
    'noRidesYet': {'en': 'No rides yet', 'km': 'មិនមានការជិះនៅឡើយ'},
    'location': {'en': 'Location', 'km': 'ទីតាំង'},
    'bikesAvailable': {'en': 'bikes available', 'km': 'ម៉ូតូកង់ដែលមាន'},
    'slots': {'en': 'slots', 'km': 'ចំណត'},
    'availableSlots': {'en': 'Available Slots', 'km': 'ចំណតម៉ូតូកង់ដែលមាន'},
    'slot': {'en': 'Slot', 'km': 'ចំណត'},
    'km': {'en': 'km', 'km': 'គ.ម'},
    'tooFarForFastest': {
      'en': 'Too far for fastest station selection',
      'km': 'ឆ្ងាយពេកសម្រាប់ជម្រើសស្ថានីយលឿនបំផុត',
    },
    'fastestRangeHint': {
      'en': 'Move within 100 m to use fastest',
      'km': 'សូមចូលទៅក្នុងចម្ងាយ ១០០ ម៉ ដើម្បីប្រើលឿនបំផុត',
    },
    'yourPasses': {'en': 'Your Passes', 'km': 'កញ្ចប់របស់អ្នក'},
    'yourRides': {'en': 'Your Rides', 'km': 'ការជិះរបស់អ្នក'},
    'station05': {'en': 'Station 05', 'km': 'ស្ថានីយ ០៥'},
    'greenpark': {'en': 'Green Park', 'km': 'សួនរលាក់'},
    'station08': {'en': 'Station 08', 'km': 'ស្ថានីយ ០៨'},
    'downtowncenter': {'en': 'Downtown Center', 'km': 'កណ្តាលក្រុង'},
    'station04': {'en': 'Station 04', 'km': 'ស្ថានីយ ០៤'},
    'mainstreet': {'en': 'Main Street', 'km': 'ផ្លូវលេខ ១'},
    'station13': {'en': 'Station 13', 'km': 'ស្ថានីយ ១៣'},
    'westdistrict': {'en': 'West District', 'km': 'លិច'},
    'station10': {'en': 'Station 10', 'km': 'ស្ថានីយ ១០'},
    'eastmarket': {'en': 'East Market', 'km': 'កើត'},
  };

  String get(String key) {
    return translations[key]?[locale.languageCode] ??
        translations[key]?['en'] ??
        key;
  }

  String getString(String key) => get(key);
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'km'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
