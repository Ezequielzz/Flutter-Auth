import 'package:flutter/material.dart';
import 'package:auth_biometria/Services/auth_service.dart';

class ConfigScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E36), // Fundo azul escuro
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E36), // Mesma cor do fundo
        centerTitle: true, // Centralizar o título
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              // Ação para o botão de sair
              authService.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Item Conta
            ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              title: Text(
                'Conta:',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Exibe as informações da sua conta',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                // Ação quando clicar
              },
            ),
            Divider(color: Colors.white24),

            // Item Log de Usuário
            ListTile(
              leading: Icon(Icons.arrow_forward, color: Colors.white),
              title: Text(
                'Log de usuário:',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Exibe as informações do Log de usuário.',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                // Ação quando clicar
              },
            ),
            Divider(color: Colors.white24),

            // Item Log de Acesso
            ListTile(
              leading: Icon(Icons.arrow_forward, color: Colors.white),
              title: Text(
                'Log de acesso:',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Exibe as informações do Log de acesso.',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                // Ação quando clicar
              },
            ),
            Divider(color: Colors.white24),

            // Item Sobre
            ListTile(
              leading: Icon(Icons.info, color: Colors.white),
              title: Text(
                'Sobre:',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Saiba mais',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                // Ação quando clicar
              },
            ),
            Divider(color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
