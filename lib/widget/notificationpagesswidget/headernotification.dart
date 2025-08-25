import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Homepages/Homepage.dart';
import 'package:google_fonts/google_fonts.dart';

class Headernotification extends StatefulWidget {
  final String userName;

  const Headernotification({super.key, required this.userName});

  @override
  State<Headernotification> createState() => _HeadernotificationState();
}

class _HeadernotificationState extends State<Headernotification> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage(uid: widget.userName))
              );
          },
          child: Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xff3582A9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text("Kembali",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),),
            ),
          ),
        )
      ],
    );
  }
}