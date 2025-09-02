import 'package:flutter/material.dart';
import '../../domain/entities/pedido.dart';
import '../../data/repositories/pedido_repository.dart';

class PedidosPage extends StatefulWidget {
  final PedidoRepository repository;
  const PedidosPage({super.key, required this.repository});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  int _selectedIndex = 0;
  String? filtroTag;

  final List<Map<String, dynamic>> tiposServico = [
    {'nome': 'Fazer barra', 'tempo': Duration(hours: 2)},
    {'nome': 'Diminuir camiseta', 'tempo': Duration(days: 2)},
    {'nome': 'Buraco', 'tempo': Duration(hours: 1)},
    // Adicione mais tipos conforme necessário
  ];

  String? _tipoSelecionado;
  DateTime? _dataEntrega;
  String? _prazoTexto;

  void _calcularPrazo() {
    if (_tipoSelecionado == null) return;
    // Simulação: agenda da costureira está cheia por 5 dias
    final agendaCheiaDias = 5;
    final tipo = tiposServico.firstWhere((t) => t['nome'] == _tipoSelecionado);
    final tempoMinimo = tipo['tempo'] as Duration;
    final prazoFinal = DateTime.now().add(
      Duration(days: agendaCheiaDias) + tempoMinimo,
    );
    setState(() {
      _dataEntrega = prazoFinal;
      _prazoTexto =
          'O tipo selecionado ficará pronto em ${prazoFinal.difference(DateTime.now()).inDays} dias (${prazoFinal.day}/${prazoFinal.month}/${prazoFinal.year})';
    });
  }

  void _enviarPedido() {
    if (_tipoSelecionado == null || _dataEntrega == null) return;
    widget.repository.addPedido(
      Pedido(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        descricao: _tipoSelecionado!,
        prazoEntrega: _dataEntrega!,
        tag: 'em andamento',
        prioridade: 1,
      ),
    );
    setState(() {
      _tipoSelecionado = null;
      _dataEntrega = null;
      _prazoTexto = null;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Pedido enviado!')));
  }

  @override
  Widget build(BuildContext context) {
    List<Pedido> pedidos = widget.repository.getPedidos(tag: filtroTag);
    pedidos.sort((a, b) => a.prazoEntrega.compareTo(b.prazoEntrega));
    final pages = [
      // Menu Pedidos
      Column(
        children: [
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Cadastrar novo pedido'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Novo Pedido'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<String>(
                        hint: const Text('Tipo de serviço'),
                        value: _tipoSelecionado,
                        items: tiposServico
                            .map(
                              (t) => DropdownMenuItem<String>(
                                value: t['nome'] as String,
                                child: Text(t['nome'] as String),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _tipoSelecionado = value;
                          });
                          _calcularPrazo();
                        },
                      ),
                      if (_prazoTexto != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            _prazoTexto!,
                            style: const TextStyle(color: Colors.deepPurple),
                          ),
                        ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed:
                          (_tipoSelecionado != null && _dataEntrega != null)
                          ? () {
                              Navigator.of(context).pop();
                              _enviarPedido();
                            }
                          : null,
                      child: const Text('Enviar pedido'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: ListTile(
                    leading: Icon(Icons.shopping_bag, color: Colors.deepPurple),
                    title: Text(
                      pedido.descricao,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Prazo: ${pedido.prazoEntrega.day}/${pedido.prazoEntrega.month}/${pedido.prazoEntrega.year}',
                    ),
                    trailing: Chip(label: Text(pedido.tag)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Menu Status
      Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: ListTile(
                    leading: Icon(Icons.info_outline, color: Colors.blueGrey),
                    title: Text(pedido.descricao),
                    subtitle: Text('Status: ${pedido.tag}'),
                    trailing: Text(
                      'Entrega: ${pedido.prazoEntrega.day}/${pedido.prazoEntrega.month}/${pedido.prazoEntrega.year}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Status',
          ),
        ],
      ),
    );
  }
}
