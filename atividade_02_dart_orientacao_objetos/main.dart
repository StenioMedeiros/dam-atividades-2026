import 'package:flutter/material.dart';

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
    final texto = novoTitulo.trim();
    if (texto.isNotEmpty) {
      _titulo = texto;
    }
  }

  String get autorExibicao => autor ?? 'Autor desconhecido';

  String descricao();
}

extension ReferenciaLivro on Livro {
  String get referencia => '$titulo - $autorExibicao';
}

// QUESTÃO 2 — Interface e empréstimos.

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
  }) : super(codigo: codigo, titulo: titulo, autor: autor);

  @override
  bool get disponivel => _disponivel;

  @override
  bool emprestar() {
    if (!_disponivel) return false;
    _disponivel = false;
    return true;
  }

  @override
  void devolver() {
    _disponivel = true;
  }

  @override
  String descricao() {
    return 'Código: $codigo\n'
        'Título: $titulo\n'
        'Autor: $autorExibicao\n'
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
  }) : super(codigo: codigo, titulo: titulo, autor: autor);

  @override
  String descricao() {
    return 'Código: $codigo\n'
        'Título: $titulo\n'
        'Autor: $autorExibicao\n'
        'Tamanho: ${tamanhoMB.toStringAsFixed(2)} MB';
  }
}

// Interface gráfica Flutter.

void main() {
  // Livros dos dois tipos reunidos na mesma coleção.
  final catalogo = <Livro>[
    LivroFisico(
      codigo: 'F001',
      titulo: 'Dom Casmurro',
      autor: 'Machado de Assis',
      numeroPaginas: 256,
    ),
    LivroDigital(
      codigo: 'D001',
      titulo: 'Introdução ao Dart',
      tamanhoMB: 3.5,
    ),
  ];

  runApp(BibliotecaApp(catalogo: catalogo));
}

class BibliotecaApp extends StatelessWidget {
  final List<Livro> catalogo;

  const BibliotecaApp({super.key, required this.catalogo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catálogo da Biblioteca',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3155A4),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F5FA),
      ),
      home: BibliotecaPage(catalogo: catalogo),
    );
  }
}

class BibliotecaPage extends StatefulWidget {
  final List<Livro> catalogo;

  const BibliotecaPage({super.key, required this.catalogo});

  @override
  State<BibliotecaPage> createState() => _BibliotecaPageState();
}

class _BibliotecaPageState extends State<BibliotecaPage> {
  final tituloController = TextEditingController();
  final historico = <String>[
    'Catálogo carregado. O livro físico começa disponível.',
  ];

  LivroFisico get livroFisico =>
      widget.catalogo.whereType<LivroFisico>().first;

  @override
  void dispose() {
    tituloController.dispose();
    super.dispose();
  }

  void alterarTitulo() {
    final entrada = tituloController.text;

    setState(() {
      livroFisico.titulo = entrada;

      if (entrada.trim().isEmpty) {
        historico.add(
          'Título em branco ignorado. Mantido: "${livroFisico.titulo}".',
        );
      } else {
        historico.add(
          'Título atualizado: "${livroFisico.titulo}".',
        );
      }
    });

    tituloController.clear();
  }

  void emprestar() {
    setState(() {
      final aceito = livroFisico.emprestar();
      historico.add(
        aceito
            ? 'Empréstimo aceito. O livro ficou indisponível.'
            : 'Empréstimo recusado: o livro já está emprestado.',
      );
    });
  }

  void devolver() {
    setState(() {
      final jaDisponivel = livroFisico.disponivel;
      livroFisico.devolver();

      historico.add(
        jaDisponivel
            ? 'O livro já estava disponível e continua disponível.'
            : 'Devolução realizada. O livro está disponível novamente.',
      );
    });
  }

  void demonstrarAtividade() {
    setState(() {
      historico.clear();

      livroFisico.devolver();
      historico.add('Disponibilidade inicial: disponível.');

      livroFisico.titulo = '   Dom Casmurro — edição revisada   ';
      historico.add(
        'Entrada válida, com espaços removidos: "${livroFisico.titulo}".',
      );

      livroFisico.titulo = '   ';
      historico.add(
        'Entrada em branco: título mantido em "${livroFisico.titulo}".',
      );

      final primeiro = livroFisico.emprestar();
      historico.add(
        'Primeiro empréstimo: ${primeiro ? "aceito" : "recusado"}.',
      );
      historico.add(
        'Disponível após empréstimo: ${livroFisico.disponivel}.',
      );

      final segundo = livroFisico.emprestar();
      historico.add(
        'Segunda tentativa: ${segundo ? "aceita" : "recusada"}.',
      );

      livroFisico.devolver();
      historico.add(
        'Disponível após devolução: ${livroFisico.disponivel}.',
      );

      livroFisico.devolver();
      historico.add(
        'Após devolver novamente: ${livroFisico.disponivel}.',
      );
    });
  }

  Widget secao(String titulo, Widget conteudo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            conteudo,
          ],
        ),
      ),
    );
  }

  Widget cartaoLivro(Livro livro) {
    final fisico = livro is LivroFisico;

    return secao(
      fisico ? 'Livro físico' : 'Livro digital',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            livro.descricao(),
            style: const TextStyle(fontSize: 16, height: 1.6),
          ),
          const Divider(height: 28),
          const Text(
            'REFERÊNCIA',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(livro.referencia),
          const SizedBox(height: 12),
          if (livro is LivroFisico)
            Chip(
              avatar: Icon(
                livro.disponivel
                    ? Icons.check_circle
                    : Icons.schedule,
                size: 18,
              ),
              label: Text(
                livro.disponivel ? 'Disponível' : 'Emprestado',
              ),
            )
          else
            const Chip(
              avatar: Icon(Icons.devices, size: 18),
              label: Text('Digital — sem empréstimo físico'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca • Atividade 2'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Catálogo da biblioteca',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Livros físicos e digitais, referências e empréstimos.',
                ),
                const SizedBox(height: 20),

                for (final livro in widget.catalogo)
                  cartaoLivro(livro),

                secao(
                  'Alterar título do livro físico',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Novo título',
                          hintText: 'Digite o título',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => alterarTitulo(),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: alterarTitulo,
                        icon: const Icon(Icons.edit),
                        label: const Text('Atualizar título'),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Para testar uma entrada em branco, '
                        'deixe o campo vazio e clique em atualizar.',
                      ),
                    ],
                  ),
                ),

                secao(
                  'Empréstimo do livro físico',
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: emprestar,
                        icon: const Icon(Icons.book),
                        label: const Text('Emprestar'),
                      ),
                      OutlinedButton.icon(
                        onPressed: devolver,
                        icon: const Icon(Icons.assignment_return),
                        label: const Text('Devolver'),
                      ),
                    ],
                  ),
                ),

                secao(
                  'Demonstração das duas questões',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Execute a sequência completa: título válido, '
                        'título em branco, empréstimo aceito, tentativa '
                        'recusada e devolução.',
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: demonstrarAtividade,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Demonstrar atividade'),
                      ),
                    ],
                  ),
                ),

                secao(
                  'Resultados na tela',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < historico.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            '${i + 1}. ${historico[i]}',
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
