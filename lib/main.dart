import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipemanager/page/splash_screen.dart';
import 'package:recipemanager/page/edit_recipe_page.dart';
import 'page/login_page.dart';
import 'page/signup_page.dart';
import 'page/home_page.dart';
import 'page/recipedetail_page.dart';
import 'page/addrecipe_page.dart';
import 'page/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'แชร์สูตรอาหาร',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // เปลี่ยนหน้าเริ่มต้นเป็น SplashScreen
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
        '/addRecipe': (context) => AddRecipePage(),
        '/profile': (context) => ProfilePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/recipeDetail') {
          final recipeId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => RecipeDetailPage(recipeId: recipeId),
          );
        } else if (settings.name == '/editRecipe') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => EditRecipePage(
              recipeId: args['recipeId'],
              recipeData: args['recipeData'],
            ),
          );
        }
        return null;
      },
    );
  }
}
