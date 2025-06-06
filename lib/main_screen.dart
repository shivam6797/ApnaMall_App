import 'package:apnamall_ecommerce_app/features/products/screens/product_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavIcon(IconData icon, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Align(
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 20,
          color: _selectedIndex == index ? Color(0xffff650e) : Colors.grey.shade500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        shape: CircularNotchedRectangle(),
        notchMargin: 6,
        elevation: 10,
        color: Colors.white,
        child: SizedBox(
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 45, child: _buildNavIcon(Icons.grid_view_outlined, 0)),
              SizedBox(width: 45, child: _buildNavIcon(FontAwesomeIcons.heart, 1)),
              const SizedBox(width: 48),
              SizedBox(width: 45, child: _buildNavIcon(FontAwesomeIcons.cartShopping, 2)),
              SizedBox(width: 45, child: _buildNavIcon(FontAwesomeIcons.user, 3)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xffff650e),
        shape: const CircleBorder(),
        elevation: 4,
        child:  Image.asset("assets/images/home_icon.png",
         height: 25,
         width: 25,
         color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
