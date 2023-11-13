// login_screen.dart
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:encuadrado_app/providers/professional_provider.dart';
import 'package:encuadrado_app/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late ProfessionalProvider professionalProvider;

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    professionalProvider = ProfessionalProvider();
  }

  void _login() {
    if (usernameController.text == professionalProvider.professionalModel.username) {
      String enteredPasswordHash = sha256.convert(utf8.encode(passwordController.text)).toString();
      if (enteredPasswordHash == professionalProvider.professionalModel.passwordHash) {
        // Correct login
        setState(() {
          isLoggedIn = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Welcome, ${professionalProvider.professionalModel.username}!'),
          duration: Duration(seconds: 2),
        ));
        Navigator.pushReplacementNamed(context, '/professional_view');
        return;
      } else {
        // Incorrect password
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid password. Please try again.'),
          duration: Duration(seconds: 2),
        ));
        return;
      }
    }
    // Invalid username or password
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Invalid username or password. Please try again.'),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
