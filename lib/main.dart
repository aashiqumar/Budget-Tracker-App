// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:budget_tracker/google_sheets_api.dart';
import 'package:budget_tracker/homepage.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleSheetsAPI().init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      title: "Mistt",
      debugShowCheckedModeBanner: false,
    );
  }
}


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashTransition: SplashTransition.fadeTransition, 
      duration: 3000,
      backgroundColor: Color.fromARGB(255, 227, 226, 226),
      splash: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("mistt", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),),
            Text(" Lite", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 69, 68, 68), fontWeight: FontWeight.bold),)
          ],
        ),
      nextScreen: HomePage());
  }
}