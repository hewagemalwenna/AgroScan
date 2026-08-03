import 'dart:io';
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

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: "AIzaSyCN1CGVoTx5RPHjrVYxfVRVldMkVRhG6hc",
          appId: "1:1039656103958:android:318b6b520ac45ab5e5c537",
          messagingSenderId: "1039656103958",
          projectId: "cs-86-sdgp",
        ))
      : await Firebase.initializeApp();
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
          themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
          darkTheme: notifier.isDark ? notifier.darkTheme : notifier.lightTheme,
          home: FutureBuilder(
            future: FirebaseAuth.instance.authStateChanges().first,
            builder: (context,AsyncSnapshot<User?> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());

              }else{
                if (snapshot.hasData && snapshot.data!=null){
                  return const NavBarRoots();
                }
                else{
                  return const OnboardingScreen();
                }
              }
            },
          )
        );
      }),
    );
  }
}
