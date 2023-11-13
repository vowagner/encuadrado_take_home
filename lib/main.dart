// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:encuadrado_app/views/login_view.dart';
import 'package:encuadrado_app/views/professional_view.dart';
import 'package:encuadrado_app/providers/professional_provider.dart';
import 'package:encuadrado_app/providers/appt_provider.dart'; 
import 'package:encuadrado_app/views/customer_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfessionalProvider()),
        ChangeNotifierProvider(create: (context) => ApptProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encuadrado Lite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => StartScreen(),
        '/professional_view': (context) => ProfessionalView(),
        '/login_view': (context) => LoginScreen(),
        '/customer_view': (context) => CustomerView(),
      },
    );
  }
}
class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encuadrado Lite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              child: Image.asset('assets/images/encuadrado_logo.png'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Modo Profesional'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerView()));
              },
              child: Text('Modo Paciente'),
            ),
          ],
        ),
      ),
    );
  }
}
