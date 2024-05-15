class Articulo {
  int? id;
  String nombre;
  int stock;
  int? idProveedor;
  String? descripcion;

  Articulo(
      {this.id,
      required this.nombre,
      required this.stock,
      this.descripcion,
      this.idProveedor});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'stock': stock,
      'idProveedor': idProveedor,
      'descripcion': descripcion
    };
  }

  static fromMap(Map<String, dynamic> map) {}
}
