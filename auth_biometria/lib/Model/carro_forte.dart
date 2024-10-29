class CarroForte {
  final String id; // ID do carro-forte
  final String rota; // Rota do carro-forte
  final String destino; // Destino do carro-forte
  final String status; // Status do carro-forte (ex: ativo, inativo, etc.)
  final double latitude; // Latitude da localização do carro-forte
  final double longitude; // Longitude da localização do carro-forte

  // Construtor para inicializar os atributos da classe
  CarroForte({
    required this.id,
    required this.rota,
    required this.destino,
    required this.status,
    required this.latitude,
    required this.longitude,
  });

  // Método factory para criar uma instância de CarroForte a partir de um JSON
  factory CarroForte.fromJson(Map<String, dynamic> json) {
    return CarroForte(
      id: json['id'], // Obtém o ID do JSON
      rota: json['rota'], // Obtém a rota do JSON
      destino: json['destino'], // Obtém o destino do JSON
      status: json['status'], // Obtém o status do JSON
      latitude: json['coordenadas']['latitude'], // Obtém a latitude do JSON
      longitude: json['coordenadas']['longitude'], // Obtém a longitude do JSON
    );
  }
}
