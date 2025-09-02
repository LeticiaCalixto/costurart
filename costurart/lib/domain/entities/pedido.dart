class Pedido {
  final String id;
  final String descricao;
  final DateTime prazoEntrega;
  final String tag; // 'em andamento', 'feito', 'experimentar'
  final int prioridade;

  Pedido({
    required this.id,
    required this.descricao,
    required this.prazoEntrega,
    required this.tag,
    required this.prioridade,
  });
}
