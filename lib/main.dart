import 'package:agroscan/tools/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agroscan/screens/onboarding_screen.dart';
import 'package:agroscan/widgets/navbar.dart';
import 'package:agroscan/widgets/provider.dart';

//main
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => UiProvider()..init(),
      child:
          Consumer<UiProvider>(builder: (context, UiProvider notifier, child) {
        return MaterialApp(
            routes: {
              'NavBarRoots': (context) => const NavBarRoots(),
            },
            debugShowCheckedModeBanner: false,
            theme: notifier.lightTheme,
            themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
            darkTheme: notifier.darkTheme,
            home: FutureBuilder(
              future: FirebaseAuth.instance.authStateChanges().first,
              builder: (context, AsyncSnapshot<User?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    backgroundColor: AgroScanTheme.background,
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: AgroScanTheme.heroGradient,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: AgroScanTheme.softShadow,
                            ),
                            child: const Icon(Icons.eco_rounded,
                                color: Colors.white, size: 34),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'AgroScan',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AgroScanTheme.text,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const CircularProgressIndicator(
                            color: AgroScanTheme.primary,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data != null) {
                    return const NavBarRoots();
                  } else {
                    return const OnboardingScreen();
                  }
                }
              },
            ));
      }),
    );
  }
}
