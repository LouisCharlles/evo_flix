import 'package:evo_flix/presentation/pages/menu_generos_page.dart';
import 'package:flutter/material.dart';
import 'package:evo_flix/data/models/filme.dart';
import 'package:evo_flix/data/services/movie_service.dart';
import '../widgets/head_title.dart';
import '../widgets/movie_card.dart';

class MovieSearchPage extends StatefulWidget {
  const MovieSearchPage({super.key});

  @override
  State<MovieSearchPage> createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  var selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Filme> _filmesEncontrados = [];
  bool _isLoading = false;
  bool _buscou = false;

  void _handleNavigation(int index) async {
    if (index == 1) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MenuGenerosPage()),
      );
      setState(() {
        selectedIndex = 0;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  void _buscarFilmes() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _buscou = true;
    });

    final filmes = await MovieService().buscarFilmes(query);

    setState(() {
      _filmesEncontrados = filmes;
      _isLoading = false;
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onSubmitted: (_) => _buscarFilmes(),
      decoration: InputDecoration(
        hintText: 'Pesquise seus filmes favoritos',
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildResultados(context) {
    if (!_buscou) {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Center(
              child: SizedBox(
                width: constraints.maxWidth * 0.5,
                child: const Text(
                  'Pesquise seus filmes favoritos!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: SizedBox(
                width: constraints.maxWidth * 0.5,
                child: const Text(
                  'Pesquise seus filmes favoritos!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            );
          }
        },
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filmesEncontrados.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum filme encontrado!',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: _filmesEncontrados.length,
      itemBuilder: (context, index) {
        final filme = _filmesEncontrados[index];
        return MovieCard(filme: filme);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 450;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: const HeadTitle(),
          body: isMobile ? _buildMobileContent() : _buildDesktopContent(),
          bottomNavigationBar:
              isMobile
                  ? BottomNavigationBar(
                    backgroundColor: Colors.black,
                    selectedItemColor: Colors.red,
                    unselectedItemColor: Colors.white,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        label: 'Buscar',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.menu),
                        label: 'Menu',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: _handleNavigation,
                  )
                  : null,
        );
      },
    );
  }

  Widget _buildMobileContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSearchField(),
          const SizedBox(height: 20),
          Expanded(child: _buildResultados(context)),
        ],
      ),
    );
  }

  Widget _buildDesktopContent() {
    return Row(
      children: [
        NavigationRail(
          backgroundColor: Colors.black,

          labelType: NavigationRailLabelType.all,
          selectedIconTheme: const IconThemeData(color: Colors.red),
          selectedLabelTextStyle: const TextStyle(color: Colors.red),
          unselectedIconTheme: const IconThemeData(color: Colors.white),
          unselectedLabelTextStyle: const TextStyle(color: Colors.white),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.search),
              label: Text('Buscar'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.menu),
              label: Text('Menu'),
            ),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: _handleNavigation,
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSearchField(),
                const SizedBox(height: 20),
                Expanded(child: _buildResultados(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
