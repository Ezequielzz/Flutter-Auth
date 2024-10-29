import 'package:flutter/material.dart'; // Importa a biblioteca Flutter para a interface do usuário
import 'package:firebase_auth/firebase_auth.dart'; // Importa a biblioteca do Firebase Auth para autenticação

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() =>
      _AuthScreenState(); // Cria o estado para o widget AuthScreen
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth
      .instance; // Instância do FirebaseAuth para gerenciar autenticações
  final TextEditingController _emailController =
      TextEditingController(); // Controlador para o campo de email
  final TextEditingController _passwordController =
      TextEditingController(); // Controlador para o campo de senha

  String? _errorMessage; // Variável para armazenar mensagens de erro

  // Função para realizar o cadastro
  Future<void> _register() async {
    try {
      // Tenta criar um usuário com email e senha
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text, // Obtém o texto do controlador de email
        password:
            _passwordController.text, // Obtém o texto do controlador de senha
      );
      setState(() {
        _errorMessage = null; // Reseta a mensagem de erro em caso de sucesso
      });
      // Exibe um snackbar informando que o registro foi realizado com sucesso
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário registrado com sucesso')));
    } catch (e) {
      setState(() {
        _errorMessage =
            e.toString(); // Armazena a mensagem de erro em caso de falha
      });
    }
  }

  // Função para realizar o login
  Future<void> _login() async {
    try {
      // Tenta autenticar o usuário com email e senha
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text, // Obtém o texto do controlador de email
        password:
            _passwordController.text, // Obtém o texto do controlador de senha
      );
      setState(() {
        _errorMessage = null; // Reseta a mensagem de erro em caso de sucesso
      });
      // Exibe um snackbar informando que o login foi realizado com sucesso
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login realizado com sucesso')));
    } catch (e) {
      setState(() {
        _errorMessage =
            e.toString(); // Armazena a mensagem de erro em caso de falha
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login e Cadastro Firebase'), // Título da AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adiciona padding ao corpo
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController, // Controlador para o campo de email
              decoration: InputDecoration(labelText: 'Email'), // Label do campo
            ),
            TextField(
              controller: _passwordController,
              // Controlador para o campo de senha
              decoration: InputDecoration(labelText: 'Senha'),
              // Label do campo
              obscureText: true, // Oculta o texto para segurança
            ),
            SizedBox(height: 20), // Espaço entre os widgets
            if (_errorMessage != null) ...[
              // Verifica se há uma mensagem de erro
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
              // Exibe a mensagem de erro em vermelho
              SizedBox(height: 10),
              // Espaço entre a mensagem de erro e o próximo widget
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // Distribui os botões uniformemente
              children: [
                ElevatedButton(
                  onPressed: _register, // Chama a função de registro
                  child: Text('Registrar'), // Texto do botão
                ),
                ElevatedButton(
                  onPressed: _login, // Chama a função de login
                  child: Text('Login'), // Texto do botão
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
