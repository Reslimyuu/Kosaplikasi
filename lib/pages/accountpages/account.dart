import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/login/login.dart';

class Accountpage extends StatelessWidget {
  const Accountpage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil ukuran layar
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Color(0xfff6f6f6),
      body: SafeArea(
        child: Column(
          children: [
            // Bagian atas avatar + tombol edit
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.08, // 3% tinggi layar
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(80),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: screenWidth * 0.13, // 13% dari lebar layar
                    backgroundColor: const Color(0xff1E4D64),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: screenWidth * 0.13, // Ikut responsif
                    ),
                  ),
                  
                  SizedBox(width: 20),
                  
                  Padding(
                    padding: const EdgeInsets.only(bottom: 90, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {}, 
                          label: Text("Edit", style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),),
                          icon: Icon(Icons.edit, color: Colors.white, size: 20),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenHeight * 0.005,
                            ),
                            backgroundColor: Colors.amberAccent,
                            foregroundColor: Colors.black,
                            textStyle: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )
                          ),
                          ),
                      ],
                    ),
                  ),

                  
                  // Tombol edit di pojok kanan atas avatar
                  Positioned(
                    right: screenWidth * 0.32,
                    top: 54,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent,
                      ),
                    )
                  )
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            // Daftar menu
            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem(Icons.settings, "Pengaturan Akun", () {}, screenWidth),
                  _buildMenuItem(Icons.notifications, "Notifikasi", () {}, screenWidth),
                  _buildMenuItem(Icons.payment, "Pembayaran dan Transaksi", () {}, screenWidth),
                  _buildMenuItem(Icons.help_outline, "Bantuan dan Dukungan", () {}, screenWidth),
                  _buildMenuItem(Icons.tune, "Pengaturan Aplikasi", () {}, screenWidth),
                  _buildMenuItem(Icons.bar_chart, "Laporan", () {}, screenWidth),

                  const Divider(),
                  // Logout
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      "Logout",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04, // responsif
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();

                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (context) => Login()), 
                        (route) => false,
                        );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, double screenWidth) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: screenWidth * 0.06),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: screenWidth * 0.04, // Ukuran responsif
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
