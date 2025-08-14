import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nom_nom/theme_profile.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset("assets/icons/SUN.svg", height: 78),
            SvgPicture.asset("assets/icons/SUN.svg", height: 78),
            SvgPicture.asset("assets/icons/SUN.svg", height: 78),
            SvgPicture.asset("assets/icons/SUN.svg", height: 78),
          ],
        ),
      ),
    );
  }
}
