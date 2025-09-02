import '../entities/pedido.dart';
import '../../data/repositories/pedido_repository.dart';

class GetPedidos {
  final PedidoRepository repository;
  GetPedidos(this.repository);

  List<Pedido> call({String? tag}) {
    return repository.getPedidos(tag: tag);
  }
}
