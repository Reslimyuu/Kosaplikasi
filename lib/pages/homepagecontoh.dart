// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_1/pages/account.dart';
// import 'package:flutter_application_1/pages/notificationpage.dart';
// import 'package:flutter_application_1/pages/searchpage.dart';
// import 'package:google_fonts/google_fonts.dart';

// class HomePage extends StatefulWidget {
//   final String uid;
//   const HomePage({super.key, required this.uid});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String? userName;
//   bool isLoading = true;
//   int _selectedIndex = 0;

//    List<Widget> _pages = [
//     HomePage(uid: 'uid_placeholder'),
//     Searchpage(),
//     Notificationpage(),
//     Accountpage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadUserName();
//   }

//   Future<void> _loadUserName() async {
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(widget.uid)
//           .get();

//       if (userDoc.exists) {
//         setState(() {
//           userName = userDoc['name'] ?? 'Pengguna';
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           userName = 'Pengguna';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         userName = 'Error';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomAppBar(
//         shape: null,
//         color: Color(0xff3582A9),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _navIcon(Icons.home, 0),
//             _navIcon(Icons.search, 1),
//             const SizedBox(width: 54), // space untuk FAB
//             _navIcon(Icons.notifications, 3),
//             _navIcon(Icons.person, 4),
//           ],
//         ),
//       ),

//       floatingActionButton: SizedBox(
//         height: 78,
//         width: 78,
//         child: FloatingActionButton(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//             side: BorderSide(
//               color: Color(0xff3582A9),
//               width: 2,
//             )
//           ),
//           backgroundColor: Colors.white,
//           onPressed: () => _onItemTapped(2),
//           child: Icon(
//             Icons.chat,
//             size: 30,
//             color: Color(0xff3582A9),
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [

//                 // HEADER
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           width: 30,
//                           height: 30,
//                           decoration: BoxDecoration(
//                             color: Color(0xff3582A9),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Icon(Icons.person, color: Colors.white, size: 16),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           "$userName",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xff3582A9),
//                           ),
//                         ),
//                       ],
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.notifications_none),
//                       color: Color(0xff3582A9),
//                       iconSize: 28,
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 18),

//                 // Kategori beserta Kotak dengan icon

//                 Text.rich(
//                   TextSpan(
//                     children: [
//                       TextSpan(
//                         text: "Beberapa Rekomendasi\n",
//                         style: GoogleFonts.poppins(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xff3582A9),
//                         )
//                       ),
//                       TextSpan(
//                         text: "Buat Kamu",
//                         style: GoogleFonts.poppins(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xff3582A9),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildCategoryIcon('lib/img/dormitory 1.png', Color(0xff3582A9)),
//                     _buildCategoryIcon('lib/img/cutlery (1) 1.png', Color(0xff35A97B)),
//                     _buildCategoryIcon('lib/img/briefcase-and-tools-for-school 1.png', Color(0xffA96135)),
//                   ],
//                 ),

//                 const SizedBox(height: 24),

//                 // Ini section untuk banner iklan nanti

//                 Container(
//                   height: 180,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Color(0xff1A485E),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     "Contoh Banner",
//                     style: GoogleFonts.poppins(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Ini adalah section untuk menampilkan rekomendasi kos sesuai lokasi nanti

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Sesuai Lokasi Kamu",
//                       style: GoogleFonts.poppins(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff1A485E),
//                       ),
//                     ),
//                     TextButton(
//                       child: Text(
//                         "Lihat Semua",
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xff3582A9),
//                         ),
//                       ),
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),

//                 SizedBox(height: 18),

//                 SizedBox(
//                   height: 180,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: 5,
//                     itemBuilder: (content, index) {
//                       return Padding(
//                         padding: EdgeInsets.only(right: 8.0),
//                         child: Container(
//                           width: 200,
//                           decoration: BoxDecoration(
//                             color: Color(0xff1A485E),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'Item ${index + 1}',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _navIcon(IconData icon, int index) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
//       decoration: BoxDecoration(
//         color: _selectedIndex == index ? Colors.white : Colors.transparent,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: IconButton(
//         icon: Icon(
//           icon,
//           color: _selectedIndex == index ? Color(0xff3582A9) : Colors.white,
//           size: 24,
//         ),
//         onPressed: () => _onItemTapped(index),
//       ),
//     );
//   }

//   Widget _buildCategoryIcon(String imagepath, Color color) {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         height: 80,
//         width: 80,
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Image.asset(
//           imagepath,
//           height: 20,
//           width: 20,
//           alignment: Alignment.center,
//         ),
//       ),
//     );
//   }
// }
