import 'package:lista_de_compras/app/features/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lista_de_compras/app/features/pages/login_page.dart';
import 'package:lista_de_compras/app/features/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // determine login state via FirebaseAuth (preferencial) else fall back to prefs
  String? username;
  bool isLoggedIn = false;
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    isLoggedIn = true;
    // synthetic email format username@local
    final email = user.email ?? '';
    if (email.contains('@')) {
      username = email.split('@')[0];
    }
  } else {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    username = prefs.getString('username');
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, username: username));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? username;

  const MyApp({super.key, required this.isLoggedIn, this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de compras',
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: SplashView(
        nextPage: isLoggedIn && username != null
            ? MainPageView(username: username!)
            : LoginPage(),
      ),
    );
  }
}
