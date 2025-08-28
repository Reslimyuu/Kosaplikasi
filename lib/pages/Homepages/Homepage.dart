import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Chatpages/chatpage.dart';
import 'package:flutter_application_1/pages/Homepages/homemainpage.dart';
import 'package:flutter_application_1/pages/accountpages/account.dart';
import 'package:flutter_application_1/pages/notificationpages/notificationpage.dart';
import 'package:flutter_application_1/pages/searchpages/searchpage.dart';
import 'package:flutter_application_1/widget/homepagewidget/bottomnavbar.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  bool isLoading = true;
  int _selectedIndex = 0;

  // Isi dari index bottomnavbar

  List<Widget> _pages = [];

  // Fungsi ketika BottomNavbar Di tekan

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Panggil Fungsi loadusername untuk mengambil nama user 

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Fungsi untuk mengambil nama user

  Future<void> _loadUserName() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users') // Dari Collection Users
          .doc(widget.uid)
          .get();


      setState(() {
        userName = userDoc.exists ? (userDoc['name'] ?? 'Pengguna') : 'Pengguna';
        isLoading = false;
        _pages = [
          HomeMainPage(userName: userName!),
          Searchpage(onSearchTap: () {}, userName: widget.uid),
          Notificationpage(userName: widget.uid),
          const Accountpage(),
        ];
      });
    } catch (e) {
      setState(() {
        userName = 'Error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        // Tampilkan Loading sesudah login
        body: Center(child: CircularProgressIndicator(), 
        ),
      );
    }

    // If untuk menampilkan bottomnavbar pada index 0 dan index 3, dan selain index tersebut false
    bool showBottomNavBar = _selectedIndex == 0 || _selectedIndex == 3;

    // Bottomnavbar

    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex],
      bottomNavigationBar: showBottomNavBar
          ? HomeBottomNav(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            )
          : null,
      floatingActionButton: showBottomNavBar
          ? StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(); // loading
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SizedBox(); // tidak ada user
                }

                final users = snapshot.data!.docs;
                final otherUsers =
                    users.where((u) => u["uid"] != widget.uid).toList();

                if (otherUsers.isEmpty) {
                  return const SizedBox(); // kalau cuma ada current user
                }

                final firstUser = otherUsers.first;
                final receiverId = firstUser["uid"];
                final receiverName = firstUser["name"];

                // Untuk floating button dibagian tengah bottom navbar 

                return SizedBox(
                  height: 78,
                  width: 78,
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color: Color(0xff3582A9),
                        width: 2,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    onPressed: () {

                      // Menuju ke chatpage 
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            currentUserId: widget.uid,
                            receiverId: receiverId,
                            receiverName: receiverName,
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.chat,
                      size: 30,
                      color: Color(0xff3582A9),
                    ),
                  ),
                );
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

