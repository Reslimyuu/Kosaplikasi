import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/whistlist.dart';
import 'package:flutter_application_1/widget/notificationpagesswidget/headernotification.dart';
import 'package:flutter_application_1/widget/itemkosdanmakanan/kositem.dart';
import 'package:flutter_application_1/widget/itemkosdanmakanan/makananitem.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dummy data riwayat (sementara, bisa ganti pakai Firestore nanti)
class RiwayatManager {
  static final List<Map<String, dynamic>> riwayat = [
    {
      "namaKos": "Kos Mawar",
      "tanggal": "12-08-2025",
      "harga": "Rp 1.200.000 / bulan"
    },
    {
      "namaKos": "Kos Melati",
      "tanggal": "05-08-2025",
      "harga": "Rp 950.000 / bulan"
    },
    {
      "namaKos": "Nasi Goreng",
      "tanggal": "05-09-2025",
      "harga": "Rp 10.000"
    },
    {
      "namaKos": "Bakso",
      "tanggal": "06-09-2025",
      "harga": "Rp 10.000",
    }
  ];
}

class Notificationpage extends StatefulWidget {
  final String userName;
  const Notificationpage({super.key, required this.userName});

  @override
  State<Notificationpage> createState() => _NotificationpageState();
}

class _NotificationpageState extends State<Notificationpage> {
  String activeselection = "Riwayat"; // default pilih Riwayat
  String wishlistType = "Kos"; // default pilihan wishlist

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xfff6f6f6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headernotification(userName: widget.userName),
              const SizedBox(height: 24),

              /// 🔹 Header Judul + Tombol
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    activeselection == "Riwayat"
                        ? "Riwayat Pemesanan"
                        : "Wishlist $wishlistType",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff3582A9),
                    ),
                  ),

                  /// 🔹 Tombol kanan
                  activeselection == "Riwayat"
                      ? Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xff3582A9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.history, color: Colors.white),
                        )
                      : PopupMenuButton<String>(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(left: 20.0),
                        elevation: 0,
                          onSelected: (value) {
                            setState(() {
                              wishlistType = value;
                            });
                          },
                          offset: const Offset(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem<String>(
                              padding: EdgeInsets.only( top: 1, left: 40),
                              height: 4,
                              value: "Kos",
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                ),
                                child: Text("Kos", style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),)),
                              
                            ),
                            PopupMenuItem<String>(
                              padding: EdgeInsets.only(bottom: 1, left: 40),
                              height: 4,
                              value: "Makanan",
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                                decoration: BoxDecoration(
                                  color: Colors.amberAccent,
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                                ),
                                child: Text("Makanan", style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),)),
                            ),
                          ],
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xff3582A9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:
                                const Icon(Icons.bookmark, color: Colors.white),
                          ),
                        ),
                ],
              ),

              const SizedBox(height: 14),

              /// 🔹 Tab selector (Riwayat / Wishlist)
              Row(
                children: [
                  _buildSelectionContainer("Riwayat", Icons.history),
                  const SizedBox(width: 12),
                  _buildSelectionContainer("Wishlist", Icons.bookmark),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔹 Content
              Expanded(
                child: activeselection == "Riwayat"
                    ? _buildRiwayatList()
                    : (wishlistType == "Kos"
                        ? _buildKosWishlist()
                        : _buildMakananWishlist()),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Build tombol pilihan atas
  Widget _buildSelectionContainer(String label, IconData icon) {
    bool isSelected = activeselection == label;
    Color containerColor =
        isSelected ? const Color(0xff3582A9) : Colors.grey[300]!;
    Color iconandTextcolor =
        isSelected ? Colors.white : const Color(0xff3582A9);

    return GestureDetector(
      onTap: () {
        setState(() {
          activeselection = label;
        });
      },
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: iconandTextcolor),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: iconandTextcolor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Whistlist Kos

  Widget _buildKosWishlist() {
  final wishlist = WishlistKosManager.getWishlist();

  if (wishlist.isEmpty) {
    return Center(
      child: Text("Belum ada wishlist kos disini", style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),),
    );
  }

  return ListView.builder(
    itemCount: wishlist.length,
    itemBuilder: (context, index) {
      final kos = wishlist[index];

      return Dismissible(
        key: ValueKey(kos.namaKos),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) {
          setState(() {
            WishlistKosManager.removeFromWishlist(kos);
          });
        },
        child: Kositem(
          kos: kos,
          onRemove: () {
            setState(() {
              WishlistKosManager.removeFromWishlist(kos);
            });
          },
        ),
      );
    },
  );
}

  // Whistlist Makanan
  
  Widget _buildMakananWishlist() {
  final wishlist = WishlistMakananManager.getWishlist();

  if (wishlist.isEmpty) {
    return Center(
      child: Text("Belum ada wishlist makanan disini", style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),),
    );
  }

  return ListView.builder(
    itemCount: wishlist.length,
    itemBuilder: (context, index) {
      final makanan = wishlist[index];

      return Dismissible(
        key: ValueKey(makanan.namaMakanan),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) {
          setState(() {
            WishlistMakananManager.removeFromWishlist(makanan);
          });
        },
        child: Makananitem(
          makanan : makanan,
          onRemove : () {
            setState(() {
              WishlistMakananManager.removeFromWishlist(makanan);
            });
          }
        )
      );
    },
  );
}


  /// 🔹 Daftar Riwayat Pemesanan (gabungan)
  Widget _buildRiwayatList() {
    final riwayat = RiwayatManager.riwayat;

    if (riwayat.isEmpty) {
      return const Center(
        child: Text("Belum ada riwayat pemesanan"),
      );
    }

    return ListView.builder(
      itemCount: riwayat.length,
      itemBuilder: (context, index) {
        final data = riwayat[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: Colors.white,
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.history, color: Color(0xff3582A9)),
            title: Text(
              data["namaKos"],
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Color(0xff3582A9),
              ),
            ),
            subtitle: Text(
              "${data["harga"]}\nTanggal: ${data["tanggal"]}",
              style: GoogleFonts.poppins(fontSize: 12, color: Color(0xff3582A9)),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
