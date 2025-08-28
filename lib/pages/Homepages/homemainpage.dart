import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/homepagewidget/bannersection.dart';
import 'package:flutter_application_1/widget/homepagewidget/categoryicon.dart';
import 'package:flutter_application_1/widget/homepagewidget/header.dart';
import 'package:flutter_application_1/widget/homepagewidget/locationsection.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeMainPage extends StatelessWidget {
  final String userName;

  const HomeMainPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      // Isi dari Homepage

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(userName: userName),
              const SizedBox(height: 18),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Beberapa Rekomendasi\n",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff3582A9),
                      ),
                    ),
                    TextSpan(
                      text: "Buat Kamu",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff3582A9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CategoryIcons(
                imagePaths: [
                  'lib/img/dormitory 1.png',
                  'lib/img/cutlery (1) 1.png',
                  'lib/img/briefcase-and-tools-for-school 1.png',
                ],
                colors: [
                  const Color(0xff3582A9),
                  const Color(0xff35A97B),
                  const Color(0xffA96135),
                ],
              ),
              const SizedBox(height: 24),
              const BannerSection(),
              const SizedBox(height: 24),
              const LocationSection(),
            ],
          ),
        ),
      ),
    );
  }
}
