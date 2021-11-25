import 'package:flutter/material.dart';

import '/screen/profile/profile_screen.dart';
import '/screen/study/study_screen.dart';
import '../home/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = 'dashboard_screen';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _selectedPageIndex;
  late PageController _pageController;

  final List<Widget> _pages = [
    const HomeScreen(),
    const StudyScreen(),
    const ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = 0;
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: 16,
          items: const [
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
          selectedFontSize: 13,
          currentIndex: _selectedPageIndex,
          onTap: (index) {
            setState(() {
              _selectedPageIndex = index;
              // jump to next page
              _pageController.jumpToPage(index);
            });
          },
        ),

        // dashboard body
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: _pages,
        ));
  }
}
