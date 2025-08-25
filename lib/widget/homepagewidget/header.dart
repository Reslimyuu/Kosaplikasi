import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  final String userName;

  const Header({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Color(0xff3582A9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              userName,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff3582A9),
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none),
          color: Color(0xff3582A9),
          iconSize: 28,
          onPressed: () {},
        ),
      ],
    );
  }
}
