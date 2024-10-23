import 'package:geolocator/geolocator.dart';
import 'package:auth_biometria/Model/acesso.dart';
import 'package:auth_biometria/Controller/acesso_controller.dart';

class AccessLogService {
  // Método para registrar o acesso
  Future<void> registrarAcesso(bool acessoLiberado) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );
    DateTime now = DateTime.now();

    AcessoLog log = AcessoLog(
        id: '', // Firestore irá gerar o ID automaticamente
        acessoLiberado: acessoLiberado,
        timestamp: now,
        latitude: position.latitude,
        longitude: position.longitude
    );

    AcessoLogController controller = AcessoLogController();
    await controller.addLog(log);
  }
}
