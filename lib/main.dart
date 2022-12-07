import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uqarar_fyp/screens/auth/login.dart';
import 'package:uqarar_fyp/screens/home/home.dart';
import 'package:uqarar_fyp/screens/splash_sceen/splash_screen.dart';

import 'all_screens.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 9, 36, 117),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 9, 36, 117)))),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromARGB(255, 9, 36, 117)),
        textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Color.fromARGB(255, 9, 36, 117)),
        appBarTheme: AppBarTheme(
            titleTextStyle:
                GoogleFonts.raleway(textStyle: const TextStyle(fontSize: 18))),
      ),
      home: SplashScreen(),
      //LoginScreen(),
      // (user != null) ? AllScreens("Login") : LoginScreen(),
    );
  }
}
