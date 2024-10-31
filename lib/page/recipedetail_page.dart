import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeId;

  RecipeDetailPage({required this.recipeId});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late Future<DocumentSnapshot> _recipeFuture;

  @override
  void initState() {
    super.initState();
    _recipeFuture = FirebaseFirestore.instance.collection('recipes').doc(widget.recipeId).get();
  }

  void _refreshRecipe() {
    setState(() {
      _recipeFuture = FirebaseFirestore.instance.collection('recipes').doc(widget.recipeId).get();
    });
  }

  Future<void> _deleteRecipe(BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ยืนยันการลบ'),
        content: Text('คุณต้องการลบสูตรอาหารนี้หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('ลบ'),
          ),
        ],
      ),
    );

    if (confirmDelete) {
      await FirebaseFirestore.instance.collection('recipes').doc(widget.recipeId).delete();
      Navigator.pop(context); // กลับไปหน้าก่อนหน้า
    }
  }

  void _editRecipe(BuildContext context, Map<String, dynamic> recipeData) async {
    final result = await Navigator.pushNamed(
      context,
      '/editRecipe',
      arguments: {
        'recipeId': widget.recipeId,
        'recipeData': recipeData,
      },
    );

    if (result == true) {
      _refreshRecipe(); // รีเฟรชข้อมูลเมื่อแก้ไขสำเร็จ
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดสูตรอาหาร'),
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('ไม่พบข้อมูลสูตรอาหาร'));
          }

          var recipeData = snapshot.data!.data() as Map<String, dynamic>?;

          if (recipeData == null) {
            return Center(child: Text('ข้อมูลสูตรอาหารไม่สมบูรณ์'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipeData['title'] ?? 'ไม่มีชื่อเมนู',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                ),
                SizedBox(height: 20),
                Text(
                  'ส่วนผสม:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 10),
                Text(
                  recipeData['ingredients'] ?? 'ไม่มีส่วนผสม',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                SizedBox(height: 20),
                Text(
                  'วิธีทำ:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 10),
                Text(
                  recipeData['description'] ?? 'ไม่มีวิธีทำ',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  if (_recipeFuture != null) {
                    var recipeData = (await _recipeFuture).data() as Map<String, dynamic>;
                    _editRecipe(context, recipeData);
                  }
                },
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text(
                  'แก้ไข',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  minimumSize: Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _deleteRecipe(context),
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text(
                  'ลบ',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  minimumSize: Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
