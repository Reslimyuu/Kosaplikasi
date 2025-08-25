import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatRoomPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String currentUserId;

  const ChatRoomPage({
    Key? key,
    required this.receiverId,
    required this.receiverName,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();



  Future<void> markMessagesAsRead(String currentUserId, String otherUserId) async {
  final query = await FirebaseFirestore.instance
      .collection('Chats')
      .doc(otherUserId) // masuk ke dokumen lawan bicara
      .collection(currentUserId) // subkoleksi pesan yang dikirim ke kita
      .where('receiverId', isEqualTo: currentUserId)
      .where('isRead', isEqualTo: false) // hanya pesan belum dibaca
      .get();

  for (var doc in query.docs) {
    await doc.reference.update({'isRead': true});
  }
}

  /// Fungsi untuk mengirim pesan
  Future<void> _sendMessage(String text) async {
    if (text.trim().isNotEmpty) {
      final timestamp = FieldValue.serverTimestamp();

      // Menyimpan pesan ke koleksi Chats
      await FirebaseFirestore.instance
          .collection('Chats')
          .doc(widget.currentUserId)
          .collection(widget.receiverId)
          .add({
        'senderId': widget.currentUserId,
        'receiverId': widget.receiverId,
        'text': text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'isRead' : false,
      });
      _messageController.clear();



      // Memperbarui LastMessage untuk pengirim
      await FirebaseFirestore.instance
      .collection('Users')
      .doc(widget.currentUserId)
      .update(
        {
          'lastMessageTime': timestamp
        }
      );

      // Memperbarui LastMessage untuk penerima
      await FirebaseFirestore.instance
      .collection('Users')
      .doc(widget.receiverId)
      .update({
        'lastMessageTime' : timestamp
      });

      Future.delayed( Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0.0);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    markMessagesAsRead(widget.currentUserId, widget.receiverId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff3582A9),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  maxRadius: 20,
                  minRadius: 20,
                  backgroundColor: Colors.blueAccent,
                ),

                SizedBox(width: 8),

                Text(
                  widget.receiverName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Tambahkan logika untuk menu lainnya
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // StreamBuilder untuk menampilkan pesan
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Chats')
                  .doc(widget.currentUserId)
                  .collection(widget.receiverId)
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada pesan",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                Future.delayed( Duration(milliseconds: 100), () {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(0.0);
                  }
                });

                // Untuk Chat

                return ListView.builder(
                  controller: _scrollController,
                  reverse: false, // Pesan tetap muncul di bagian atas
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index].data() as Map<String, dynamic>;
                    final isCurrentUser = message['senderId'] == widget.currentUserId;

                    final timestamp = message['timestamp'] as Timestamp?;
                    final formattedDate = timestamp != null
                        ? DateFormat('dd MMM yyyy').format(timestamp.toDate()) // Format waktu
                        : "";
                    final formattedTime = timestamp != null
                        ? DateFormat('HH:mm').format(timestamp.toDate()) // Format waktu
                        : "";

                    bool showDateHeader = false;
                    if ( index == 0) {
                      showDateHeader = true;
                    } else {
                      final previousMessage = messages[ index -1 ].data() as Map<String, dynamic>;
                      final previousTimestamp = previousMessage['timestamp'] as Timestamp?;
                      final previousDate = previousTimestamp != null
                            ? DateFormat('dd MMM yyyy').format(previousTimestamp.toDate())
                            : "";
                      showDateHeader = formattedDate != previousDate;
                    }

                    // Main content dari Chat

                    return Column(
                      crossAxisAlignment: 
                           isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (showDateHeader)
                          Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                formattedDate,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff3582A9),
                                ),
                              ),
                            ),
                          ),



                          // Bubble chat untuk pesan
                        Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75, // Batas maksimum 75% dari lebar layar
                            ),
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? const Color(0xff3582A9) // Warna biru untuk pengirim
                                  : Colors.grey[300], // Warna abu-abu untuk penerima
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: isCurrentUser
                                    ? const Radius.circular(12)
                                    : const Radius.circular(0),
                                bottomRight: isCurrentUser
                                    ? const Radius.circular(0)
                                    : const Radius.circular(12),
                              ),
                            ),
                          
                            // Isi chat
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  message['text'] ?? "",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isCurrentUser ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                          
                                // Waktu di chat
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    formattedTime,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10, // Ukuran font kecil untuk waktu
                                      fontWeight: FontWeight.bold,
                                      color: isCurrentUser ? Colors.white70 : Colors.black54, // Warna sesuai bubble
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          // TextField untuk mengirim pesan
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Ketik disini",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xff3582A9)),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}