import 'package:babysitterapp/pages/chat/chatpage.dart';
import 'package:babysitterapp/pages/homepage/home_page.dart';
import 'package:babysitterapp/pages/settings_page/settings_page.dart';
import 'package:babysitterapp/styles/colors.dart';
import 'package:babysitterapp/styles/route_animation.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final String currentUserID;
  const BottomNavBar({
    super.key,
    required this.currentUserID,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: backgroundColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        await Navigator.push(
            context,
            RouteAnimate(0.0, 1.0,
                page: ChatPage(
                  currentUserID: widget.currentUserID,
                )));
        break;
      case 2:
        await Navigator.push(
            context, RouteAnimate(1.0, 0, page: const SettingsPage()));
        break;
      default:
        const HomePage();
    }

    setState(() {
      _selectedIndex = 0;
    });
  }
}
