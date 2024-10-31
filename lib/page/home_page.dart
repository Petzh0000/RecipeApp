import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แอปแชร์สูตรอาหาร'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var recipes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: recipes.length,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            itemBuilder: (context, index) {
              var recipe = recipes[index];
              var recipeData = recipe.data() as Map<String, dynamic>;

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange.shade200,
                    child: Icon(
                      Icons.fastfood,
                      color: Colors.deepOrange,
                      size: 30,
                    ),
                  ),
                  title: Text(
                    recipeData['title'] ?? 'ไม่มีชื่อเมนู',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    'ส่วนผสม: ${recipeData['ingredients'] ?? 'ไม่มีส่วนผสม'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/recipeDetail',
                      arguments: recipe.id,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () => Navigator.pushNamed(context, '/addRecipe'),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
