import 'package:flutter/material.dart';
import 'package:insee_driver_app/constants/constants.dart';
import 'package:insee_driver_app/screens/landing_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'INSEE Driver App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: buttonColor!),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
