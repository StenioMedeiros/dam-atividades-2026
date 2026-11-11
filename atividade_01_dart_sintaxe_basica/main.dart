enum Classificacao { semAvaliacoes, baixa, regular, alta }

void main() {
  const notaMinima = 1;
  const notaMaxima = 5;
  const notaPositiva = 4;

  final notasRecebidas = <String, List<String>>{
    'Agenda UFAPE': ['5', '4', '5', '0', '3', '6'],
    'Biblioteca Digital': ['3', '2', '4', '1'],
    'Mapa do Campus': [],
    'Restaurante Universitário': ['5', '5', '4', '4', '5'],
    'Transporte Universitário': ['0', '6', '-1'],
  };

  final categoriasPorApp = <String, String>{
    'Agenda UFAPE': 'Organização',
    'Biblioteca Digital': 'Serviços',
    'Mapa do Campus': 'Localização',
    'Restaurante Universitário': 'Serviços',
    'Transporte Universitário': 'Serviços',
  };

  final contatosPorApp = <String, String?>{
    'Agenda UFAPE': 'agenda@exemplo.com',
    'Biblioteca Digital': null,
    'Mapa do Campus': 'mapa@exemplo.com',
    'Restaurante Universitário': 'ru@exemplo.com',
    // Transporte Universitário não possui chave neste mapa.
  };

  final notasValidasPorApp = <String, List<int>>{};
  final descartadasPorApp = <String, int>{};
  final categoriasUnicas = <String>{};

  // QUESTÃO 1 — PREPARAÇÃO DOS DADOS
  for (final entrada in notasRecebidas.entries) {
    final nomeApp = entrada.key;
    final notasValidas = <int>[];
    int descartadas = 0;

    for (final texto in entrada.value) {
      final nota = int.parse(texto);
      if (nota >= notaMinima && nota <= notaMaxima) {
        notasValidas.add(nota);
      } else {
        descartadas++;
      }
    }

    // Registra também os aplicativos sem notas válidas.
    notasValidasPorApp[nomeApp] = notasValidas;
    descartadasPorApp[nomeApp] = descartadas;
    final categoria = categoriasPorApp[nomeApp];
    if (categoria != null) {
      categoriasUnicas.add(categoria);
    }
  }

  // QUESTÃO 2 — RELATÓRIO
  print('RELATÓRIO DE AVALIAÇÕES');
  print('======================');

  for (final entrada in notasValidasPorApp.entries) {
    final nomeApp = entrada.key;
    final notas = entrada.value;
    final categoria = categoriasPorApp[nomeApp] ?? 'Não informada';
    final contato = contatosPorApp[nomeApp] ?? 'Não informado';
    final quantidadeValidas = notas.length;
    final quantidadeDescartadas = descartadasPorApp[nomeApp] ?? 0;
    int soma = 0;
    int quantidadePositivas = 0;

    for (final nota in notas) {
      soma += nota;
      if (nota >= notaPositiva) {
        quantidadePositivas++;
      }
    }

    String mediaTexto = 'Não calculado';
    String percentualTexto = 'Não calculado';
    Classificacao classificacao;

    if (notas.isEmpty) {
      classificacao = Classificacao.semAvaliacoes;
    } else {
      // Calcula somente quando há notas válidas, evitando divisão por zero.
      final media = soma / quantidadeValidas;
      final percentual = quantidadePositivas / quantidadeValidas * 100;
      mediaTexto = media.toStringAsFixed(2);
      percentualTexto = '${percentual.toStringAsFixed(2)}%';

      if (media < 3) {
        classificacao = Classificacao.baixa;
      } else if (media < 4) {
        classificacao = Classificacao.regular;
      } else {
        classificacao = Classificacao.alta;
      }
    }

    String classificacaoTexto;
    switch (classificacao) {
      case Classificacao.semAvaliacoes:
        classificacaoTexto = 'Sem avaliações';
        break;
      case Classificacao.baixa:
        classificacaoTexto = 'Baixa';
        break;
      case Classificacao.regular:
        classificacaoTexto = 'Regular';
        break;
      case Classificacao.alta:
        classificacaoTexto = 'Alta';
        break;
    }

    print('\nAplicativo: $nomeApp');
    print('Categoria: $categoria');
    print('Contato: $contato');
    print('Notas válidas: $quantidadeValidas');
    print('Notas descartadas: $quantidadeDescartadas');
    print('Média: $mediaTexto');
    print('Notas positivas: $percentualTexto');
    print('Classificação: $classificacaoTexto');
  }

  print('\nCATEGORIAS ENCONTRADAS');
  for (final categoria in categoriasUnicas) {
    print(categoria);
  }
}
