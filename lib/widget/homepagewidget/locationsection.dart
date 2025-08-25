import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Sesuai Lokasi Kamu",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff1A485E),
              ),
            ),
            TextButton(
              child: Text(
                "Lihat Semua",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3582A9),
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),

            SizedBox(height: 18),
        // Item List Section
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (content, index) {
              return Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Color(0xff1A485E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                    child: Center(
                      child: Text(
                        'Item ${index + 1}',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
      ],
    );
  }
}
