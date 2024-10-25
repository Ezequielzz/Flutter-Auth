import 'dart:convert'; // Para trabalhar com JSON
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart' as rootBundle; // Para carregar JSON do bundle

class MapaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E36), // Fundo azul escuro
      body: FutureBuilder(
        future: carregarTodosCarrosFortes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os dados'));
          } else if (snapshot.hasData && snapshot.data != null) {
            var carrosFortes = snapshot.data! as List<Map<String, dynamic>>;
            return Container(
              margin: EdgeInsets.all(16.0),
              clipBehavior: Clip.antiAlias, // Isso faz os cantos serem arredondados
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: FlutterMap(
                options: MapOptions(
                  // Centraliza no primeiro carro-forte (ou pode escolher coordenadas específicas)
                  initialCenter: LatLng(carrosFortes[0]['coordenadas']['latitude'],
                      carrosFortes[0]['coordenadas']['longitude']),
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  // Exibe todos os carros-fortes como marcadores no mapa
                  MarkerLayer(
                    markers: carrosFortes.map((carroForte) {
                      return Marker(
                        point: LatLng(
                          carroForte['coordenadas']['latitude'],
                          carroForte['coordenadas']['longitude'],
                        ),
                        child: Icon(
                          Icons.local_shipping,
                          color: carroForte['status'] == 'Em trânsito'
                              ? Colors.amber
                              : carroForte['status'] == 'Aguardando saída'
                              ? Colors.blue
                              : Colors.green,
                          size: 40,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Nenhum dado disponível'));
          }
        },
      ),
    );
  }

  // Função para carregar todos os carros-fortes do arquivo JSON
  Future<List<Map<String, dynamic>>> carregarTodosCarrosFortes() async {
    final jsonData = await rootBundle.rootBundle.loadString('assets/data/carrosFortes.json');
    final Map<String, dynamic> dados = json.decode(jsonData);

    return List<Map<String, dynamic>>.from(dados['carrosFortes']);
  }
}
