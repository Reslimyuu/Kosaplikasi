import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kirim pesan
  Future<void> sendMessage(String receiverId, String message) async {
    final currentUser = _auth.currentUser!;
    final newMessage = {
      "senderId": currentUser.uid,
      "receiverId": receiverId,
      "message": message,
      "timestamp": FieldValue.serverTimestamp(),
      "isRead": false, // 🔹 selalu false saat pesan dikirim
    };

    await _firestore.collection("message").add(newMessage);
  }

  // Stream pesan antar user
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    return _firestore
        .collection("message")
        .where("senderId", whereIn: [userId, otherUserId])
        .where("receiverId", whereIn: [userId, otherUserId])
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  // Tandai pesan sudah dibaca
  Future<void> markMessagesAsRead(String senderId, String receiverId) async {
    final unreadMessages = await _firestore
        .collection("message")
        .where("senderId", isEqualTo: senderId)
        .where("receiverId", isEqualTo: receiverId)
        .where("isRead", isEqualTo: false) // hanya pesan belum terbaca
        .get();

    for (var doc in unreadMessages.docs) {
      await doc.reference.update({"isRead": true});
    }
  }
}
