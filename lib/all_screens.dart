import 'package:flutter/material.dart';
import 'package:uqarar_fyp/screens/home/home.dart';
import 'package:uqarar_fyp/screens/meetings/schedule.dart';
import 'package:uqarar_fyp/screens/profile/profile.dart';

class AllScreens extends StatefulWidget {
  final screen;

  AllScreens(this.screen);

  @override
  State<AllScreens> createState() => _AllScreensState();
}

class _AllScreensState extends State<AllScreens> {
  int _currentIndex = 0;

  List screens = [
    HomeScreen(),
    EventCalendarScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    if (widget.screen == "Home") {
      _currentIndex = 0;
    } else if (widget.screen == "Meetings") {
      _currentIndex = 1;
    } else if (widget.screen == "Profile") {
      _currentIndex = 2;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 9, 36, 117),
        title: (_currentIndex == 0)
            ? const Text("Home")
            : (_currentIndex == 1)
                ? const Text("Meetings")
                : const Text("Profile"),
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Meetings"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }
}
