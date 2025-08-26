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

  Future<void> _sendMessage(String text) async {
  if (text.trim().isEmpty) return;

  final timestamp = FieldValue.serverTimestamp();

  final messageData = {
    'senderId': widget.currentUserId,
    'receiverId': widget.receiverId,
    'text': text.trim(),
    'timestamp': timestamp,
    'isRead': false, // default false untuk penerima
  };

  _messageController.clear();


  // Simpan di sisi pengirim
  await FirebaseFirestore.instance
      .collection('Chats')
      .doc(widget.currentUserId)
      .collection(widget.receiverId)
      .add(messageData);

  // Simpan di sisi penerima
  await FirebaseFirestore.instance
      .collection('Chats')
      .doc(widget.receiverId)
      .collection(widget.currentUserId)
      .add(messageData);

  // Update lastMessageTime
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(widget.currentUserId)
      .update({'lastMessageTime': timestamp});

  await FirebaseFirestore.instance
      .collection('Users')
      .doc(widget.receiverId)
      .update({'lastMessageTime': timestamp});
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
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada pesan",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent, 
                      duration: Duration(milliseconds: 200), 
                      curve: Curves.easeOut,
                      );
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
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Ketik disini",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
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
          ),
        ],
      ),
    );
  }
}