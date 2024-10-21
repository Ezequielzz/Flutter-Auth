import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;

  // Função para realizar o cadastro
  Future<void> _register() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        _errorMessage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuário registrado com sucesso')));
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  // Função para realizar o login
  Future<void> _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        _errorMessage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login realizado com sucesso')));
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login e Cadastro Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (_errorMessage != null) ...[
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 10),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _register,
                  child: Text('Registrar'),
                ),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
