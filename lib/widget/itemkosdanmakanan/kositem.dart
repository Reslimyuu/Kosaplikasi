import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/kosmodel.dart';
import 'package:flutter_application_1/model/whistlist.dart';
import 'package:google_fonts/google_fonts.dart';

class Kositem extends StatefulWidget {
  final Kos kos;
  final VoidCallback? onRemove;

  const Kositem({
    super.key,
    required this.kos,
    this.onRemove,
  });

  @override
  State<Kositem> createState() => _KositemState();
}

class _KositemState extends State<Kositem> {
  bool isMarked = false;

  @override
  void initState() {
    super.initState();
    // cek apakah kos ini sudah ada di wishlist
    isMarked = WishlistKosManager.isInWishlist(widget.kos);
  }

  @override
  Widget build(BuildContext context) {
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
          // Gambar kos
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: widget.kos.imageUrl.isNotEmpty
                ? Image.network(
                    widget.kos.imageUrl,
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

          // Informasi kos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama kos + tombol bookmark
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Text(
                          widget.kos.namaKos,
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
                            // Unbookmark
                            WishlistKosManager.removeFromWishlist(widget.kos);
                            widget.onRemove?.call();
                          } else {
                            // Bookmark
                            WishlistKosManager.addToWishlist(widget.kos);
                          }
                          isMarked = !isMarked;
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
                      const SizedBox(width: 4),
                      Row(
                        children: [
                          Text(
                            "Rating ${widget.kos.rating}",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xff3582A9),
                            ),
                          ),

                          SizedBox(width: 8),

                          Padding(
                            padding: const EdgeInsets.only(left: 80),
                            child: Column(
                            children: [
                              Text(
                                widget.kos.durasiHarga,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.brown[400],
                                ),
                              ),
                              Text(
                                widget.kos.durasiHarga1,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.brown[400],
                                ),
                              ),
                            ],
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
                    "Rp ${widget.kos.harga}",
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
                      widget.kos.jarak,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
