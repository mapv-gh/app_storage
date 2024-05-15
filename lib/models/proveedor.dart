class Proveedor {
  int? id;
  String nombre;
  String? celular;
  String? direccion;
  String? rut;
  String? banco;
  String? correo;
  String? numCuenta;
  String? paginaWeb;
  String? tipoCuenta;

  Proveedor(
      {this.id,
      required this.nombre,
      this.celular,
      this.direccion,
      this.banco,
      this.correo,
      this.numCuenta,
      this.rut,
      this.paginaWeb,
      this.tipoCuenta});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'celular': celular,
      'direccion': direccion,
      'rut': rut,
      'banco': banco,
      'correo': correo,
      'numCuenta': numCuenta,
      'pagina_web': paginaWeb,
      'tipoCuenta': tipoCuenta
    };
  }

  factory Proveedor.fromMap(Map<String, dynamic> map) {
    return Proveedor(
      id: map['id'],
      nombre: map['nombre'],
      celular: map['celular'],
      direccion: map['direccion'],
      rut: map['rut'],
      banco: map['banco'],
      correo: map['correo'],
      numCuenta: map['numCuenta'],
      paginaWeb: map['pagina_web'],
      tipoCuenta: map['tipoCuenta'],
    );
  }
}
