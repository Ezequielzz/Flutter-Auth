import 'package:auth_biometria/Screens/auth_screen.dart';
import 'package:auth_biometria/Screens/detalhes_carros_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/home_screen.dart';
import 'firebase_options.dart'; // Arquivo gerado automaticamente ao configurar o Firebase.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Verifique se o Firebase já foi inicializado
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
