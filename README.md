# Documentação do Projeto: Biosecurity App

## Visão Geral do Projeto

O **Biosecurity App** é um aplicativo móvel de controle de acesso para áreas restritas, que utiliza
autenticação biométrica, geolocalização e um sistema de logs baseado no Firebase. O app permite que
operadores de segurança monitorem a localização e o status de veículos blindados (carros-fortes) em
rotas designadas, verifiquem logs de acesso e gerenciem configurações de conta, garantindo um alto
nível de segurança nas operações.

---

## 1. Funcionalidades e Decisões de Design

### 1.1 Autenticação e Controle de Acesso

1. **AuthFirebase e AuthService**: Camadas de autenticação, com suporte para login com email e
   senha, além de autenticação biométrica.
    - **Decisões de Design**: `AuthFirebase` implementa autenticação via Firebase; `AuthService`
      adiciona autenticação biométrica para segurança adicional.
    - **Métodos**:
        - `login`: Realiza autenticação com email e senha.
        - `authenticateWithBiometrics`: Verifica suporte a biometria no dispositivo e solicita
          autenticação.
        - `signOut`: Realiza logout no Firebase.

2. **LocationChecker**: Classe para verificar se o dispositivo está dentro de uma área
   geograficamente restrita, definida por uma latitude, longitude e raio permitido.
    - **Decisões de Design**: Utilização da biblioteca `Geolocator` para obter e calcular distâncias
      de localização.
    - **Funcionalidade Principal**:
        - `isWithinRestrictedArea`: Verifica as permissões de localização e calcula se o dispositivo
          está dentro da área permitida.

3. **AccessLogService**: Serviço responsável pelo registro de um novo log de acesso, capturando a
   localização e o horário.
    - **Decisões de Design**: Uso do `Geolocator` para capturar a posição e de `AcessoLogController`
      para persistência dos dados.
    - **Funcionalidade Principal**:
        - `registrarAcesso`: Cria um novo log de acesso e o armazena.

### 1.2 Gerenciamento e Monitoramento de Carros-Fortes

1. **AcessoLogController**: Controlador para o gerenciamento dos registros de acesso, incluindo
   adição, deleção e recuperação de logs específicos de usuários.
    - **Decisões de Design**: Utilização do Firestore para armazenar logs, permitindo busca por
      usuário.
    - **Principais Métodos**:
        - `addLog`: Armazena um novo registro de acesso no Firestore.
        - `deleteLog`: Remove um registro de acesso pelo ID.
        - `getLogsByUserId`: Busca todos os registros para um usuário específico, usando uma
          consulta por `userId`.

2. **AcessoLog**: Modelo de dados representando um log de acesso com atributos como `id`,
   `acessoLiberado`, `timestamp`, `latitude` e `longitude`.
    - **Conversão para Map**: `toMap` transforma o log em um formato adequado para armazenamento no
      Firestore.
    - **Conversão de Documentos Firestore**: `fromMap` cria instâncias de `AcessoLog` a partir dos
      documentos recuperados do Firestore.

3. **CarroForte**: Classe representando um carro-forte com informações como `id`, `rota`, `destino`,
   `status`, `latitude` e `longitude`.
    - **Decisões de Design**: Estrutura de dados simples com suporte para a criação de instâncias a
      partir de JSON, permitindo flexibilidade para carregamento dinâmico dos dados.

---

## 2. Arquitetura do Sistema e Diagrama

A estrutura do sistema foi projetada para ser modular, com camadas distintas para autenticação,
verificação de localização e registro de logs. O diagrama abaixo representa a organização básica das
classes principais.

```plaintext
 +------------------+       +------------------+         +-------------------+
 |   AuthService    |       | LocationChecker |         |  AccessLogService |
 +------------------+       +------------------+         +-------------------+
 | - login()        |       | - isWithin...() |         | - registrarAcesso |
 | - authenticate.. |       +------------------+         | - getLogs()       |
 +------------------+                |                   +-------------------+
         |                            |
         v                            v
 +------------------+       +------------------+
 | Firebase Auth    |       |   Firestore      |
 +------------------+       +------------------+
 | - Email/Password |       | - Store Logs     |
 +------------------+       | - Retrieve Logs  |
                            +------------------+
```

---

