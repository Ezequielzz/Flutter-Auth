import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auth_biometria/Model/acesso.dart';

class AcessoLogController {
  // Lista privada para armazenar os logs de acesso
  List<AcessoLog> _logs = [];

  // Getter para acessar a lista de logs
  List<AcessoLog> get logs => _logs;

  // Instância do Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Adiciona um novo log de acesso ao Firestore
  Future<void> addLog(AcessoLog acessoLog) async {
    // Adiciona o log na coleção 'acesso_log'
    await _firestore.collection('acesso_log').add(acessoLog.toMap());
  }

  // Deleta um log do Firestore pelo ID
  Future<void> deleteLog(String id) async {
    // Deleta o documento da coleção 'acesso_log' com o ID fornecido
    await _firestore.collection('acesso_log').doc(id).delete();
  }

  // Busca todos os logs de acesso para um determinado usuário
  Future<void> getLogsByUserId(String userId) async {
    // Realiza uma consulta na coleção 'acesso_log' filtrando pelo userId
    QuerySnapshot querySnapshot = await _firestore
        .collection('acesso_log')
        .where('userId', isEqualTo: userId)
        .get();

    // Mapeia os documentos retornados para a lista de logs
    _logs = querySnapshot.docs.map((doc) {
      // Converte cada documento para um objeto AcessoLog
      return AcessoLog.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
