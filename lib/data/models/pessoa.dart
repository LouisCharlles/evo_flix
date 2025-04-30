class Pessoa {
  final String nome;
  final String? imagem;
  final String personagem;

  Pessoa({
    required this.nome,
    required this.imagem,
    required this.personagem,
  });
  
  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      nome: json["name"] ?? '',
      imagem: json["profile_path"],
      personagem: json["character"] ?? '',
    );
  }
  String get imagemUrl => "https://image.tmdb.org/t/p/w500$imagem";
}
  
