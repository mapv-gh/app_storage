class Compra {
  int? id;
  int precio;
  int cantidad;
  int idArticulo;
  int? idProveedor;
  String fecha;

  Compra({
    this.id,
    required this.precio,
    required this.idArticulo,
    this.idProveedor,
    required this.cantidad,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'precio': precio,
      'idArticulo': idArticulo,
      'idProveedor': idProveedor,
      'cantidad': cantidad,
      'fecha': fecha,
    };
  }
}
