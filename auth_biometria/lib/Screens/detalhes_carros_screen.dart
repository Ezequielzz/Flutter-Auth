import 'dart:convert'; // Para trabalhar com JSON
import 'package:flutter/material.dart'; // Importa o pacote Flutter para widgets
import 'package:flutter_map/flutter_map.dart'; // Importa o pacote Flutter Map para exibir mapas
import 'package:latlong2/latlong.dart'; // Importa o pacote latlong para trabalhar com coordenadas
import 'package:flutter/services.dart'
    as rootBundle; // Para carregar arquivos JSON do bundle

class DetalhesCarroForteScreen extends StatelessWidget {
  // Classe da tela de detalhes do carro-forte
  final String carroForteId; // ID do carro-forte

  // Construtor para receber o ID do carro-forte selecionado
  DetalhesCarroForteScreen({required this.carroForteId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E36), // Cor de fundo azul escuro
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E36), // Mesma cor do fundo da tela
        title: Image.asset(
          'assets/images/biosecurity.png', // Imagem a ser exibida na AppBar
          height: 131, // Altura da imagem
          fit:
              BoxFit.contain, // Ajusta a imagem para caber no espaço disponível
        ),
        centerTitle: true, // Centraliza o título da AppBar
      ),
      body: FutureBuilder(
        future: carregarCarroFortePorId(carroForteId),
        // Chama o método para carregar os dados do carro-forte
        builder: (context, snapshot) {
          // Construtor para a interface com base no estado do Future
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Exibe um indicador de carregamento enquanto aguarda
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Erro ao carregar os dados')); // Exibe mensagem de erro se houver um erro
          } else if (snapshot.hasData && snapshot.data != null) {
            var carroForte = snapshot.data!; // Obtém os dados do carro-forte
            return Column(
              children: [
                // Mapa com cantos arredondados
                Container(
                  margin: EdgeInsets.all(16.0),
                  // Margem ao redor do container do mapa
                  clipBehavior: Clip.antiAlias,
                  // Faz com que os cantos sejam arredondados
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        15), // Define o raio dos cantos arredondados
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9, // Proporção para o mapa
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                            carroForte['coordenadas']['latitude'],
                            carroForte['coordenadas']['longitude']),
                        // Define a posição inicial do mapa
                        initialZoom: 15.0, // Define o nível de zoom inicial
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          // URL do template dos tiles do mapa
                          subdomains: [
                            'a',
                            'b',
                            'c'
                          ], // Subdomínios para carregamento dos tiles
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                  carroForte['coordenadas']['latitude'],
                                  carroForte['coordenadas']['longitude']),
                              // Posição do marcador no mapa
                              child: Icon(
                                Icons.local_shipping, // Ícone do carro-forte
                                color: Color.fromARGB(255, 255, 0, 0),
                                // Cor do ícone (vermelho)
                                size: 40, // Tamanho do ícone
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
                  // Espaçamento horizontal
                  child: Card(
                    color: const Color(0xFF0B1E36), // Cor de fundo do card
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      // Espaçamento interno do card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // Alinha os itens à esquerda
                        children: [
                          Text(
                            'Carro Forte: ${carroForte['id']}',
                            // Exibe o ID do carro-forte
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 27), // Estilo do texto
                          ),
                          const SizedBox(height: 8), // Espaçamento vertical
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: Colors.white, size: 25),
                              // Ícone de localização
                              const SizedBox(width: 8),
                              // Espaçamento horizontal
                              Text('Rota: ${carroForte['rota']}',
                                  // Exibe a rota do carro-forte
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 22)),
                              // Estilo do texto
                            ],
                          ),
                          const SizedBox(height: 8), // Espaçamento vertical
                          Row(
                            children: [
                              Icon(Icons.place, color: Colors.white, size: 25),
                              // Ícone de destino
                              const SizedBox(width: 8),
                              // Espaçamento horizontal
                              Text('Destino: ${carroForte['destino']}',
                                  // Exibe o destino do carro-forte
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 22)),
                              // Estilo do texto
                            ],
                          ),
                          const SizedBox(height: 8), // Espaçamento vertical
                          Row(
                            children: [
                              Icon(Icons.local_shipping,
                                  color: Colors.white, size: 25),
                              // Ícone de status
                              const SizedBox(width: 8),
                              // Espaçamento horizontal
                              Text('Status: ${carroForte['status']}',
                                  // Exibe o status do carro-forte
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 22)),
                              // Estilo do texto
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
            return Center(
                child: Text(
                    'Nenhum dado disponível')); // Mensagem se não houver dados
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> carregarCarroFortePorId(String id) async {
    final jsonData = await rootBundle.rootBundle
        .loadString('assets/data/carrosFortes.json'); // Carrega o JSON
    final Map<String, dynamic> dados =
        json.decode(jsonData); // Decodifica o JSON em um Map

    // Filtra para encontrar o carro-forte específico pelo ID
    var carroForte = dados['carrosFortes'].firstWhere(
        (carro) => carro['id'] == id,
        orElse: () => null); // Busca o carro-forte pelo ID

    if (carroForte != null) {
      return carroForte; // Retorna os dados do carro-forte se encontrado
    } else {
      throw Exception(
          'Carro forte não encontrado'); // Lança uma exceção se não encontrado
    }
  }
}
