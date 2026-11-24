// QUESTÃO 1 — Classes, construtores e descrições.

abstract class Livro {
  final String codigo;
  String _titulo;
  final String? autor;

  Livro({
    required this.codigo,
    required String titulo,
    this.autor,
  }) : _titulo = titulo.trim();

  String get titulo => _titulo;

  set titulo(String novoTitulo) {
    final tituloTratado = novoTitulo.trim();

    if (tituloTratado.isNotEmpty) {
      _titulo = tituloTratado;
    }
  }

  String get autorExibicao => autor ?? 'Autor desconhecido';

  String descricao();
}

extension ReferenciaLivro on Livro {
  String get referencia => '$titulo - $autorExibicao';
}

// QUESTÃO 2 — Interface para empréstimos.

abstract class Emprestavel {
  bool get disponivel;

  bool emprestar();

  void devolver();
}

class LivroFisico extends Livro implements Emprestavel {
  final int numeroPaginas;
  bool _disponivel = true;

  LivroFisico({
    required String codigo,
    required String titulo,
    String? autor,
    required this.numeroPaginas,
  }) : super(
          codigo: codigo,
          titulo: titulo,
          autor: autor,
        );

  @override
  bool get disponivel => _disponivel;

  @override
  bool emprestar() {
    if (!_disponivel) {
      return false;
    }

    _disponivel = false;
    return true;
  }

  @override
  void devolver() {
    _disponivel = true;
  }

  @override
  String descricao() {
    return 'Livro físico | Código: $codigo | '
        'Título: $titulo | Autor: $autorExibicao | '
        'Páginas: $numeroPaginas';
  }
}

class LivroDigital extends Livro {
  final double tamanhoMB;

  LivroDigital({
    required String codigo,
    required String titulo,
    String? autor,
    required this.tamanhoMB,
  }) : super(
          codigo: codigo,
          titulo: titulo,
          autor: autor,
        );

  @override
  String descricao() {
    return 'Livro digital | Código: $codigo | '
        'Título: $titulo | Autor: $autorExibicao | '
        'Tamanho: ${tamanhoMB.toStringAsFixed(2)} MB';
  }
}

void main() {
  final livroFisico = LivroFisico(
    codigo: 'F001',
    titulo: 'Dom Casmurro',
    autor: 'Machado de Assis',
    numeroPaginas: 256,
  );

  final livroDigital = LivroDigital(
    codigo: 'D001',
    titulo: 'Introdução ao Dart',
    tamanhoMB: 3.5,
    // Sem autor para demonstrar o tratamento da ausência.
  );

  // Uma única coleção com os dois tipos de livro.
  final catalogo = <Livro>[
    livroFisico,
    livroDigital,
  ];

  print('CATÁLOGO DA BIBLIOTECA');
  print('=====================');

  for (final livro in catalogo) {
    print(livro.descricao());
    print('Referência: ${livro.referencia}');
    print('');
  }

  print('ALTERAÇÃO DO TÍTULO');
  print('Título original: ${livroFisico.titulo}');

  livroFisico.titulo = '   Dom Casmurro — edição revisada   ';
  print('Após entrada válida: "${livroFisico.titulo}"');

  livroFisico.titulo = '   ';
  print('Após entrada em branco: "${livroFisico.titulo}"');
  print('Referência atualizada: ${livroFisico.referencia}');

  print('\nEMPRÉSTIMOS');

  final Emprestavel exemplar = livroFisico;

  print('Disponível inicialmente: ${exemplar.disponivel}');

  final primeiroEmprestimo = exemplar.emprestar();
  print(
    'Primeiro empréstimo: '
    '${primeiroEmprestimo ? "Aceito" : "Recusado"}',
  );
  print('Disponível após empréstimo: ${exemplar.disponivel}');

  final segundaTentativa = exemplar.emprestar();
  print(
    'Segunda tentativa: '
    '${segundaTentativa ? "Aceita" : "Recusada"}',
  );

  exemplar.devolver();
  print('Disponível após devolução: ${exemplar.disponivel}');

  exemplar.devolver();
  print('Disponível após devolver novamente: ${exemplar.disponivel}');
}
