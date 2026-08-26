import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:agroscan/Model/plant_data.dart';
import 'package:agroscan/screens/about_us.dart';
import 'package:agroscan/screens/home_screen.dart';
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
import 'package:agroscan/widgets/darkmode.dart';
import 'package:agroscan/widgets/navbar.dart';
import 'package:agroscan/widgets/provider.dart';
import 'package:firebase_auth_platform_interface/src/pigeon/messages.pigeon.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _rootKey = Key('screenshot-root');
const _fontDir =
    '/Users/kulajamalwenna/development/flutter/bin/cache/artifacts/material_fonts';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    setupFirebaseCoreMocks();
    _mockFirebaseAuthPigeon();
    SharedPreferences.setMockInitialValues({});
    await Firebase.initializeApp();
    await _loadFonts();
    Directory('ui_screens').createSync(recursive: true);

    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('A RenderFlex overflowed')) {
        return;
      }
      original?.call(details);
    };
  });

  testWidgets('capture AgroScan UI screens', (tester) async {
    tester.view.physicalSize = const Size(1284, 2778);
    tester.view.devicePixelRatio = 3;
    tester.view.padding = FakeViewPadding.zero;
    addTearDown(tester.view.reset);

    Future<void> show(Widget screen) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => UiProvider()..init(),
          child: Consumer<UiProvider>(
            builder: (context, notifier, _) {
              return RepaintBoundary(
                key: _rootKey,
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: notifier.lightTheme,
                  darkTheme: notifier.darkTheme,
                  home: screen,
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
    }

    Future<void> snap(String name) async {
      await tester.runAsync(() async {
        final boundary =
            tester.renderObject<RenderRepaintBoundary>(find.byKey(_rootKey));
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        File('ui_screens/$name.png')
            .writeAsBytesSync(bytes!.buffer.asUint8List());
      });
    }

    await show(const OnboardingScreen());
    await snap('01_onboarding_scan_leaves');
    await tester.tap(find.text('Continue'));
    await tester.pump(const Duration(milliseconds: 450));
    await snap('02_onboarding_crop_care');
    await tester.tap(find.text('Continue'));
    await tester.pump(const Duration(milliseconds: 450));
    await snap('03_onboarding_guidance');

    await show(const WelcomeScreen());
    await snap('04_welcome');

    await show(const SignInScreen());
    await snap('05_sign_in');

    await show(const SignUpScreen());
    await snap('06_sign_up');

    await show(const NavBarRoots());
    await snap('07_home');
    final settingsTab = find.text('Settings');
    if (settingsTab.evaluate().isNotEmpty) {
      await tester.tap(settingsTab.last);
      await tester.pump(const Duration(milliseconds: 350));
      await snap('08_settings');
    }

    await show(const TfModel());
    await tester.pump(const Duration(milliseconds: 600));
    await snap('09_plant_health_scan');

    await show(TreatmentPage(predictionData: PredictionData('Phytophthora')));
    await tester.pump(const Duration(milliseconds: 500));
    await snap('10_care_guidance');

    await show(const StoringPage());
    await snap('11_crop_records_form');

    await show(
      LogScreenPage(
        message: 'Crop Records',
        plantType: 'Potato',
        moistureLevel: 40,
        nutrientLevel: 25,
        pesticideVolume: 10,
        plantdata: Plantdata(
          plantType: 'Potato',
          moistureLevel: 40,
          nutrientLevel: 25,
          pesticideVolume: 10,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await snap('12_crop_records_history');

    await show(const SoilConditionPage(initialPlantName: 'Potato'));
    await tester.pump(const Duration(milliseconds: 500));
    await snap('13_soil_guidance');

    await show(const UkCropSupportScreen());
    await snap('14_uk_crop_support');

    await show(const ResponsibleAdviceScreen());
    await snap('15_responsible_advice');

    await show(const HomeScreen());
    await snap('07b_home_screen');

    await show(const EditAccountScreen());
    await snap('16_profile');

    await show(const DarkMode());
    await snap('17_appearance');

    await show(const AboutUsScreen(members: teamMembers));
    await snap('18_about_agroscan');

    await show(const SettingsScreen());
    await tester.tap(find.text('Privacy And Responsible Use'));
    await tester.pump(const Duration(milliseconds: 350));
    await snap('19_privacy_dialog');
  });
}

void _mockFirebaseAuthPigeon() {
  const names = [
    'dev.flutter.pigeon.firebase_auth_platform_interface.FirebaseAuthHostApi.registerIdTokenListener',
    'dev.flutter.pigeon.firebase_auth_platform_interface.FirebaseAuthHostApi.registerAuthStateListener',
  ];
  for (final name in names) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockDecodedMessageHandler<Object?>(
      BasicMessageChannel<Object?>(name, FirebaseAuthHostApi.codec),
      (_) async => <Object?>['auth-events'],
    );
  }

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('auth-events'),
    (call) async => null,
  );
}

Future<void> _loadFonts() async {
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final file in files) {
      final bytes = await File(file).readAsBytes();
      loader.addFont(
        Future.value(ByteData.sublistView(Uint8List.fromList(bytes))),
      );
    }
    await loader.load();
  }

  await load('Roboto', [
    '$_fontDir/Roboto-Regular.ttf',
    '$_fontDir/Roboto-Medium.ttf',
    '$_fontDir/Roboto-Bold.ttf',
    '$_fontDir/Roboto-Black.ttf',
  ]);
  await load('MaterialIcons', ['$_fontDir/MaterialIcons-Regular.otf']);
}
