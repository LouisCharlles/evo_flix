# 🎬 EvoFlix

EvoFlix é um aplicativo desenvolvido com **Dart** e **Flutter** que permite pesquisar e explorar filmes utilizando a **API do The Movie Database (TMDB)**. Com uma interface moderna e intuitiva, EvoFlix oferece busca de filmes, visualização de detalhes completos e uma navegação por gêneros com os títulos mais populares.

## 📸 Funcionalidades

- 🔍 **Busca de filmes por nome**
- 📅 **Ordenação por ano de lançamento e nome**
- 🎞️ **Visualização completa da ficha do filme** (sinopse, imagem, data de lançamento etc.)
- 📂 **Exploração por gêneros** com as melhores e mais populares opções

## ⚙️ Como utilizar

### 1. 📡 Configure a API do TMDB

1. Crie uma conta no [The Movie Database (TMDB)](https://www.themoviedb.org/)
2. Acesse **Configurações** no seu perfil
3. Vá até a aba **API**
4. Clique em **“Gerar nova chave da API”**
5. Preencha os dados da conta de desenvolvedor e sobre sua aplicação
6. Copie a chave da API gerada

---

### 2. 💻 Configure o projeto Flutter

1. Clone o repositório:
   ```bash
   git clone https://github.com/LouisCharlles/evo_flix.git
   cd evo_flix
   ```
2. Instale as dependências:
   ```bash
   flutter pub get
    ```
3. Crie um arquivo chamado .env na raíz do projeto e adicione:
   ```bash
    API_KEY=SUA_CHAVE_API
    BASE_URL=https://api.themoviedb.org/3
    ```

### 3. ▶️ Execute a aplicação

#### 1. Você pode iniciar a aplicação de duas maneiras:
- Pelo terminal:
    ```
    flutter run
    ```
- Pelo VSCode ou Android Studio
  - Abra o arquivo main.dart
  - Pressione F5 ou botão de play para iniciar a execução

