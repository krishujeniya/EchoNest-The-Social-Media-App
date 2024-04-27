// ignore: depend_on_referenced_packages
// ignore_for_file: avoid_print, depend_on_referenced_packages, duplicate_ignore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:echonest/Screens/Feed.dart';
import 'package:echonest/Screens/Check.dart';
import 'firebase_options.dart';
import 'package:echonest/Constants/Constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget getScreenId() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            print('User is logged in: ${snapshot.data!.uid}');
            return Feed(currentUserId: snapshot.data!.uid);
          } else {
            print('User is not logged in');
            return const Check();
          }
        } else {
          return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(ThemeMain),
                );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EchoNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ThemeMainBG,
        primaryColor: ThemeMain,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: ThemeMain),
      ),
      home: AnimatedSplashScreen(
        splashIconSize: 250,
        duration: 1000,
        splash: Image.asset(
          'assets/icon.png', // Replace with the correct path to your image
        ),
        nextScreen: getScreenId(),
        animationDuration: const Duration(seconds: 2),
        splashTransition: SplashTransition.rotationTransition,
        pageTransitionType: PageTransitionType.rightToLeft,
        backgroundColor: ThemeMain,
      ),
    );
  }
}
