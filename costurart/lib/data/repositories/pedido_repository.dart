import '../../domain/entities/pedido.dart';

class PedidoRepository {
  final List<Pedido> _pedidos = [];

  List<Pedido> getPedidos({String? tag}) {
    if (tag != null) {
      return _pedidos.where((p) => p.tag == tag).toList();
    }
    return _pedidos;
  }

  void addPedido(Pedido pedido) {
    _pedidos.add(pedido);
  }

  // Outros métodos para editar, remover, etc.
}
