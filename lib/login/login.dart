import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Homepages/Homepage.dart';
import 'package:flutter_application_1/login/regist.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> { 
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool _isobsecure = true;

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );

      String uid = userCredential.user!.uid;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(uid: uid)),
      );
    } catch (e) {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text("Login Failed"),
          content: Text("Please check your email and password."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double headerHeight = size.height * 0.5; // 35% dari tinggi layar

    return Scaffold(
      body: Stack(
        children: [
          // Gambar background di atas
          Container(
            height: headerHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/img/foto.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter
              ),
            ),
          ),
          // Konten login
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  top: headerHeight - 80, // agar overlap sedikit
                  left: 0,
                  right: 0,
                  bottom: 0,
                ),
                child: Column(
                  children: [
                    Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 24),
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
                          const SizedBox(height: 16),
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
                                })
                            ),
                          ),

                          SizedBox(height: 2),

                          Padding(
                            padding: const EdgeInsets.only(left: 160),
                            child: TextButton(
                              onPressed: () {},
                              child: const Text("Forgot Password?"), 
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2B5BBA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              "LOGIN",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text("OR"),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.home_filled, size: 42),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 24),
                              IconButton(
                                icon: Icon(Icons.facebook, size: 42),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Tombol Sign In di pojok kanan atas
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Regist()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF2B5BBA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18), bottomLeft: Radius.circular(18)),
                ),
                elevation: 1,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: const Text("Sign in"),
            ),
          ),
        ],
      ),
    );
  }
}