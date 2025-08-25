import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/pages/Homepages/Homepage.dart';


class completeprofile extends StatefulWidget {
  final String uid;
  const completeprofile({super.key, required this.uid});

  @override
  State<completeprofile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<completeprofile> {
  String? selectedCampus;
  final TextEditingController nameController = TextEditingController();
  final List<String> campusList = [
    "Universitas A",
    "Universitas B",
    "Universitas C"
  ];

  String? ktmUrl; // Untuk link foto KTM (dummy)

  Future<void> _saveProfile() async {
    if (selectedCampus == null || ktmUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lengkapi semua data")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('Users').doc(widget.uid).update({
      'name': nameController.text.trim(),
      'campus': selectedCampus,
      'ktmUrl': ktmUrl, // sementara kita isi dummy
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Data berhasil disimpan")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(uid: widget.uid)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lengkapi Profil")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedCampus,
              hint: Text("Pilih Asal Kampus"),
              items: campusList.map((campus) {
                return DropdownMenuItem(
                  value: campus,
                  child: Text(campus),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCampus = value;
                });
              },
            ),
            SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Nama Lengkap",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 18),


            // Upload KTM (Dummy)
            ElevatedButton(
              onPressed: () {
                // Dummy URL, nanti bisa diganti dengan upload ke Firebase Storage
                setState(() {
                  ktmUrl = "https://dummyimage.com/200x120/cccccc/000000&text=KTM";
                });
              },
              child: Text("Upload KTM (Dummy)"),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
