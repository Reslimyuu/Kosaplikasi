import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/makananmodel.dart';
import 'package:flutter_application_1/model/whistlist.dart';
import 'package:google_fonts/google_fonts.dart';

class Makananitem extends StatefulWidget {
  final Makanan makanan;
  final VoidCallback? onRemove;

  const Makananitem({super.key, required this.makanan, this.onRemove});

  @override
  State<Makananitem> createState() => _MakananitemState();
}

class _MakananitemState extends State<Makananitem> {
  @override
  Widget build(BuildContext context) {
    // cek apakah makanan sudah di wishlist
    bool isMarked = WishlistMakananManager.isInWishlist(widget.makanan);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar makanan
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: widget.makanan.imageUrl.isNotEmpty
                ? Image.network(
                    widget.makanan.imageUrl,
                    width: 100,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 100,
                    height: 120,
                    color: Colors.grey[100],
                    child: const Icon(
                      Icons.image,
                      size: 50,
                      color: Color(0xff3582A9),
                    ),
                  ),
          ),

          const SizedBox(width: 8),

          // Informasi makanan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama makanan + durasi harga
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Text(
                          widget.makanan.namaMakanan,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff3582A9),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (isMarked) {
                            // Hapus dari wishlist
                            WishlistMakananManager.removeFromWishlist(widget.makanan);
                            widget.onRemove?.call();
                          } else {
                            // Tambahkan ke wishlist
                            WishlistMakananManager.addToWishlist(widget.makanan);
                          }
                        });
                      },
                      icon: Icon(
                        isMarked ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      iconSize: 18,
                      color: isMarked ? Colors.amberAccent : Colors.grey,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                const SizedBox(height: 1),

                // Rating
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xff3582A9),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      SizedBox(width: 8),

                      Row(
                        children: [
                          Text(
                            "Rating ${widget.makanan.rating}",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xff3582A9),
                            ),
                          ),

                          const SizedBox(width: 4),

                          Padding(
                            padding: const EdgeInsets.only(left: 80),
                            child: Text(
                            widget.makanan.durasiHarga,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.brown[400],
                            ),
                                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 2),

                // Harga
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    "Rp ${widget.makanan.harga}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 3),

                // Lokasi
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Color(0xff3582A9),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.makanan.jarak,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
