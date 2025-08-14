import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nom_nom/theme_profile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset("assets/icons/History.svg", height: 78),
            SvgPicture.asset("assets/icons/History.svg", height: 78),
            SvgPicture.asset("assets/icons/History.svg", height: 78),
            SvgPicture.asset("assets/icons/History.svg", height: 78),
          ],
        ),
      ),
    );
  }
}
