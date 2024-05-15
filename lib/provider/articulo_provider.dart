import 'package:app_storage/models/articulo.dart';
import 'package:app_storage/provider/provider.dart';

class ArticuloProvider {
  Future<int> insertArticulo(Articulo articulo) async {
    final db = await DatabaseHelper().initDB();
    return await db.insert('articulos', articulo.toMap());
  }

  Future<List<Articulo>> getArticulos() async {
    final db = await DatabaseHelper().initDB();
    final List<Map<String, dynamic>> maps = await db.query('articulos');
    return List.generate(maps.length, (i) {
      return Articulo(
        id: maps[i]['id'],
        nombre: maps[i]['nombre'],
        stock: maps[i]['stock'],
        idProveedor: maps[i]['idProveedor'],
      );
    });
  }

  Future<Articulo?> getArticuloById(int idArticulo) async {
    final db = await DatabaseHelper().initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'articulos',
      where: 'id = ?',
      whereArgs: [idArticulo],
    );
    if (result.isNotEmpty) {
      return Articulo(
          id: result[0]['id'],
          nombre: result[0]['nombre'],
          stock: result[0]['stock'],
          idProveedor: result[0]['idProveedor'],
          descripcion: result[0]['descripcion']);
    } else {
      return null;
    }
  }

  Future<List<Articulo>> buscarArticulos(String query) async {
    final db = await DatabaseHelper().initDB();

    final List<Map<String, dynamic>> result = await db.query(
      'articulos',
      where: 'nombre LIKE ?',
      whereArgs: ['%$query%'],
    );

    return List.generate(result.length, (i) {
      return Articulo(
        id: result[i]['id'],
        nombre: result[i]['nombre'],
        stock: result[i]['stock'],
        idProveedor: result[i]['idProveedor'],
      );
    });
  }

  Future<String> getNombreArticuloPorId(int? idArticulo) async {
    final db = await DatabaseHelper().initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'articulos',
      where: 'id = ?',
      whereArgs: [idArticulo],
    );

    if (result.isNotEmpty) {
      return result[0]['nombre'] as String;
    } else {
      return 'Articulo no encontrado';
    }
  }

  Future<void> restarArticulo(int idArticulo, int cantidad) async {
    final db = await DatabaseHelper().initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'articulos',
      columns: ['stock'],
      where: 'id = ?',
      whereArgs: [idArticulo],
    );

    if (result.isNotEmpty) {
      final int stockActual = result[0]['stock'] as int;
      final int nuevoStock = stockActual - cantidad;

      await db.update(
        'articulos',
        {'stock': nuevoStock},
        where: 'id = ?',
        whereArgs: [idArticulo],
      );
    }
  }

  Future<void> updateStock(int idArticulo, int stockIncrement) async {
    final db = await DatabaseHelper().initDB();

    final List<Map<String, dynamic>> result = await db.query(
      'articulos',
      columns: ['stock'],
      where: 'id = ?',
      whereArgs: [idArticulo],
    );

    if (result.isNotEmpty) {
      final int stockActual = result[0]['stock'] as int;
      final int nuevoStock = stockActual + stockIncrement;

      await db.update(
        'articulos',
        {'stock': nuevoStock},
        where: 'id = ?',
        whereArgs: [idArticulo],
      );
    }
  }
}
