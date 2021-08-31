import 'package:flutter/material.dart';
import 'package:psychology_cu/screen/profile/profile_screen.dart';
import 'package:psychology_cu/screen/study/study_screen.dart';
import '../home/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = 'dashboard_screen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  List _pages = [HomeScreen(), StudyScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Study',
            icon: Icon(Icons.school),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
        selectedItemColor: Colors.deepOrange,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }

}

