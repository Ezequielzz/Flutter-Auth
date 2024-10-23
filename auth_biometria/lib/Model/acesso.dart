class AcessoLog {
  // Atributos
  final String id;
  final bool acessoLiberado;
  final DateTime timestamp;
  final double latitude;
  final double longitude;

  AcessoLog({
    required this.id,
    required this.acessoLiberado,
    required this.timestamp,
    required this.latitude,
    required this.longitude
  });

  // Converte o AccessLog para um mapa que pode ser armazenado no Firestore
  Map<String, dynamic> toMap() {
    return {
      'acessoLiberado': acessoLiberado,
      'timestamp': timestamp.toIso8601String(),
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
    };
  }

  // Construtor para criar um AccessLog a partir de um documento do Firestore
  factory AcessoLog.fromMap(Map<String, dynamic> map, String doc) {
    return AcessoLog(
        id: doc,
        acessoLiberado: map['acessoLiberado'],
        timestamp: DateTime.parse(map['timestamp']),
        latitude: map['location']['latitude'],
        longitude: map['location']['longitude']
    );
  }

}