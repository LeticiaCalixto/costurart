import 'package:flutter/material.dart';
import '../../data/repositories/pedido_repository.dart';
import '../../domain/entities/pedido.dart';

class PedidosGuestPage extends StatefulWidget {
  final String? nome;
  final String? telefone;
  final PedidoRepository repository;
  const PedidosGuestPage({
    super.key,
    this.nome,
    this.telefone,
    required this.repository,
  });

  @override
  State<PedidosGuestPage> createState() => _PedidosGuestPageState();
}

class _PedidosGuestPageState extends State<PedidosGuestPage> {
  final _descricaoController = TextEditingController();
  DateTime? _prazo;
  String _status = 'aguardando';

  List<Pedido> get _historico => widget.repository
      .getPedidos()
      .where((p) => p.descricao.contains(widget.nome ?? ''))
      .toList();

  void _addPedido() {
    if (_descricaoController.text.isEmpty || _prazo == null) return;
    widget.repository.addPedido(
      Pedido(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        descricao: _descricaoController.text,
        prazoEntrega: _prazo!,
        tag: _status == 'pronto' ? 'feito' : 'em andamento',
        prioridade: 1,
      ),
    );
    setState(() {
      _descricaoController.clear();
      _prazo = null;
      _status = 'aguardando';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos - Guest')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Olá, ${widget.nome ?? ''}'),
            Text('Telefone: ${widget.telefone ?? ''}'),
            const SizedBox(height: 16),
            Text(
              'Anotar novo pedido',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição do pedido',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _prazo == null
                        ? 'Agendar entrega'
                        : 'Entrega: ${_prazo!.day}/${_prazo!.month}/${_prazo!.year}',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => _prazo = picked);
                  },
                ),
              ],
            ),
            DropdownButton<String>(
              value: _status,
              items: const [
                DropdownMenuItem(
                  value: 'aguardando',
                  child: Text('Aguardando'),
                ),
                DropdownMenuItem(
                  value: 'pronto',
                  child: Text('Pronto, pode buscar'),
                ),
              ],
              onChanged: (v) => setState(() => _status = v ?? 'aguardando'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _addPedido,
              child: const Text('Salvar pedido'),
            ),
            const Divider(height: 32),
            Text(
              'Histórico de pedidos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Expanded(
              child: _historico.isEmpty
                  ? const Text('Nenhum pedido encontrado')
                  : ListView.builder(
                      itemCount: _historico.length,
                      itemBuilder: (context, index) {
                        final pedido = _historico[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(pedido.descricao),
                            subtitle: Text(
                              'Entrega: ${pedido.prazoEntrega.day}/${pedido.prazoEntrega.month}/${pedido.prazoEntrega.year}',
                            ),
                            trailing: Chip(label: Text(pedido.tag)),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
