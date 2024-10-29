import 'package:geolocator/geolocator.dart'; // Importa a biblioteca para geolocalização
import 'package:auth_biometria/Model/acesso.dart'; // Importa o modelo de Acesso
import 'package:auth_biometria/Controller/acesso_controller.dart'; // Importa o controlador de Acesso

class AccessLogService {
  // Método para registrar o acesso
  Future<void> registrarAcesso(bool acessoLiberado) async {
    // Obtém a posição atual do dispositivo com alta precisão
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );

    DateTime now = DateTime.now(); // Obtém a data e hora atuais

    // Cria um novo log de acesso com os dados coletados
    AcessoLog log = AcessoLog(
        id: '', // Firestore irá gerar o ID automaticamente
        acessoLiberado: acessoLiberado, // Indica se o acesso foi liberado ou não
        timestamp: now, // Armazena a data e hora do acesso
        latitude: position.latitude, // Armazena a latitude da posição
        longitude: position.longitude // Armazena a longitude da posição
    );

    AcessoLogController controller = AcessoLogController(); // Cria uma instância do controlador de Acesso
    await controller.addLog(log); // Adiciona o log de acesso usando o controlador
  }
}
