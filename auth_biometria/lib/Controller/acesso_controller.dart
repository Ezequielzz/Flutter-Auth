import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auth_biometria/Model/acesso.dart';

class AcessoLogController {
  List<AcessoLog> _logs = [];

  List<AcessoLog> get logs => _logs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Adiciona um novo log de acesso ao Firestore
  Future<void> addLog(AcessoLog acessoLog) async {
    await _firestore.collection('acesso_log').add(acessoLog.toMap());
  }

  // Deleta um log do Firestore pelo ID
  Future<void> deleteLog(String id) async {
    await _firestore.collection('acesso_log').doc(id).delete();
  }

  // Busca todos os logs de acesso para um determinado usuário
  Future<void> getLogsByUserId(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('acesso_log')
        .where('userId', isEqualTo: userId)
        .get();

    _logs = querySnapshot.docs.map((doc) {
      return AcessoLog.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
