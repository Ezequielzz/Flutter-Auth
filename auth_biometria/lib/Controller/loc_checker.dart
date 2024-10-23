import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationChecker {
  // Defina as coordenadas da área restrita
  final double restrictedAreaLatitude = -22.5704;
  final double restrictedAreaLongitude = -47.4041;
  final double allowedRadiusInMeters = 120; // Defina o raio da área permitida

  Future<bool> isWithinRestrictedArea() async {
    try {
      // Verificar permissões de localização
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      // Se a permissão for concedida, obter a localização atual
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        // Calcular a distância entre a localização do usuário e a área restrita
        double distanceInMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          restrictedAreaLatitude,
          restrictedAreaLongitude,
        );

        // Retornar se o usuário está dentro da área permitida
        return distanceInMeters <= allowedRadiusInMeters;
      }
      return false; // Se a permissão não for concedida
    } catch (e) {
      print('Erro ao verificar localização: $e');
      return false;
    }
  }
}
