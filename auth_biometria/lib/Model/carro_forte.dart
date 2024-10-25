import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CarroForte {
  final String id;
  final String rota;
  final String destino;
  final String status;
  final double latitude;
  final double longitude;

  CarroForte({
    required this.id,
    required this.rota,
    required this.destino,
    required this.status,
    required this.latitude,
    required this.longitude,
  });

  factory CarroForte.fromJson(Map<String, dynamic> json) {
    return CarroForte(
      id: json['id'],
      rota: json['rota'],
      destino: json['destino'],
      status: json['status'],
      latitude: json['coordenadas']['latitude'],
      longitude: json['coordenadas']['longitude'],
    );
  }



}
