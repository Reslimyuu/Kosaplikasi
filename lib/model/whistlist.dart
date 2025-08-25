import 'package:flutter_application_1/model/kosmodel.dart';
import 'package:flutter_application_1/model/makananmodel.dart';

class WishlistKosManager {
  static List<Kos> wishlist = [];

  static void addToWishlist(Kos kos) {
    wishlist.add(kos);
  }

  static void removeFromWishlist(Kos kos) {
    wishlist.removeWhere((item) => item.namaKos == kos.namaKos);
  }

  static bool isInWishlist(Kos kos) {
    return wishlist.any((item) => item.namaKos == kos.namaKos);
  }

  static List<Kos> getWishlist() {
    return wishlist;
  }
}

class WishlistMakananManager {
  static List<Makanan> wishlist = [];

  static void addToWishlist(Makanan makanan) {
    wishlist.add(makanan);
  }

  static void removeFromWishlist(Makanan makanan) {
    wishlist.removeWhere((item) => item.namaMakanan == makanan.namaMakanan);
  }

  static bool isInWishlist(Makanan makanan) {
    return wishlist.any((item) => item.namaMakanan == makanan.namaMakanan);
  }

  static List<Makanan> getWishlist() {
    return wishlist;
  }
}
