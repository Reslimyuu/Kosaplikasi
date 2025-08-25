import 'package:flutter/material.dart';

class HomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: null,
      color: Color(0xff3582A9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home, 0),
          _navIcon(Icons.search, 1),
          const SizedBox(width: 54), // space untuk FAB
          _navIcon(Icons.notifications, 2),
          _navIcon(Icons.person, 3),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: currentIndex == index ? Color(0xff3582A9) : Colors.white,
          size: 24,
        ),
        onPressed: () => onTap(index),
      ),
    );
  }
}
