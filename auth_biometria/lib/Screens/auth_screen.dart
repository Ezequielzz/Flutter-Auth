import 'package:auth_biometria/Service/acesso_log_service.dart';
import 'package:auth_biometria/Service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:auth_biometria/Screens/home_screen.dart';
import 'package:auth_biometria/Service/auth_service.dart';
import 'package:auth_biometria/Service/acesso_log_service.dart';
import 'package:auth_biometria/Controller/loc_checker.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  final AuthService _authService = AuthService();
  final AccessLogService _accessLogService = AccessLogService();

  // Função para autenticação biométrica e login
  Future<void> _authenticateAndLogin() async {
    LocationChecker locationChecker = LocationChecker();
    bool isInRestrictedArea = await locationChecker.isWithinRestrictedArea();

    if (isInRestrictedArea) {
      try {
        bool didAuthenticate = await _authService.authenticateWithBiometrics();
        if (didAuthenticate) {
          await _authService.login(
            _emailController.text,
            _passwordController.text,
          );
          await _accessLogService.registrarAcesso(true); // Acesso permitido
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          setState(() {
            _errorMessage = 'Autenticação biométrica falhou.';
          });
          await _accessLogService.registrarAcesso(false); // Falha na biometria
        }
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Você não está na área restrita.';
      });
      await _accessLogService.registrarAcesso(false); // Acesso negado pela localização
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
                labelText: 'Email',
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
                  color: const Color(0xFF1C3A57),
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
