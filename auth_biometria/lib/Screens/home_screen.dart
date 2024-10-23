import 'package:auth_biometria/Service/auth_service.dart';
import 'package:flutter/material.dart';

class CarroForte {
  final String id;
  final String rota;
  final String destino;
  final String status;

  CarroForte(
      {required this.id,
      required this.rota,
      required this.destino,
      required this.status});
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Controla qual página está ativa


  final List<CarroForte> carrosFortes = [
    CarroForte(
        id: 'CF001',
        rota: 'Rota 1',
        destino: 'Banco Central',
        status: 'Em trânsito'),
    CarroForte(
        id: 'CF002',
        rota: 'Rota 2',
        destino: 'Agência Cidade Norte',
        status: 'Aguardando saída'),
    CarroForte(
        id: 'CF003',
        rota: 'Rota 3',
        destino: 'Agência Sul',
        status: 'Finalizado'),
  ];

  // Diferentes telas para navegação
  static List<Widget> _pages = <Widget>[
    HomeContent(), // Página principal com os carros fortes
    MapaScreen(), // Página Mapa (por exemplo)
    ConfigScreen() // Página de configurações
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex =
          index; // Atualiza a tela ativa com base no índice da barra
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E36),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E36),
        title: Image.asset(
          'assets/images/biosecurity.png', // Caminho para sua imagem
          height: 131, // Ajuste a altura da imagem para o tamanho desejado
          fit: BoxFit.contain, // Faz com que a imagem se ajuste dentro da área designada
        ),
        centerTitle: true, // Centraliza a imagem na AppBar
      ),
      body: _pages[_selectedIndex],
      // Exibe a tela selecionada na barra de navegação
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
        // Indica qual item está selecionado
        unselectedItemColor: Color.fromARGB(100, 107, 188, 255),
        selectedItemColor: Color.fromARGB(1480, 107, 188, 255),
        backgroundColor: const Color(0xFF0E2543),
        onTap: _onItemTapped, // Chama ao clicar em um item
      ),
    );
  }
}

// Página inicial
class HomeContent extends StatelessWidget {
  final List<CarroForte> carrosFortes = [
    CarroForte(
        id: 'CF001',
        rota: 'Rota 1',
        destino: 'Banco Central',
        status: 'Em trânsito'),
    CarroForte(
        id: 'CF002',
        rota: 'Rota 2',
        destino: 'Agência Cidade Norte',
        status: 'Aguardando saída'),
    CarroForte(
        id: 'CF003',
        rota: 'Rota 3',
        destino: 'Agência Sul',
        status: 'Finalizado'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: carrosFortes.length,
        itemBuilder: (context, index) {
          final carro = carrosFortes[index];
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
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rota: ${carro.rota}',
                      style: TextStyle(color: Colors.white)),
                  Text('Destino: ${carro.destino}',
                      style: TextStyle(color: Colors.white)),
                  Text('Status: ${carro.status}',
                      style: TextStyle(color: Colors.white)),
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
            ),
          );
        },
      ),
    );
  }
}

// Tela do Mapa (por exemplo)
class MapaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tela do Mapa',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}

class ConfigScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E36), // Fundo azul escuro
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E36), // Mesma cor do fundo
        centerTitle: true, // Centralizar o título
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              // Ação para o botão de sair
              authService.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Item Conta
            ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              title: Text(
                'Conta:',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Exibe as informações da sua conta',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                // Ação quando clicar
              },
            ),
            Divider(color: Colors.white24),

            // Item Log de Usuário
            ListTile(
              leading: Icon(Icons.arrow_forward, color: Colors.white),
              title: Text(
                'Log de usuário:',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Exibe as informações do Log de usuário.',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                // Ação quando clicar
              },
            ),
            Divider(color: Colors.white24),

            // Item Log de Acesso
            ListTile(
              leading: Icon(Icons.arrow_forward, color: Colors.white),
              title: Text(
                'Log de acesso:',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Exibe as informações do Log de acesso.',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                // Ação quando clicar
              },
            ),
            Divider(color: Colors.white24),

            // Item Sobre
            ListTile(
              leading: Icon(Icons.info, color: Colors.white),
              title: Text(
                'Sobre:',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Saiba mais',
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                // Ação quando clicar
              },
            ),
            Divider(color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
