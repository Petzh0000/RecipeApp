import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    // หน่วงเวลา 3 วินาทีจากนั้นเช็คสถานะการล็อกอิน
    Timer(Duration(seconds: 3), () {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // หากผู้ใช้เคยล็อกอินไว้แล้ว ให้ไปที่หน้า Home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // หากผู้ใช้ยังไม่ได้ล็อกอิน ให้ไปที่หน้า Login
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo.png', // ใส่ path ของโลโก้ของคุณ
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'แชร์สูตรอาหาร',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 50),
            Text(
              'จัดทำโดย กนกพล ขจรบุญ\n466412221001 ITS46621N',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
