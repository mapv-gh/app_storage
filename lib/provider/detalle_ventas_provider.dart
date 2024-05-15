import 'package:app_storage/models/detalle_compra.dart';
import 'package:app_storage/provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DetalleVentasProvider {
  Future<int> insertDetallesVenta(List<DetalleVenta> detallesVenta) async {
    final db = await DatabaseHelper().initDB();
    int resultado = 0;
    await db.transaction((txn) async {
      for (var detalleVenta in detallesVenta) {
        await txn.insert(
          'detalle_ventas',
          detalleVenta.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    resultado = 1;
    return resultado;
  }

  Future<List<DetalleVenta>> getDetallesVentaById(int id) async {
    final db = await DatabaseHelper().initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'detalle_ventas',
      where: 'idVenta = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) {
      return DetalleVenta(
        id: maps[i]['id'],
        cantidad: maps[i]['cantidad'],
        precio: maps[i]['precio'],
        idArticulo: maps[i]['idArticulo'],
      );
    });
  }
}
