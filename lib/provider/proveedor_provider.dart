import 'package:app_storage/models/proveedor.dart';
import 'package:app_storage/provider/provider.dart';

class ProveedorProvider {
  Future<int> insertProveedor(Proveedor proveedor) async {
    final db = await DatabaseHelper().initDB();
    return await db.insert('proveedores', proveedor.toMap());
  }

  Future<List<Proveedor>> buscarProveedores(String query) async {
    final db = await DatabaseHelper().initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'proveedores',
      where: 'nombre LIKE ?',
      whereArgs: ['%$query%'],
    );

    return List.generate(result.length, (i) {
      return Proveedor(
        id: result[i]['id'],
        nombre: result[i]['nombre'],
        direccion: result[i]['direccion'],
        celular: result[i]['celular'],
      );
    });
  }

  Future<List<Proveedor>> getProveedores() async {
    final db = await DatabaseHelper().initDB();
    final List<Map<String, dynamic>> maps = await db.query('proveedores');
    return List.generate(maps.length, (i) {
      return Proveedor(
          id: maps[i]['id'],
          nombre: maps[i]['nombre'],
          celular: maps[i]['celular'],
          direccion: maps[i]['direccion']);
    });
  }

  Future<String> getNombreProveedorPorId(int? idProveedor) async {
    final db = await DatabaseHelper().initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'proveedores',
      columns: ['nombre'],
      where: 'id = ?',
      whereArgs: [idProveedor],
    );

    if (result.isNotEmpty) {
      return result[0]['nombre'] as String;
    } else {
      return 'Proveedor no encontrado';
    }
  }

  Future<Proveedor?> getProveedorPorId(int? idProveedor) async {
    final db = await DatabaseHelper().initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'proveedores',
      columns: [],
      where: 'id = ?',
      whereArgs: [idProveedor],
    );
    if (result.isNotEmpty) {
      return Proveedor.fromMap(result.first);
    } else {
      return null;
    }
  }
}
