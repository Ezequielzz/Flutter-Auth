import 'dart:convert';

import 'package:auth_biometria/Model/carro_forte.dart';
import 'package:auth_biometria/Screens/config_screen.dart';
import 'package:auth_biometria/Screens/detalhes_carros_screen.dart';
import 'package:auth_biometria/Screens/mapa_screen.dart';
import 'package:auth_biometria/Service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Adiciona o método fetchCarrosFortes no _HomeScreenState
  Future<List<CarroForte>> fetchCarrosFortes() async {
    final jsonData = await rootBundle.loadString('assets/data/carrosFortes.json');
    final List<dynamic> data = json.decode(jsonData)['carrosFortes'];
    return data.map((carro) => CarroForte.fromJson(carro)).toList();
  }

  // Modifica _pages para que HomeContent receba fetchCarrosFortes como um Future
  List<Widget> _pages() => <Widget>[
    HomeContent(carrosFortes: fetchCarrosFortes()), // Passa o Future para HomeContent
    MapaScreen(),
    ConfigScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E36),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E36),
        title: Image.asset(
          'assets/images/biosecurity.png',
          height: 131,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: _pages()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Color.fromARGB(100, 107, 188, 255),
        selectedItemColor: Color.fromARGB(1480, 107, 188, 255),
        backgroundColor: const Color(0xFF0E2543),
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final Future<List<CarroForte>> carrosFortes;

  HomeContent({required this.carrosFortes});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CarroForte>>(
      future: carrosFortes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar dados'));
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final carro = snapshot.data![index];
              return Card(
                elevation: 4,
                color: Color.fromARGB(148, 107, 188, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    'Carro Forte: ${carro.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rota: ${carro.rota}', style: TextStyle(color: Colors.white)),
                      Text('Destino: ${carro.destino}', style: TextStyle(color: Colors.white)),
                      Text('Status: ${carro.status}', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  trailing: Icon(
                    carro.status == 'Em trânsito'
                        ? Icons.local_shipping
                        : carro.status == 'Aguardando saída'
                        ? Icons.access_time
                        : Icons.check_circle,
                    color: carro.status == 'Em trânsito'
                        ? Colors.amber
                        : carro.status == 'Aguardando saída'
                        ? Colors.blue
                        : const Color.fromARGB(255, 14, 235, 29),
                    size: 30,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesCarroForteScreen(carroForteId: carro.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        } else {
          return Center(child: Text('Nenhum dado encontrado'));
        }
      },
    );
  }
}
