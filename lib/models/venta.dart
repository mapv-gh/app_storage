class Venta {
  int? id;
  String nombreCliente;
  String fecha;
  String? celular;
  String? rut;
  String? direccion;
  String? region;
  String? correo;
  String? user;

  Venta(
      {this.id,
      required this.nombreCliente,
      required this.fecha,
      this.celular,
      this.correo,
      this.direccion,
      this.region,
      this.rut,
      this.user});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreCliente': nombreCliente,
      'fecha': fecha,
      'celular': celular,
      'correo': correo,
      'direccion': direccion,
      'region': region,
      'rut': rut,
      'user': user,
    };
  }

  factory Venta.fromMap(Map<String, dynamic> map) {
    return Venta(
      id: map['id'],
      nombreCliente: map['nombreCliente'],
      celular: map['celular'],
      fecha: map['fecha'],
      correo: map['correo'],
      direccion: map['direccion'],
      region: map['region'],
      rut: map['rut'],
      user: map['user'],
    );
  }
}
