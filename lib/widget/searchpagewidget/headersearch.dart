import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Homepages/Homepage.dart';
import 'package:google_fonts/google_fonts.dart';

class Headersearch extends StatefulWidget {
  final String userName;

  const Headersearch({super.key, required this.userName});

  @override
  State<Headersearch> createState() => _HeadersearchState();
}

class _HeadersearchState extends State<Headersearch> {

  @override
  Widget build(BuildContext context) {
    return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(uid: widget.userName))
                      );
                    },
                    child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xff3582A9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text("Kembali",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                        )
                        ),
                    ),
                  )
                ],
              );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/widget/headernotification.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Notificationpage extends StatefulWidget {
//   final String userName;

//   const Notificationpage({super.key, required this.userName});

//   @override
//   State<Notificationpage> createState() => _NotificationpageState();
// }

// class _NotificationpageState extends State<Notificationpage> {
//   String activeselection = "Kos";
  


//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         color: Color(0xfff6f6f6),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Headernotification(userName: widget.userName),

//               SizedBox(height: 24),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Riwayat Kamu",
//                   style: GoogleFonts.poppins(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xff3582A9),
//                   ),
//                   ),

//                   GestureDetector(
//                     child: Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: Color(0xff3582A9),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   )
//                 ],
//               ),

//               SizedBox(height: 14),

//               Row(
//                 children: [
//                   _buildselectioncontainer
//                 ],
//               )

//             ],
//           ),),
//       ));
//   }
// }

// Widget _buildselectioncontainer(String label, IconData icon) {
//   bool isSelected = activeselec == label;
//   Color containerColor = 
//         isSelected ? Color(0xff3582A9) : Colors.grey[300]!;
//   Color iconAndTextColor =
//         isSelected ? Colors.white : Color(0xff3582A9);
//   return GestureDetector(
//     onTap: () {
//     },
//     child: Container(
//       width: 120,
//       height: 40,
//       decoration: BoxDecoration(
//         color: containerColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Padding(
//         padding: EdgeInsets.only(left: 8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Icon(icon, size: 18, color: iconAndTextColor),
            
//             SizedBox(width: 8),

//             Text(label,
//             style: GoogleFonts.poppins(
//               color: iconAndTextColor,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),)
//           ],
//         ),),
//     ),
//   );
// }