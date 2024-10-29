import 'package:firebase_auth/firebase_auth.dart'; // Importa a biblioteca do Firebase Auth para autenticação
import 'package:local_auth/local_auth.dart'; // Importa a biblioteca para autenticação biométrica

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instância do FirebaseAuth para gerenciar autenticações
  final LocalAuthentication _localAuth = LocalAuthentication(); // Instância do LocalAuthentication para autenticação biométrica

  // Método para login com email e senha
  Future<User?> login(String email, String password) async {
    try {
      // Tenta autenticar o usuário com email e senha
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Retorna o usuário autenticado
    } catch (e) {
      throw Exception('Erro no login: $e'); // Lança uma exceção em caso de erro
    }
  }

  // Método para autenticação biométrica
  Future<bool> authenticateWithBiometrics() async {
    try {
      // Verifica se o dispositivo pode usar biometria ou se é compatível
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();

      if (canAuthenticateWithBiometrics) {
        // Tenta autenticar usando biometria
        return await _localAuth.authenticate(
          localizedReason: 'Autentique-se para fazer login', // Mensagem que será exibida ao usuário
          options: const AuthenticationOptions(biometricOnly: true), // Opção para usar apenas biometria
        );
      } else {
        throw Exception('Biometria não disponível no dispositivo.'); // Lança uma exceção se a biometria não estiver disponível
      }
    } catch (e) {
      throw Exception('Autenticação biométrica falhou: $e'); // Lança uma exceção em caso de falha na autenticação
    }
  }

  // Método para logout
  Future<void> signOut() async {
    try {
      await _auth.signOut(); // Executa o logout do usuário

    } catch (e) {
      print(e.toString()); // Imprime o erro caso ocorra
    }
  }
}
