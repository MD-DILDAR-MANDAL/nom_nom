import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nom_nom/theme_profile.dart';
import 'package:nom_nom/ui/bottom_navigation.dart';

late List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: primary)),
      home: Navigation(cameras: cameras),
    );
  }
}
