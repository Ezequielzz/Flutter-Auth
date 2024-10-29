import 'dart:convert'; // Para trabalhar com JSON
import 'package:flutter/material.dart'; // Importa o pacote Flutter para widgets
import 'package:flutter_map/flutter_map.dart'; // Importa o pacote para exibir mapas
import 'package:latlong2/latlong.dart'; // Importa o pacote para trabalhar com coordenadas geográficas
import 'package:flutter/services.dart'
    as rootBundle; // Para carregar JSON do bundle

class MapaScreen extends StatelessWidget {
  // Classe que representa a tela do mapa
  @override
  Widget build(BuildContext context) {
    // Método que constrói a interface
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E36), // Fundo azul escuro
      body: FutureBuilder(
        // Constrói a interface com base em um Future
        future: carregarTodosCarrosFortes(),
        // Chama a função para carregar os dados
        builder: (context, snapshot) {
          // Construtor para os estados do Future
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Se ainda estiver carregando
            return Center(
                child:
                    CircularProgressIndicator()); // Exibe um indicador de carregamento
          } else if (snapshot.hasError) {
            // Se houve um erro ao carregar
            return Center(
                child: Text('Erro ao carregar os dados')); // Mensagem de erro
          } else if (snapshot.hasData && snapshot.data != null) {
            // Se os dados foram carregados com sucesso
            var carrosFortes = snapshot.data!
                as List<Map<String, dynamic>>; // Obtém a lista de carros-fortes
            return Container(
              margin: EdgeInsets.all(16.0),
              // Margem ao redor do container
              clipBehavior: Clip.antiAlias,
              // Isso faz os cantos serem arredondados
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    15), // Arredonda os cantos do container
              ),
              child: FlutterMap(
                // Exibe o mapa
                options: MapOptions(
                  // Centraliza no primeiro carro-forte (ou pode escolher coordenadas específicas)
                  initialCenter: LatLng(
                      carrosFortes[0]['coordenadas']['latitude'],
                      // Latitude do primeiro carro-forte
                      carrosFortes[0]['coordenadas']['longitude']),
                  // Longitude do primeiro carro-forte
                  initialZoom: 13.0, // Nível de zoom inicial
                ),
                children: [
                  TileLayer(
                    // Camada de tiles do mapa
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    // URL para obter os tiles do mapa
                    subdomains: [
                      'a',
                      'b',
                      'c'
                    ], // Subdomínios para a solicitação de tiles
                  ),
                  // Exibe todos os carros-fortes como marcadores no mapa
                  MarkerLayer(
                    markers: carrosFortes.map((carroForte) {
                      // Mapeia cada carro-forte para um marcador
                      return Marker(
                        point: LatLng(
                          // Define a posição do marcador
                          carroForte['coordenadas']['latitude'],
                          // Latitude do carro-forte
                          carroForte['coordenadas']
                              ['longitude'], // Longitude do carro-forte
                        ),
                        child: Icon(
                          // Ícone do marcador
                          Icons.local_shipping, // Ícone de transporte
                          color: carroForte['status'] ==
                                  'Em trânsito' // Cor do ícone com base no status
                              ? Colors
                                  .amber // Cor amarela se estiver em trânsito
                              : carroForte['status'] ==
                                      'Aguardando saída' // Cor azul se estiver aguardando saída
                                  ? Colors.blue
                                  : Colors.green,
                          // Cor verde se estiver em outro status
                          size: 40, // Tamanho do ícone
                        ),
                      );
                    }).toList(), // Converte a lista de marcadores para uma lista
                  ),
                ],
              ),
            );
          } else {
            return Center(
                child: Text(
                    'Nenhum dado disponível')); // Mensagem caso não haja dados
          }
        },
      ),
    );
  }

  // Função para carregar todos os carros-fortes do arquivo JSON
  Future<List<Map<String, dynamic>>> carregarTodosCarrosFortes() async {
    final jsonData = await rootBundle.rootBundle
        .loadString('assets/data/carrosFortes.json'); // Carrega o arquivo JSON
    final Map<String, dynamic> dados =
        json.decode(jsonData); // Decodifica o JSON em um mapa

    return List<Map<String, dynamic>>.from(
        dados['carrosFortes']); // Retorna a lista de carros-fortes
  }
}
