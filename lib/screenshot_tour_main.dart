import 'package:agroscan/Model/plant_data.dart';
import 'package:agroscan/screens/about_us.dart';
import 'package:agroscan/screens/log_screen.dart';
import 'package:agroscan/screens/onboarding_screen.dart';
import 'package:agroscan/screens/profile_screen.dart';
import 'package:agroscan/screens/responsible_advice_screen.dart';
import 'package:agroscan/screens/settings.dart';
import 'package:agroscan/screens/signin_screen.dart';
import 'package:agroscan/screens/signup_screen.dart';
import 'package:agroscan/screens/soilcondition_screen.dart';
import 'package:agroscan/screens/storing_screen.dart';
import 'package:agroscan/screens/tfmodel.dart';
import 'package:agroscan/screens/treatment_screen.dart';
import 'package:agroscan/screens/uk_crop_support_screen.dart';
import 'package:agroscan/screens/welcome_screen.dart';
import 'package:agroscan/tools/firestore_seed.dart';
import 'package:agroscan/widgets/darkmode.dart';
import 'package:agroscan/widgets/navbar.dart';
import 'package:agroscan/widgets/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Phone-quality screenshot entrypoint. Not used by the normal app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    await seedDefaultFirestoreData();
  } catch (_) {}
  runApp(const ScreenshotTourApp());
}

class ScreenshotTourApp extends StatelessWidget {
  const ScreenshotTourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UiProvider()..init(),
      child: Consumer<UiProvider>(
        builder: (context, notifier, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: notifier.lightTheme,
            darkTheme: notifier.darkTheme,
            themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const _ShotHost(),
          );
        },
      ),
    );
  }
}

class _ShotHost extends StatelessWidget {
  const _ShotHost();

  static const _loggedPlant = Plantdata(
    plantType: 'Potato',
    moistureLevel: 40,
    nutrientLevel: 25,
    pesticideVolume: 10,
  );

  static final _screens = <MapEntry<String, Widget>>[
    const MapEntry('01_onboarding_scan_leaves', OnboardingScreen()),
    const MapEntry('02_onboarding_crop_care', OnboardingScreen(initialPage: 1)),
    const MapEntry('03_onboarding_guidance', OnboardingScreen(initialPage: 2)),
    const MapEntry('04_welcome', WelcomeScreen()),
    const MapEntry('05_sign_in', SignInScreen()),
    const MapEntry('06_sign_up', SignUpScreen()),
    const MapEntry('07_home', NavBarRoots()),
    const MapEntry('08_settings', NavBarRoots(initialIndex: 1)),
    const MapEntry('09_plant_health_scan', TfModel()),
    MapEntry(
      '10_care_guidance',
      TreatmentPage(predictionData: PredictionData('Phytophthora')),
    ),
    const MapEntry('11_crop_records_form', StoringPage()),
    MapEntry(
      '12_crop_records_history',
      LogScreenPage(
        message: 'Crop Records',
        plantType: 'Potato',
        moistureLevel: 40,
        nutrientLevel: 25,
        pesticideVolume: 10,
        plantdata: _loggedPlant,
      ),
    ),
    const MapEntry(
      '13_soil_guidance',
      SoilConditionPage(initialPlantName: 'Potato'),
    ),
    const MapEntry('14_uk_crop_support', UkCropSupportScreen()),
    const MapEntry('15_responsible_advice', ResponsibleAdviceScreen()),
    const MapEntry('16_profile', EditAccountScreen()),
    const MapEntry('17_appearance', DarkMode()),
    const MapEntry('18_about_agroscan', AboutUsScreen(members: teamMembers)),
  ];

  @override
  Widget build(BuildContext context) {
    const shot = String.fromEnvironment('SHOT', defaultValue: '07_home');
    final match = _screens.firstWhere(
      (entry) => entry.key == shot,
      orElse: () => _screens[6],
    );
    debugPrint('SCREENSHOT_READY:${match.key}');
    return match.value;
  }
}
