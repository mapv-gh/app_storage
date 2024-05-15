import 'package:app_storage/models/venta.dart';
import 'package:app_storage/provider/provider.dart';

class VentaProvider {
  Future<int> insertVenta(Venta venta) async {
    final db = await DatabaseHelper().initDB();
    return await db.insert('ventas', venta.toMap());
  }

  Future<List<Venta>> getVentas(String mes) async {
    final db = await DatabaseHelper().initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'ventas',
      orderBy: 'id DESC',
    );

    List<Venta> ventas = [];
    for (var map in maps) {
      String fecha = map['fecha'].substring(3, 5);
      if (mes == fecha) {
        ventas.add(Venta(
          id: map['id'],
          fecha: map['fecha'],
          nombreCliente: map['nombreCliente'],
        ));
      }
    }
    return ventas;
  }

  Future<List<Venta>> buscarVentas(String query) async {
    final db = await DatabaseHelper().initDB();

    final List<Map<String, dynamic>> result = await db.query('ventas',
        where: 'nombreCliente LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: 'id DESC');

    return List.generate(result.length, (i) {
      return Venta(
        id: result[i]['id'],
        nombreCliente: result[i]['nombreCliente'],
        fecha: result[i]['fecha'],
      );
    });
  }

  Future<Venta> getVentaPorId(int idVenta) async {
    final db = await DatabaseHelper().initDB();

    final List<Map<String, dynamic>> result = await db.query(
      'ventas',
      where: 'id = ?',
      whereArgs: [idVenta],
    );

    return Venta.fromMap(result.first);
  }

  Future<void> deleteVenta(int ventaId) async {
    final db = await DatabaseHelper().initDB();
    await db.transaction((txn) async {
      await txn.delete(
        'detalle_ventas',
        where: 'idVenta = ?',
        whereArgs: [ventaId],
      );
    });
    await db.transaction((txn) async {
      await txn.delete(
        'ventas',
        where: 'id = ?',
        whereArgs: [ventaId],
      );
    });
  }
}
