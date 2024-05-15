import 'package:app_storage/models/compra.dart';
import 'package:app_storage/provider/provider.dart';

class CompraProvider {
  Future<int> insertCompra(Compra compra) async {
    final db = await DatabaseHelper().initDB();
    return await db.insert('compras', compra.toMap());
  }

  Future<List<Compra>> getPreciosPorArticulo(int? idArticulo) async {
    final db = await DatabaseHelper().initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'compras',
      columns: [
        'id',
        'precio',
        'idArticulo',
        'idProveedor',
        'cantidad',
        'fecha'
      ],
      where: 'idArticulo = ?',
      whereArgs: [idArticulo],
    );

    if (result.isNotEmpty) {
      final List<Compra> precios = result
          .map((map) => Compra(
              id: map['id'],
              precio: map['precio'],
              cantidad: map['cantidad'],
              idArticulo: map['idArticulo'],
              idProveedor: map['idProveedor'],
              fecha: map['fecha']))
          .toList();

      return precios;
    } else {
      return [];
    }
  }
}
