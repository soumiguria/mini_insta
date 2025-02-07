import 'package:assignment/screens/feed_page.dart';
import 'package:assignment/screens/profile_page.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          navigateToScreen(context, const FeedPage());
          break;
        case 4:
          navigateToScreen(context, ProfilePage());
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 30,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded), label: ''),
      ],
    );
  }
}

void navigateToScreen(BuildContext context, Widget screen) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}
