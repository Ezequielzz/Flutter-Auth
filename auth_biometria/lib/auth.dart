import 'package:auth_biometria/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart'; // Import necessário para biometria

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication(); // Inicializando para usar biometria

  String? _errorMessage;

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
      // Login bem-sucedido, redireciona para a tela Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro no login: $e';
      });
    }
  }

  // Função para autenticação biométrica
  Future<void> _authenticateAndLogin() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await auth.canCheckBiometrics || await auth.isDeviceSupported();

      if (canAuthenticateWithBiometrics) {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Autentique-se para fazer login',
          options: const AuthenticationOptions(biometricOnly: true),
        );

        if (didAuthenticate) {
          // Após autenticação biométrica bem-sucedida, realiza o login com email e senha
          await _login();
        }
      } else {
        setState(() {
          _errorMessage = 'Biometria não disponível no dispositivo.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro na autenticação biométrica: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1E36), // Cor de fundo azul escuro
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo no topo
            Image.asset(
              'assets/images/biosecurity.png', // Substitua pelo caminho correto da imagem no seu projeto
              height: size.height * 0.2,
            ),
            const SizedBox(height: 40), // Espaço entre a logo e os campos

            // Campo de texto para o usuário
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white), // Texto branco
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1C3A57), // Fundo azul escuro
                labelText: 'Usuario',
                labelStyle: const TextStyle(color: Colors.white), // Texto do label em branco
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none, // Remove a borda
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de texto para a senha
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white), // Texto branco
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1C3A57), // Fundo azul escuro
                labelText: 'Senha do Usuario',
                labelStyle: const TextStyle(color: Colors.white), // Texto do label em branco
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none, // Remove a borda
                ),
              ),
            ),
            const SizedBox(height: 40), // Espaço antes do botão de biometria

            // Botão de autenticação por biometria
            GestureDetector(
              onTap: _authenticateAndLogin,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.fingerprint,
                  size: 50,
                  color: Colors.blue, // Cor do ícone de biometria
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
