import 'package:evo_flix/data/models/pessoa.dart';
import 'package:evo_flix/data/models/pessoa_equipe.dart';
import 'genero.dart';

class Filme {
  final int id;
  final String titulo;
  final String tituloOriginal;
  final String sinopse;
  final String imagemPoster;
  final String imagemFundo;
  final String dataLancamento;
  final int? anoLancamento;
  final double nota;
  final int duracao;
  final String idiomaOriginal;
  final double receita;
  final double orcamento;
  final String situacao;
  final List<Genero> generos;
  final List<String> palavrasChave;
  final List<Pessoa> elenco;
  final List<PessoaEquipe> equipe;
  String? classificaoIndicativa;

  Filme({
    required this.id,
    required this.titulo,
    required this.tituloOriginal,
    required this.sinopse,
    required this.imagemPoster,
    required this.imagemFundo,
    required this.dataLancamento,
    required this.anoLancamento,
    required this.nota,
    required this.idiomaOriginal,
    required this.receita,
    required this.orcamento,
    required this.situacao,
    required this.duracao,
    required this.generos,
    required this.palavrasChave,
    required this.elenco,
    required this.equipe,
    required this.classificaoIndicativa,
  });

  String get imagemPosterUrl => "https://image.tmdb.org/t/p/w500$imagemPoster";

  String get imagemFundoUrl => "https://image.tmdb.org/t/p/w500$imagemFundo";

  List<String> get generosNomes {
    return generos.map((genero) => genero.nome).toList();
  }

  factory Filme.fromJson(Map<String, dynamic> json) {
    String? dataLancamento = json["release_date"];
    int? ano;
    final List<PessoaEquipe> equipe = [];
    String sinopse = (json["overview"] ?? "").toString().trim();

    if (dataLancamento != null && dataLancamento.isNotEmpty) {
      ano = int.tryParse(dataLancamento.substring(0, 4));
    }

    if (json["credits"]?["crew"] != null) {
      for (var member in json["credits"]["crew"]) {
        final job = member["job"];
        if (["Director", "Writer", "Screenplay", "Story"].contains(job)) {
          equipe.add(PessoaEquipe(cargo: job, nome: member["name"]));
        }
      }
    }

    if (sinopse.isEmpty) {
      sinopse = "A sinopse deste filme não está disponível.";
    }

    return Filme(
      id: json['id'],
      titulo: json["title"] ?? '',
      tituloOriginal: json["original_title"] ?? '',
      sinopse: sinopse,
      imagemPoster: json["poster_path"] ?? '',
      imagemFundo: json["backdrop_path"] ?? '',
      dataLancamento: json["release_date"] ?? '',
      anoLancamento: ano,
      nota: (json["vote_average"] ?? 0).toDouble(),
      idiomaOriginal: json["original_language"] ?? '',
      receita: (json["revenue"] ?? 0).toDouble(),
      orcamento: (json["budget"] ?? 0).toDouble(),
      situacao: json["status"] ?? '',
      duracao: json["runtime"] ?? 0,
      generos:
          (json["genres"] as List<dynamic>?)
              ?.map((x) => Genero.fromJson(x))
              .toList() ??
          [],
      palavrasChave:
          (json["keywords"]?["keywords"] as List<dynamic>?)
              ?.map((x) => x["name"] as String)
              .toList() ??
          [],
      elenco:
          (json["credits"]?["cast"] as List<dynamic>?)
              ?.map((x) => Pessoa.fromJson(x))
              .toList() ??
          [],
      equipe: equipe,
      classificaoIndicativa: null,
    );
  }
}
