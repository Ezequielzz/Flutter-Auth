### 1. Tela de Autenticação (AuthScreen)

**Descrição**:
A tela de autenticação permite que o usuário faça login com o email e senha, combinado com autenticação biométrica e verificação de localização. Ela é composta por:
- Campos de entrada para email e senha.
- Um botão circular com ícone de digital para iniciar a autenticação biométrica.

**Funcionamento**:
- **Preenchimento dos campos**: O usuário deve inserir o email e a senha.
- **Autenticação biométrica**: Ao clicar no ícone de digital, o sistema verifica a localização do usuário para garantir que ele está na área restrita. Se estiver, inicia a autenticação biométrica.
    - **Sucesso na autenticação**: Se o usuário estiver na área permitida e a biometria for validada, o login é realizado e o usuário é redirecionado para a HomeScreen.
    - **Falha na autenticação**: Caso a biometria ou a localização falhe, uma mensagem de erro é exibida.

---

### 2. Tela Inicial (HomeScreen)

**Descrição**:
Após a autenticação bem-sucedida, o usuário é direcionado à tela inicial, onde pode visualizar informações principais do aplicativo e acessar funcionalidades através do menu inferior.

**Componentes**:
- **Barra superior**: Exibe a logo do aplicativo centralizada.
- **Lista de Carros-Fortes**: Exibe uma lista dos carros-fortes carregados do arquivo JSON, com detalhes de cada um, como ID, rota, destino e status (Em trânsito, Aguardando saída, etc.).
    - Cada item da lista mostra informações detalhadas sobre o carro-forte e um ícone correspondente ao status.
    - Ao clicar em um item, o usuário é redirecionado para a tela de detalhes do carro-forte específico.
- **Menu de navegação inferior**: Oferece três opções:
    - **Início**: Página inicial com a lista de carros-fortes.
    - **Mapa**: Acessa a tela de visualização de todos os carros-fortes no mapa.
    - **Configurações**: Acessa a tela de configurações.

---

### 3. Tela de Mapa (MapaScreen)

**Descrição**:
A tela de mapa permite que o usuário visualize a localização de todos os carros-fortes no mapa, facilitando o monitoramento da posição e do status em tempo real.

**Componentes**:
- **Mapa**: Mostra um mapa com marcadores representando a localização de cada carro-forte. A cor do marcador indica o status:
    - **Amarelo** para carros-fortes "Em trânsito".
    - **Azul** para carros-fortes "Aguardando saída".
    - **Verde** para carros-fortes com status concluído.

**Funcionalidade**:
- **Marcadores Interativos**: Cada carro-forte tem um marcador indicando sua posição. O mapa é centrado no primeiro carro-forte da lista, mas permite rolar para explorar outros marcadores.

---

### 4. Tela de Configurações (ConfigScreen)

- **Descrição**: A tela de configurações permite que o usuário acesse informações sobre a conta, visualize logs de usuário e acesso, além de acessar informações adicionais sobre o aplicativo.
- **Componentes**:
    - **Botão de Sair**: Ícone de saída para desconectar o usuário.
    - **Itens de Lista**:
        - **Conta**: Exibe informações da conta do usuário.
        - **Log de Usuário**: Mostra informações de atividade do usuário.
        - **Log de Acesso**: Exibe o histórico de acessos realizados.
        - **Sobre**: Informações adicionais sobre o aplicativo.
- **Funcionalidade**:
    - **Sair da Conta**: Permite ao usuário sair da conta usando o botão de sair no topo da tela.
    - **Navegação**: Cada item da lista permite a navegação para mais detalhes relacionados ao item selecionado.

---

### 5. Tela de Detalhes do Carro-Forte (DetalhesCarroForteScreen)

- **Descrição**: Exibe informações detalhadas de um carro-forte selecionado, incluindo localização no mapa, rota, destino e status.
- **Componentes**:
    - **Mapa**: Mapa com marcador da localização do carro-forte, com cantos arredondados.
    - **Informações do Carro-Forte**:
        - **ID**: Identificador do carro-forte.
        - **Rota**: Exibe a rota do carro-forte.
        - **Destino**: Mostra o destino atual do carro-forte.
        - **Status**: Exibe o status operacional do carro-forte.
- **Funcionalidade**:
    - **Carregar Informações**: Carrega as informações do carro-forte selecionado de um arquivo JSON.
    - **Visualização de Mapa**: Exibe o local do carro-forte no mapa, centralizando na posição carregada.