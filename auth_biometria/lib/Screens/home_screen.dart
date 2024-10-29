import 'dart:convert'; // Para trabalhar com JSON

import 'package:auth_biometria/Model/carro_forte.dart'; // Importa o modelo CarroForte
import 'package:auth_biometria/Screens/config_screen.dart'; // Importa a tela de configurações
import 'package:auth_biometria/Screens/detalhes_carros_screen.dart'; // Importa a tela de detalhes dos carros-fortes
import 'package:auth_biometria/Screens/mapa_screen.dart'; // Importa a tela do mapa
import 'package:firebase_auth/firebase_auth.dart'; // Importa o pacote Firebase Auth
import 'package:flutter/material.dart'; // Importa o pacote Flutter para widgets
import 'package:flutter/services.dart'; // Importa o pacote para serviços do Flutter

class HomeScreen extends StatefulWidget {
  // Classe da tela inicial
  final User user; // Usuário autenticado
  const HomeScreen({super.key, required this.user}); // Construtor da HomeScreen

  @override
  _HomeScreenState createState() =>
      _HomeScreenState(); // Cria o estado da tela inicial
}

class _HomeScreenState extends State<HomeScreen> {
  // Estado da HomeScreen
  int _selectedIndex = 0; // Índice do item selecionado na barra de navegação

  // Método para buscar os carros-fortes
  Future<List<CarroForte>> fetchCarrosFortes() async {
    final jsonData = await rootBundle
        .loadString('assets/data/carrosFortes.json'); // Carrega o arquivo JSON
    final List<dynamic> data = json.decode(jsonData)[
        'carrosFortes']; // Decodifica o JSON e extrai a lista de carros-fortes
    return data
        .map((carro) => CarroForte.fromJson(carro))
        .toList(); // Converte os dados para objetos CarroForte
  }

  // Modifica _pages para que HomeContent receba fetchCarrosFortes como um Future
  List<Widget> _pages() => <Widget>[
        HomeContent(carrosFortes: fetchCarrosFortes()),
        // Passa o Future de carros-fortes para HomeContent
        MapaScreen(),
        // Tela do mapa
        ConfigScreen(),
        // Tela de configurações
      ];

  void _onItemTapped(int index) {
    // Método para atualizar o índice selecionado
    setState(() {
      _selectedIndex = index; // Atualiza o índice selecionado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E36),
      // Cor de fundo da tela
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E36), // Cor da AppBar
        title: Image.asset(
          'assets/images/biosecurity.png', // Imagem a ser exibida na AppBar
          height: 131, // Altura da imagem
          fit:
              BoxFit.contain, // Ajusta a imagem para caber no espaço disponível
        ),
        centerTitle: true, // Centraliza o título da AppBar
      ),
      body: _pages()[_selectedIndex],
      // Corpo da tela que muda conforme o índice selecionado
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Ícone da tela inicial
            label: 'Início', // Rótulo da tela inicial
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on), // Ícone do mapa
            label: 'Mapa', // Rótulo do mapa
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // Ícone das configurações
            label: 'Configurações', // Rótulo das configurações
          ),
        ],
        currentIndex: _selectedIndex,
        // Índice do item atualmente selecionado
        unselectedItemColor: Color.fromARGB(100, 107, 188, 255),
        // Cor dos itens não selecionados
        selectedItemColor: Color.fromARGB(1480, 107, 188, 255),
        // Cor do item selecionado
        backgroundColor: const Color(0xFF0E2543),
        // Cor de fundo da barra de navegação
        onTap: _onItemTapped, // Método chamado ao selecionar um item
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  // Classe do conteúdo da tela inicial
  final Future<List<CarroForte>>
      carrosFortes; // Future que contém a lista de carros-fortes

  HomeContent({required this.carrosFortes}); // Construtor da HomeContent

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CarroForte>>(
      // Constrói a interface com base no Future de carros-fortes
      future: carrosFortes, // Future a ser resolvido
      builder: (context, snapshot) {
        // Construtor para os estados do Future
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
                  CircularProgressIndicator()); // Exibe um indicador de carregamento
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar dados')); // Mensagem de erro
        } else if (snapshot.hasData) {
          return ListView.builder(
            // Constrói uma lista de carros-fortes
            itemCount: snapshot.data!.length, // Número de itens na lista
            itemBuilder: (context, index) {
              // Construtor para cada item da lista
              final carro = snapshot.data![index]; // Obtém o carro-forte atual
              return Card(
                elevation: 4, // Sombra da card
                color: Color.fromARGB(148, 107, 188, 255), // Cor do card
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Cantos arredondados do card
                ),
                child: ListTile(
                  // Item da lista com informações do carro-forte
                  contentPadding: const EdgeInsets.all(16.0),
                  // Padding interno do ListTile
                  title: Text(
                    'Carro Forte: ${carro.id}', // Exibe o ID do carro-forte
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white), // Estilo do texto
                  ),
                  subtitle: Column(
                    // Subtítulo com mais informações
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Alinha os itens à esquerda
                    children: [
                      Text('Rota: ${carro.rota}',
                          style: TextStyle(color: Colors.white)),
                      // Exibe a rota do carro-forte
                      Text('Destino: ${carro.destino}',
                          style: TextStyle(color: Colors.white)),
                      // Exibe o destino do carro-forte
                      Text('Status: ${carro.status}',
                          style: TextStyle(color: Colors.white)),
                      // Exibe o status do carro-forte
                    ],
                  ),
                  trailing: Icon(
                    // Ícone à direita do ListTile
                    carro.status ==
                            'Em trânsito' // Condição para determinar qual ícone exibir
                        ? Icons.local_shipping
                        : carro.status == 'Aguardando saída'
                            ? Icons.access_time
                            : Icons.check_circle,
                    color: carro.status ==
                            'Em trânsito' // Cor do ícone com base no status
                        ? Colors.amber
                        : carro.status == 'Aguardando saída'
                            ? Colors.blue
                            : const Color.fromARGB(255, 14, 235, 29),
                    size: 30, // Tamanho do ícone
                  ),
                  onTap: () {
                    // Ação ao tocar no ListTile
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesCarroForteScreen(
                            carroForteId: carro
                                .id), // Navega para a tela de detalhes do carro-forte
                      ),
                    );
                  },
                ),
              );
            },
          );
        } else {
          return Center(
              child: Text(
                  'Nenhum dado encontrado')); // Mensagem caso não haja dados
        }
      },
    );
  }
}
