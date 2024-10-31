import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  Future<Map<String, String?>> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return {
        'username': userData['username'],
        'email': user.email,
      };
    }
    return {'username': null, 'email': null};
  }

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // นำไปหน้า Login หลังออกจากระบบ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepOrange.shade200,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 20),
            FutureBuilder<Map<String, String?>>(
              future: _loadUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Text('ไม่พบข้อมูลผู้ใช้', style: TextStyle(fontSize: 18, color: Colors.grey));
                } else {
                  final userData = snapshot.data!;
                  return Column(
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                      ),
                      SizedBox(height: 8),
                      Text(
                        userData['username'] ?? 'ไม่มีชื่อผู้ใช้',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Email',
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                      ),
                      SizedBox(height: 8),
                      Text(
                        userData['email'] ?? 'ไม่มีอีเมล',
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                    ],
                  );
                }
              },
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _logout(context),
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text(
                  'ออกจากระบบ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'จัดทำโดย กนกพล ขจรบุญ\n466412221001 ITS46621N',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
