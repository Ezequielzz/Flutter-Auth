import 'dart:convert'; // Para trabalhar com JSON
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart' as rootBundle; // Para carregar JSON do bundle

class DetalhesCarroForteScreen extends StatelessWidget {
  final String carroForteId;

  // Construtor para receber o ID do carro-forte selecionado
  DetalhesCarroForteScreen({required this.carroForteId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E36), // Fundo azul escuro
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E36),
        title: Image.asset(
          'assets/images/biosecurity.png',
          height: 131,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: carregarCarroFortePorId(carroForteId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os dados'));
          } else if (snapshot.hasData && snapshot.data != null) {
            var carroForte = snapshot.data!;
            return Column(
              children: [
                // Mapa com cantos arredondados
                Container(
                  margin: EdgeInsets.all(16.0),
                  clipBehavior: Clip.antiAlias, // Isso faz os cantos serem arredondados
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9, // Proporção para o mapa
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(carroForte['coordenadas']['latitude'],
                            carroForte['coordenadas']['longitude']),
                        initialZoom: 15.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                  carroForte['coordenadas']['latitude'],
                                  carroForte['coordenadas']['longitude']),
                              child: Icon(
                                Icons.local_shipping,
                                color:  Color.fromARGB(255, 255, 0, 0),
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Informações do carro-forte
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    color: const Color(0xFF0B1E36),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Carro Forte: ${carroForte['id']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 27),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.white, size: 25),
                              const SizedBox(width: 8),
                              Text('Rota: ${carroForte['rota']}',
                                  style: const TextStyle(color: Colors.white, fontSize: 22)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.place, color: Colors.white, size: 25),
                              const SizedBox(width: 8),
                              Text('Destino: ${carroForte['destino']}',
                                  style: const TextStyle(color: Colors.white, fontSize: 22)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.local_shipping, color: Colors.white, size: 25),
                              const SizedBox(width: 8),
                              Text('Status: ${carroForte['status']}',
                                  style: const TextStyle(color: Colors.white, fontSize: 22)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('Nenhum dado disponível'));
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> carregarCarroFortePorId(String id) async {
    final jsonData = await rootBundle.rootBundle.loadString('assets/data/carrosFortes.json');
    final Map<String, dynamic> dados = json.decode(jsonData);

    // Filtra para encontrar o carro-forte específico pelo ID
    var carroForte = dados['carrosFortes']
        .firstWhere((carro) => carro['id'] == id, orElse: () => null);

    if (carroForte != null) {
      return carroForte;
    } else {
      throw Exception('Carro forte não encontrado');
    }
  }
}
