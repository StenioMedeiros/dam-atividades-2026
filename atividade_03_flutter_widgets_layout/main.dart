import 'package:flutter/material.dart';

void main() => runApp(const PedidoFlashApp());

class PedidoFlashApp extends StatelessWidget {
  const PedidoFlashApp({super.key});

  @override
  Widget build(BuildContext context) {
    const laranja = Color(0xFFFF6B35);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pedido Flash',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: laranja),
        scaffoldBackgroundColor: const Color(0xFFF7F7F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF202124),
          centerTitle: false,
        ),
      ),
      home: const PedidoFlashHome(),
    );
  }
}

class Produto {
  final String nome;
  final String categoria;
  final String preco;
  final IconData icone;
  final Color cor;

  const Produto(this.nome, this.categoria, this.preco, this.icone, this.cor);
}

const produtos = <Produto>[
  Produto('X-Burger', 'MAIS PEDIDO', r'R$ 22,90', Icons.lunch_dining, Color(0xFFFFE3D8)),
  Produto('Pizza da casa', 'PIZZA', r'R$ 39,90', Icons.local_pizza, Color(0xFFFFE9C7)),
  Produto('Batata crocante', 'PORÇÃO', r'R$ 16,50', Icons.fastfood, Color(0xFFFFF0C2)),
  Produto('Suco natural', 'BEBIDA', r'R$ 8,90', Icons.local_drink, Color(0xFFDDF4E5)),
];

class PedidoFlashHome extends StatefulWidget {
  const PedidoFlashHome({super.key});

  @override
  State<PedidoFlashHome> createState() => _PedidoFlashHomeState();
}

class _PedidoFlashHomeState extends State<PedidoFlashHome> {
  int itensNoCarrinho = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.flash_on, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            const Text('Pedido Flash', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  tooltip: 'Carrinho',
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Itens no carrinho: ' + itensNoCarrinho.toString())),
                  ),
                  icon: const Icon(Icons.shopping_bag_outlined),
                ),
                if (itensNoCarrinho > 0)
                  CircleAvatar(
                    radius: 9,
                    backgroundColor: const Color(0xFFFF6B35),
                    child: Text(itensNoCarrinho.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFFF6B35)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.flash_on, color: Color(0xFFFF6B35), size: 30),
                  ),
                  SizedBox(height: 10),
                  Text('Pedido Flash', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Seu ponto de venda', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            _opcaoMenu(context, Icons.home_outlined, 'Início', selecionado: true),
            _opcaoMenu(context, Icons.receipt_long_outlined, 'Meus pedidos'),
            _opcaoMenu(context, Icons.settings_outlined, 'Configurações'),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final colunas = constraints.maxWidth >= 850 ? 4 : constraints.maxWidth >= 560 ? 3 : 2;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Olá! 👋', style: TextStyle(fontSize: 14, color: Color(0xFF70757A))),
                  const SizedBox(height: 4),
                  const Text('O que vamos pedir hoje?', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: Color(0xFF202124))),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252A34),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SABOR SEM ESPERA', style: TextStyle(color: Color(0xFFFFB199), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                              SizedBox(height: 7),
                              Text('Seu pedido: rápido e fácil.', style: TextStyle(color: Colors.white, fontSize: 19, height: 1.15, fontWeight: FontWeight.bold)),
                              SizedBox(height: 6),
                              Text('Escolha seus favoritos do cardápio.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(color: const Color(0xFFFF6B35), borderRadius: BorderRadius.circular(18)),
                          child: const Icon(Icons.bolt, color: Colors.white, size: 34),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Cardápio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      Text('• ' + produtos.length.toString() + ' produtos', style: const TextStyle(color: Color(0xFF70757A), fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 13),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: produtos.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: colunas,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: colunas == 2 ? 0.78 : 0.88,
                    ),
                    itemBuilder: (context, index) => _cartaoProduto(produtos[index]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _cartaoProduto(Produto produto) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: produto.cor, borderRadius: BorderRadius.circular(12)),
                child: Icon(produto.icone, size: 42, color: const Color(0xFF343A40)),
              ),
            ),
            const SizedBox(height: 10),
            Text(produto.categoria, style: const TextStyle(color: Color(0xFF9A9A9A), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
            const SizedBox(height: 3),
            Text(produto.nome, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(produto.preco, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF252A34))),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: IconButton.filled(
                    padding: EdgeInsets.zero,
                    tooltip: 'Adicionar ' + produto.nome,
                    onPressed: () => setState(() => itensNoCarrinho++),
                    icon: const Icon(Icons.add, size: 18),
                    style: IconButton.styleFrom(backgroundColor: const Color(0xFFFF6B35), foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _opcaoMenu(BuildContext context, IconData icone, String titulo, {bool selecionado = false}) {
    return ListTile(
      leading: Icon(icone, color: selecionado ? const Color(0xFFFF6B35) : const Color(0xFF65676B)),
      title: Text(titulo, style: TextStyle(fontWeight: selecionado ? FontWeight.bold : FontWeight.normal)),
      selected: selecionado,
      onTap: () {
        Navigator.pop(context);
        if (!selecionado) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(titulo + ': exemplo demonstrativo')));
        }
      },
    );
  }
}
