import 'package:auth_biometria/Services/acesso_log_service.dart'; // Importa o serviço de log de acesso
import 'package:auth_biometria/Services/auth_service.dart'; // Importa o serviço de autenticação
import 'package:flutter/material.dart'; // Importa o pacote Flutter para widgets
import 'package:auth_biometria/Screens/home_screen.dart'; // Importa a tela inicial
import 'package:auth_biometria/Controller/loc_checker.dart'; // Importa o controlador de verificação de localização
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key}); // Construtor da tela de autenticação

  @override
  State<AuthScreen> createState() =>
      _AuthScreenState(); // Cria o estado da tela de autenticação
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave do formulário para validação
  final TextEditingController _emailController =
      TextEditingController(); // Controlador para o campo de email
  final TextEditingController _passwordController =
      TextEditingController(); // Controlador para o campo de senha
  String? _errorMessage; // Mensagem de erro para validações

  final AuthService _authService =
      AuthService(); // Instância do serviço de autenticação
  final AccessLogService _accessLogService =
      AccessLogService(); // Instância do serviço de log de acesso

  // Função para autenticação biométrica e login
  Future<void> _authenticateAndLogin() async {
    LocationChecker locationChecker =
        LocationChecker(); // Cria uma instância do verificador de localização
    bool isInRestrictedArea = await locationChecker
        .isWithinRestrictedArea(); // Verifica se está na área restrita

    if (isInRestrictedArea) {
      // Se estiver na área restrita
      if (_formKey.currentState!.validate()) {
        // Valida os campos do formulário
        try {
          bool didAuthenticate = await _authService
              .authenticateWithBiometrics(); // Tenta autenticar com biometria
          if (didAuthenticate) {
            // Tenta realizar o login
            User? user = await _authService.login(
              _emailController.text, // Email do controlador
              _passwordController.text, // Senha do controlador
            );
            if (user != null) {
              // Se o usuário for encontrado
              await _accessLogService
                  .registrarAcesso(true); // Registra acesso permitido
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(user: user)), // Navega para a tela inicial
              );
            }
          } else {
            setState(() {
              _errorMessage =
                  'Autenticação biométrica falhou.'; // Mensagem de erro caso a biometria falhe
            });
            await _accessLogService
                .registrarAcesso(false); // Registra falha na biometria
          }
        } on FirebaseAuthException catch (e) {
          setState(() {
            // Mensagens de erro do Firebase
            if (e.code == 'user-not-found') {
              _errorMessage =
                  'Usuário não encontrado. Verifique seu email.'; // Mensagem caso o usuário não seja encontrado
            } else if (e.code == 'wrong-password') {
              _errorMessage =
                  'Senha incorreta. Tente novamente.'; // Mensagem caso a senha esteja errada
            } else {
              _errorMessage =
                  'Erro ao autenticar!'; // Mensagem para erro genérico
            }
          });
          await _accessLogService
              .registrarAcesso(false); // Registra falha no login
        } catch (e) {
          setState(() {
            _errorMessage = 'Erro inesperado!'; // Mensagem para erro inesperado
          });
        }
      }
    } else {
      setState(() {
        _errorMessage =
            'Você não está na área restrita.'; // Mensagem caso o usuário não esteja na área restrita
      });
      await _accessLogService
          .registrarAcesso(false); // Registra acesso negado pela localização
    }
  }

  // Validação do email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu email.'; // Mensagem caso o email esteja vazio
    }
    // Verifica se o email tem um formato válido
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Por favor, insira um email válido.'; // Mensagem caso o formato do email seja inválido
    }
    return null; // Retorna null se não houver erro
  }

  // Validação da senha
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha.'; // Mensagem caso a senha esteja vazia
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.'; // Mensagem caso a senha seja muito curta
    }
    return null; // Retorna null se não houver erro
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Obtém o tamanho da tela

    return Scaffold(
      backgroundColor: const Color(0xFF0B1E36), // Cor de fundo azul escuro
      body: SingleChildScrollView(
        // Torna a tela rolável
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          // Espaçamento horizontal
          child: Form(
            key: _formKey, // Associa a chave do formulário
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // Centraliza os elementos verticalmente
              children: <Widget>[
                // Logo no topo
                Image.asset(
                  'assets/images/biosecurity.png',
                  // Substitua pelo caminho correto da imagem no seu projeto
                  height: size.height *
                      0.2, // Altura da imagem relativa ao tamanho da tela
                ),
                const SizedBox(height: 40),
                // Espaço entre a logo e os campos

                // Campo de texto para o usuário
                TextFormField(
                  controller: _emailController,
                  // Controlador para o campo de email
                  style: const TextStyle(color: Colors.white),
                  // Texto branco
                  decoration: InputDecoration(
                    filled: true,
                    // Campo preenchido
                    fillColor: const Color(0xFF1C3A57),
                    // Fundo azul escuro
                    labelText: 'Email',
                    // Texto do label
                    labelStyle: const TextStyle(color: Colors.white),
                    // Texto do label em branco
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      // Bordas arredondadas
                      borderSide: BorderSide.none, // Remove a borda
                    ),
                  ),
                  validator: _validateEmail, // Validação do email
                ),
                const SizedBox(height: 16),
                // Espaço entre os campos

                // Campo de texto para a senha
                TextFormField(
                  controller: _passwordController,
                  // Controlador para o campo de senha
                  obscureText: true,
                  // Oculta o texto da senha
                  style: const TextStyle(color: Colors.white),
                  // Texto branco
                  decoration: InputDecoration(
                    filled: true,
                    // Campo preenchido
                    fillColor: const Color(0xFF1C3A57),
                    // Fundo azul escuro
                    labelText: 'Senha do Usuario',
                    // Texto do label
                    labelStyle: const TextStyle(color: Colors.white),
                    // Texto do label em branco
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      // Bordas arredondadas
                      borderSide: BorderSide.none, // Remove a borda
                    ),
                  ),
                  validator: _validatePassword, // Validação da senha
                ),
                const SizedBox(height: 40),
                // Espaço antes do botão de biometria

                // Botão de autenticação por biometria
                GestureDetector(
                  onTap: _authenticateAndLogin,
                  // Chama a função de autenticação ao tocar
                  child: Container(
                    height: 80, // Altura do botão
                    width: 80, // Largura do botão
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C3A57), // Fundo do botão
                      shape: BoxShape.circle, // Forma circular
                      boxShadow: [
                        // Sombra do botão
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Cor da sombra
                          spreadRadius: 5, // Raio de espalhamento
                          blurRadius: 10, // Raio de desfoque
                          offset: Offset(0, 3), // Posição da sombra
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.fingerprint, // Ícone de biometria
                      size: 50, // Tamanho do ícone
                      color: Colors.blue, // Cor do ícone de biometria
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                // Espaço antes da mensagem de erro

                // Mensagem de erro
                if (_errorMessage != null) ...[
                  // Verifica se há uma mensagem de erro
                  Text(
                    _errorMessage!, // Exibe a mensagem de erro
                    style: const TextStyle(
                        color: Colors
                            .red), // Texto da mensagem de erro em vermelho
                  ),
                  const SizedBox(height: 10),
                  // Espaço após a mensagem de erro
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
