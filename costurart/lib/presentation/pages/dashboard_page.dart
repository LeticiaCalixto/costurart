import 'package:flutter/material.dart';
import '../../domain/entities/pedido.dart';
import '../../data/repositories/pedido_repository.dart';

class DashboardPage extends StatelessWidget {
  final PedidoRepository repository;
  const DashboardPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final pedidos = repository.getPedidos();
    final agora = DateTime.now();
    final entregues = pedidos.where((p) => p.tag == 'feito').length;
    final andamento = pedidos.where((p) => p.tag == 'em andamento').length;
    final experimentar = pedidos.where((p) => p.tag == 'experimentar').length;
    final dentroPrazo = pedidos
        .where((p) => p.prazoEntrega.isAfter(agora))
        .length;
    final menos4dias = pedidos
        .where(
          (p) =>
              p.prazoEntrega.difference(agora).inDays < 4 &&
              p.prazoEntrega.isAfter(agora),
        )
        .length;
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _dashboardCard(
                context,
                title: 'Pedidos entregues',
                value: entregues,
                icon: Icons.check_circle,
                color: Colors.green,
              ),
              _dashboardCard(
                context,
                title: 'Pedidos em andamento',
                value: andamento,
                icon: Icons.timelapse,
                color: Colors.orange,
              ),
              _dashboardCard(
                context,
                title: 'Pedidos para experimentar',
                value: experimentar,
                icon: Icons.accessibility,
                color: Colors.blue,
              ),
              _dashboardCard(
                context,
                title: 'Pedidos dentro do prazo',
                value: dentroPrazo,
                icon: Icons.calendar_today,
                color: Colors.teal,
              ),
              _dashboardCard(
                context,
                title: 'Pedidos com prazo < 4 dias',
                value: menos4dias,
                icon: Icons.warning,
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dashboardCard(
    BuildContext context, {
    required String title,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              '$value',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
