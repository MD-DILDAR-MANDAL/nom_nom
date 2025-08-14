import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nom_nom/theme_profile.dart';
import 'package:nom_nom/ui/camera_screen.dart';
import 'package:nom_nom/ui/history_screen.dart';

class Navigation extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Navigation({super.key, required this.cameras});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentState = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [CameraScreen(camera: widget.cameras[0]), HistoryScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,

      body: pages[_currentState],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentState,
        onTap: (index) {
          setState(() {
            _currentState = index;
          });
        },
        backgroundColor: primary,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        items: [
          // BottomNavigationBarItem(
          //   icon: AnimatedContainer(
          //     duration: Duration(seconds: 5),
          //     curve: Curves.bounceInOut,
          //     child: Image.asset(
          //       "assets/icons/Mushrooms.png",
          //       height: _currentState == 0 ? 80 : 60,
          //     ),
          //   ),
          //   label: 'Game',
          // ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: Duration(seconds: 5),
              curve: Curves.bounceInOut,
              child: SvgPicture.asset(
                "assets/icons/Circle.svg",
                height: _currentState == 0 ? 80 : 60,
              ),
            ),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: Duration(seconds: 5),
              curve: Curves.bounceInOut,
              child: SvgPicture.asset(
                "assets/icons/History.svg",
                height: _currentState == 1 ? 80 : 60,
              ),
            ),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
