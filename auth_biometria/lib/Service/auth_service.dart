import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Método para login com email e senha
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Erro no login: $e');
    }
  }

  // Método para autenticação biométrica
  Future<bool> authenticateWithBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();

      if (canAuthenticateWithBiometrics) {
        return await _localAuth.authenticate(
          localizedReason: 'Autentique-se para fazer login',
          options: const AuthenticationOptions(biometricOnly: true),
        );
      } else {
        throw Exception('Biometria não disponível no dispositivo.');
      }
    } catch (e) {
      throw Exception('Autenticação biométrica falhou: $e');
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}

