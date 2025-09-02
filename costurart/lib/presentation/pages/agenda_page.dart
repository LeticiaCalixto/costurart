import 'package:flutter/material.dart';
import '../../domain/entities/pedido.dart';
import '../../data/repositories/pedido_repository.dart';

class AgendaPage extends StatelessWidget {
  final PedidoRepository repository;
  const AgendaPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final pedidos = repository.getPedidos();
    final pedidosPorDia = <DateTime, List<Pedido>>{};
    for (var pedido in pedidos) {
      final dia = DateTime(
        pedido.prazoEntrega.year,
        pedido.prazoEntrega.month,
        pedido.prazoEntrega.day,
      );
      pedidosPorDia.putIfAbsent(dia, () => []).add(pedido);
    }
    final dias = pedidosPorDia.keys.toList()..sort();
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 48,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Calendário',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nenhuma entrega marcada',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: dias.isEmpty
                ? Center(child: Text('Nenhuma entrega agendada'))
                : ListView.builder(
                    itemCount: dias.length,
                    itemBuilder: (context, index) {
                      final dia = dias[index];
                      final pedidosDoDia = pedidosPorDia[dia]!;
                      return ExpansionTile(
                        title: Text('${dia.day}/${dia.month}/${dia.year}'),
                        children: pedidosDoDia
                            .map(
                              (pedido) => ListTile(
                                title: Text(pedido.descricao),
                                trailing: Chip(label: Text(pedido.tag)),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