## 3. Configuração do Ambiente de Desenvolvimento

1. **Configurar o Firebase**:
    - No Firebase Console, crie um projeto e adicione o Firebase Authentication e Firestore.
    - Baixe os arquivos de configuração (`google-services.json` e `GoogleService-Info.plist`) e
      coloque-os nas pastas correspondentes do Android e iOS.
    - Adicione as dependências do Firebase no arquivo `pubspec.yaml`.

2. **Permissões de Localização**:
    - Para o Android, adicione permissões no arquivo `AndroidManifest.xml`:
      ```xml
      <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
      <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
      ```

    - Para o iOS, adicione as chaves no arquivo `Info.plist`:
      ```xml
      <key>NSLocationWhenInUseUsageDescription</key>
      <string>Your location is required to access the restricted area.</string>
      ```

3. **Dependências Necessárias**:
    - No arquivo `pubspec.yaml`, adicione as seguintes dependências:
      ```yaml
      dependencies:
        firebase_core: ^3.6.0
        cloud_firestore: ^5.4.4
        firebase_auth: ^5.3.1
        geolocator: ^13.0.1
        local_auth: ^2.3.0
      ```

---

## 4. Design e Interface de Usuário (UI)

### 4.1 Cores e Estilo Visual

O design utiliza uma paleta de cores modernas e minimalistas, com foco em uma interface limpa para
facilitar a navegação. A cor principal é um tom de azul escuro (#1D3557), com elementos
contrastantes em branco e cinza claro.

### 4.2 Estrutura de Interface e Navegação

1. **Tela Principal (Login)**: Autenticação do usuário com biometria ou email/senha.
2. **Tela Inicial**: Exibe status e localização dos carros-fortes. Barra de navegação inferior com:
    - **Localizações**: Mapa com áreas permitidas e localização dos carros-fortes.
    - **Configurações**: Gerenciamento de conta, logs e informações do app.
3. **Tela de Localizações**: Mapa em tela cheia, com marcadores de status dos carros-fortes.
4. **Tela de Configurações**: Permite acesso às configurações de conta, logs e informações do app.
5. **Tela de Cards (Detalhes dos Carros-Fortes)**: Detalhes de rota e destino de cada carro-forte.

### 4.3 Componentes de Carregamento e Mensagens de Erro

Para lidar com dados carregados do Firestore e do serviço de localização, o `FutureBuilder` exibe
estados de carregamento e mensagens de erro amigáveis ao usuário.

### 4.4 Integração de Mapas (OpenStreetMap)

O mapa exibe os carros-fortes em tempo real, com ícones personalizados para representar sua posição
e rota. A API OpenStreetMap é utilizada para renderizar o mapa e exibir a área restrita.

#### Protótipo de Média Fidelidade
  <div align="center">
    <img src="/img/img2.png">
  </div>

#### Protótipo de Alta Fidelidade
  <div align="center">
    <img src="/img/img.png">
  </div>

---

## 5. Exemplos de Casos de Uso

### Exemplo 1: Monitoramento de Carros-Fortes

"José, operador de segurança, faz login e acessa a aba **Localizações** para verificar se os
carros-fortes estão nas áreas permitidas. Ele acessa os **Cards** para detalhes das rotas e destinos
e revisa os **Logs de Acesso** para monitorar eventos recentes."

### Exemplo 2: Registro de Acesso com Verificação de Localização

"Ao tentar acessar uma área restrita, o sistema verifica a localização de Maria. Se ela está na área
permitida, o acesso é liberado, e um log é registrado automaticamente."

---

## 6. Desafios e Soluções

1. **Integração com o Firebase**:
    - **Desafio**: Configuração inicial e autenticação segura.
    - **Solução**: Configuração cuidadosa dos arquivos `google-services.json` e
      `GoogleService-Info.plist`.

2. **Controle de Permissões de Localização**:
    - **Desafio**: Garantir que o aplicativo obtenha permissão do usuário para acessar a
      localização.
    - **Solução**: Uso das funções `checkPermission` e `requestPermission` do Geolocator.

3. **Autenticação Biométrica**:
    - **Desafio**: Compatibilidade com dispositivos que não suportam biometria.
    - **Solução**: Implementação de verificação com `isDeviceSupported` para fallback.