import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:the_walls/auth/login_or_register.dart';
import 'package:the_walls/firebase_options.dart';
import 'package:the_walls/themes/dark_theme.dart';
import 'package:the_walls/themes/light_theme.dart';
// import 'package:the_walls/pages/login_page.dart';
// import 'package:the_walls/pages/register_page.dart';

import 'auth/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const AuthPage(),
    );
  }
}
