# Formativa Ponto Trabalho

Um aplicativo Flutter para controle de ponto de trabalho com autenticação, geolocalização e integração com Firebase.

## Funcionalidades

- **Autenticação**: Login e cadastro de usuários via Firebase Auth
- **Controle de Ponto**: Registro de entrada/saída baseado em localização
- **Mapa Interativo**: Visualização da localização atual e ponto de trabalho
- **Geolocalização**: Verificação de proximidade (100m) para permitir registro de ponto

## Instalação e Uso

### Pré-requisitos

- Flutter SDK (versão 3.9.0 ou superior)
- Android Studio ou VS Code com extensões Flutter
- Conta Google para Firebase

### Passos para Instalação

1. **Clone o repositório**

2. **Instale as dependências**:
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase**:
   - Acesse [Firebase Console](https://console.firebase.google.com/)
   - Crie um novo projeto
   - Ative Authentication (Email/Password)
   - Ative Firestore Database
   - Baixe o arquivo `google-services.json` e coloque em `android/app/`

4. **Execute o aplicativo**:
   ```bash
   flutter run
   ```

### APIs Utilizadas

- **Firebase**: Plugins do firebase
- **Flutter Map**: Exibição de mapas interativos

### Estrutura do Projeto

```
lib/
├── core/                 # Configurações e utilitários
├── features/
│   ├── auth/            # Autenticação (login/cadastro)
│   └── geolocalization/ # Controle de ponto e mapas
├── di/                  # Injeção de dependências (Riverpod)
└── main.dart            # Ponto de entrada da aplicação
```