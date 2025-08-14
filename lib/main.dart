import 'package:flutter/material.dart';
import 'package:nom_nom/theme_profile.dart';
import 'package:nom_nom/ui/bottom_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: primary)),
      home: Navigation(),
    );
  }
}
