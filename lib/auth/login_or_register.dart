import 'package:flutter/material.dart';
import 'package:the_walls/pages/register_page.dart';

import '../pages/login_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initilayy show the login page

  bool showLoginPage = true;

  //toggle between pages

  void toggelPages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: toggelPages,
      );
    }
    return RegisterPage(
      onTap: toggelPages,
    );
  }
}
