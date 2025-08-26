import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/login/login.dart';
import 'package:flutter_application_1/pages/Homepages/profile.dart';

class Regist extends StatefulWidget {
  const Regist({super.key});

  @override
  State<Regist> createState() => _RegistState();
}

class _RegistState extends State<Regist> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpassword = TextEditingController();
  String? _errorText;
  bool _isobsecure = true;

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    confirmpassword.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _errorText = null;
    });
    if (passwordcontroller.text != confirmpassword.text) {
      setState(() {
        _errorText = "Password Tidak Sama";
      });
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );



      await FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': emailcontroller.text.trim(),
        'name' : '',
        'createdAt': FieldValue.serverTimestamp(),
        'isRead' : true,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => completeprofile(uid: userCredential.user!.uid)),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorText = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double headerHeight = size.height * 0.5;
  
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: headerHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/img/foto.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter),
            ),
          ),

          // Konten Regist

          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  top: headerHeight - 120,
                  left: 0,
                  right: 0,
                  bottom: 0,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                              
                  // isi regist dalam containernya
                              
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.left,
                              
                      ),
                              
                      SizedBox(height: 24),
                              
                      TextField(
                        controller: emailcontroller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                              
                      SizedBox(height: 24),
                              
                      TextField(
                        controller: passwordcontroller,
                        obscureText: _isobsecure,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline),
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isobsecure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isobsecure = ! _isobsecure;
                              });
                            },
                          ),  
                        ),
                      ),
                              
                      SizedBox(height: 24),
                              
                      TextField(
                        controller: confirmpassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline),
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: confirmpassword.text.isEmpty
                            ? null
                            : (confirmpassword.text == passwordcontroller.text
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : Icon(Icons.cancel, color: Colors.red))
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                              
                      SizedBox(height: 24),
                              
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff2B5BBa),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16)
                        ),
                        onPressed: _register,
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                              
                      SizedBox(height: 16),
                              
                      Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("OR"),
                          ),
                              
                          Expanded(
                            child: Divider()),
                        ],
                      ),
                              
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.home_filled, size: 42),
                            onPressed: () {} ),
                              
                            SizedBox(width: 24),
                              
                            IconButton(
                              icon: Icon(Icons.facebook, size: 42),
                              onPressed: () {} )
                        ],
                      ),
                    ],
                  ),
                ),
                ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xff2B5BBA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                ),
                elevation: 1,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
               child: Text("Sign Up"),
               onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                  );
               }))
        ],
      ),
    );
  }
}