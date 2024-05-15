class DetalleVenta {
  int? id;
  int cantidad;
  int precio;
  int? idArticulo;
  int? idVenta;

  DetalleVenta(
      {this.idVenta,
      this.id,
      required this.cantidad,
      required this.precio,
      this.idArticulo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'precio': precio,
      'cantidad': cantidad,
      'idArticulo': idArticulo,
      'idVenta': idVenta
    };
  }
}
