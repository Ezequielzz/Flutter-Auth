import 'package:auth_biometria/Screens/auth_screen.dart'; // Importa a tela de autenticação
import 'package:flutter/material.dart'; // Importa o pacote Flutter para widgets
import 'package:auth_biometria/Services/auth_service.dart'; // Importa o serviço de autenticação

class ConfigScreen extends StatelessWidget {
  // Classe da tela de configurações
  final AuthService authService =
      AuthService(); // Instância do serviço de autenticação

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E36), // Cor de fundo azul escuro
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E36), // Mesma cor do fundo da tela
        centerTitle: true, // Centraliza o título da AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white), // Ícone de sair
            onPressed: () {
              // Ação a ser executada ao pressionar o botão de sair
              authService
                  .signOut(); // Chama o método de logout do serviço de autenticação
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AuthScreen()), // Navega de volta para a tela de autenticação
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaçamento interno do corpo
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Alinha os itens à esquerda
          children: <Widget>[
            // Item Conta
            ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              // Ícone de usuário
              title: Text(
                'Conta:', // Título do item
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold), // Estilo do texto
              ),
              subtitle: Text(
                'Exibe as informações da sua conta', // Subtítulo do item
                style: TextStyle(color: Colors.white70), // Estilo do subtítulo
              ),
              onTap: () {
                // Ação a ser executada ao clicar no item (ainda não implementada)
              },
            ),
            Divider(color: Colors.white24), // Divisória entre os itens

            // Item Log de Usuário
            ListTile(
              leading: Icon(Icons.arrow_forward, color: Colors.white),
              // Ícone de seta
              title: Text(
                'Log de usuário:', // Título do item
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold), // Estilo do texto
              ),
              subtitle: Text(
                'Exibe as informações do Log de usuário.', // Subtítulo do item
                style: TextStyle(color: Colors.white70), // Estilo do subtítulo
              ),
              onTap: () {
                // Ação a ser executada ao clicar no item (ainda não implementada)
              },
            ),
            Divider(color: Colors.white24), // Divisória entre os itens

            // Item Log de Acesso
            ListTile(
              leading: Icon(Icons.arrow_forward, color: Colors.white),
              // Ícone de seta
              title: Text(
                'Log de acesso:', // Título do item
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold), // Estilo do texto
              ),
              subtitle: Text(
                'Exibe as informações do Log de acesso.', // Subtítulo do item
                style: TextStyle(color: Colors.white70), // Estilo do subtítulo
              ),
              onTap: () {
                // Ação a ser executada ao clicar no item (ainda não implementada)
              },
            ),
            Divider(color: Colors.white24), // Divisória entre os itens

            // Item Sobre
            ListTile(
              leading: Icon(Icons.info, color: Colors.white),
              // Ícone de informação
              title: Text(
                'Sobre:', // Título do item
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold), // Estilo do texto
              ),
              subtitle: Text(
                'Saiba mais', // Subtítulo do item
                style: TextStyle(color: Colors.white70), // Estilo do subtítulo
              ),
              onTap: () {
                // Ação a ser executada ao clicar no item (ainda não implementada)
              },
            ),
            Divider(color: Colors.white24), // Divisória entre os itens
          ],
        ),
      ),
    );
  }
}
