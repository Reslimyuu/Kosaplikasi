import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/Chatpages/Groupchatpage.dart';
import 'package:flutter_application_1/pages/Chatpages/chatroompages.dart';
import 'package:flutter_application_1/servicemodel/chatservice.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String currentUserId;

  const ChatPage({
    Key? key,
    required this.receiverId,
    required this.receiverName,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  bool isGroupMode = false; // Mode untuk menentukan apakah sedang di "Chat" atau "Group"

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChatService().markMessagesAsRead(widget.currentUserId, widget.receiverId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(isGroupMode ? "Group" : "Chat", style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        backgroundColor: const Color(0xff3582A9),
      ),
      body: Column(
        children: [
          // Tab untuk Chat dan Group
          Container(
            color: const Color(0xff3582A9),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isGroupMode = false; // Mode Chat
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isGroupMode ? const Color(0xff3582A9) : Colors.white,
                    foregroundColor: isGroupMode ? Colors.white : const Color(0xff3582A9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Chat", style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isGroupMode = true; // Mode Group
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isGroupMode ? Colors.white : const Color(0xff3582A9),
                    foregroundColor: isGroupMode ? const Color(0xff3582A9) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Group", style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ],
            ),
          ),
          Expanded(
            child: isGroupMode
                ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("Groups").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text("Tidak ada grup", style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withAlpha(80)
                        ),));
                      }

                      final groups = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          final group = groups[index].data() as Map<String, dynamic>;
                          final groupId = groups[index].id;

                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.group, color: Colors.white),
                            ),
                            title: Text(group["name"] ?? "No Name",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),),
                            subtitle: Text("Pesan grup"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GroupChatPage(
                                    groupId: groupId,
                                    groupName: group["name"] ?? "No Name",
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("Users").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("Tidak ada user"));
                      }

                      final users = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index].data() as Map<String, dynamic>;
                          final userId = users[index].id;

                          // Skip user sendiri
                          if (userId == currentUserId) {
                            return const SizedBox.shrink();
                          }

                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(user["name"] ?? "No Name", 
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                ),
                                ),

                                Text(
                                  user["lastMessageTime"] != null
                                        ? DateFormat("HH:mm").format(user["lastMessageTime"].toDate())
                                        : "--:--",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                )
                              ],
                            ),
                            subtitle: Row(
                                children: [
                                  // pesan terakhir
                                  Expanded(
                                    child: FutureBuilder<QuerySnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('Chats')
                                          .doc(currentUserId)
                                          .collection(userId)
                                          .orderBy('timestamp', descending: true)
                                          .limit(1)
                                          .get(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                          return Text(
                                            "",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.grey[800],
                                            ),
                                          );
                                        }
                                        final lastMessage = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                                        return Text(
                                          lastMessage['text'] ?? "No Last Message",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[800],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      },
                                    ),
                                  ),

                                  // badge unread
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Chats')
                                        .doc(userId) // ambil chat dari lawan bicara
                                        .collection(currentUserId) // pesan yang masuk ke kita
                                        .where('receiverId', isEqualTo: currentUserId)
                                        .where('isRead', isEqualTo: false)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) return const SizedBox();
                                      int unreadCount = snapshot.data!.docs.length;
                                      if (unreadCount == 0) return const SizedBox();

                                      return Container(
                                        margin: const EdgeInsets.only(left: 6),
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          "$unreadCount",
                                          style: const TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            onTap: () {

                                print("Navigasi ke ChatPage dengan:");
                                print("receiverId: $userId");
                                print("receiverName: ${user["name"] ?? "No Name"}");
                                print("currentUserId: $currentUserId");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatRoomPage(
                                    receiverId: userId,
                                    receiverName: user["name"] ?? "No Name",
                                    currentUserId: currentUserId,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}