import 'package:flutter/material.dart';
import 'package:food_delivery/screens/restaurant/owner_homepage.dart';

class BottomNav extends StatefulWidget {
  static const String routeName ='bottom-nav';
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    //here is the bug/error
    OwnerHomepage(),
    //11
    orders(),
    Notifications(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            label: 'Dashboard',
            icon: Icon(Icons.dashboard)),
          BottomNavigationBarItem(
            label: 'Orders',
            icon: Icon(Icons.shopping_cart)),
          BottomNavigationBarItem(
            label: 'Notifications',
            icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
class orders extends StatelessWidget {
  const orders({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}