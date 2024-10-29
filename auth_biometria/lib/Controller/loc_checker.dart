import 'package:geolocator/geolocator.dart';

class LocationChecker {
  // Defina as coordenadas da área restrita
  final double restrictedAreaLatitude = -22.5704; // Latitude da área restrita
  final double restrictedAreaLongitude = -47.4041; // Longitude da área restrita
  final double allowedRadiusInMeters = 120; // Defina o raio da área permitida em metros

  // Método para verificar se o usuário está dentro da área restrita
  Future<bool> isWithinRestrictedArea() async {
    try {
      // Verificar permissões de localização
      LocationPermission permission = await Geolocator.checkPermission(); // Checa as permissões de localização
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        // Se a permissão foi negada, solicita permissão
        permission = await Geolocator.requestPermission();
      }

      // Se a permissão for concedida, obter a localização atual
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        // Obtém a posição atual do usuário com alta precisão
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        // Calcular a distância entre a localização do usuário e a área restrita
        double distanceInMeters = Geolocator.distanceBetween(
          position.latitude, // Latitude atual do usuário
          position.longitude, // Longitude atual do usuário
          restrictedAreaLatitude, // Latitude da área restrita
          restrictedAreaLongitude, // Longitude da área restrita
        );

        // Retornar se o usuário está dentro da área permitida
        return distanceInMeters <= allowedRadiusInMeters; // Compara a distância com o raio permitido
      }
      return false; // Retorna falso se a permissão não for concedida
    } catch (e) {
      // Captura e imprime erros ao verificar a localização
      print('Erro ao verificar localização: $e');
      return false; // Retorna falso em caso de erro
    }
  }
}
