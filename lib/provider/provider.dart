import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'db_storage421.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
          CREATE TABLE articulos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            stock INTEGER,
            descripcion TEXT,
            idProveedor INTEGER,
            FOREIGN KEY (idProveedor) REFERENCES proveedores(id)
          )
        ''');
    await db.execute('''
          CREATE TABLE compras(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            precio INTEGER,
            cantidad INTEGER,
            fecha TEXT,
            idArticulo INTEGER,
            idProveedor INTEGER,
            FOREIGN KEY (idArticulo) REFERENCES Articulo(id),
            FOREIGN KEY (idProveedor) REFERENCES proveedores(id)
          )
        ''');

    await db.execute('''
          CREATE TABLE proveedores(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            celular TEXT,
            direccion TEXT,
            correo TEXT,
            rut TEXT,
            numCuenta TEXT,
            banco TEXT,
            pagina_web TEXT,
            tipoCuenta TEXT
          )
        ''');
    await db.execute('''
        CREATE TABLE detalle_ventas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT,
          idArticulo INTEGER,
          cantidad INTEGER,
          precio INTEGER,
          idVenta INTEGER,
          FOREIGN KEY (idVenta) REFERENCES ventas (id),
          FOREIGN KEY (idArticulo) REFERENCES articulos (id)
        )
      ''');
    await db.execute('''
        CREATE TABLE ventas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombreCliente TEXT,
            fecha TEXT,
            celular TEXT,
            direccion TEXT,
            rut TEXT,
            user TEXT,
            region TEXT,
            correo TEXT
        )
      ''');
    await db.insert('proveedores',
        {'id': 0, 'nombre': 'Sin Proveedor', 'celular': '', 'direccion': ''});
  }

  Future<int> getTotalPrice(int id) async {
    final db = await initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'detalle_ventas',
      where: 'idVenta = ?',
      whereArgs: [id],
    );
    int resultado = 0;
    for (var i = 0; i < result.length; i++) {
      int cantidad = result[i]['cantidad'];
      int precio = result[i]['precio'];
      resultado += cantidad * precio;
    }
    return resultado;
  }

  Future<int> getTotalMes(String mes) async {
    final db = await DatabaseHelper().initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'ventas',
      orderBy: 'id DESC',
    );

    int resultado = 0;
    for (var map in maps) {
      String fecha = map['fecha'].substring(3, 5);
      if (mes == fecha) {
        int sum = await getTotalPrice(map['id']);
        resultado += sum;
      }
    }
    return resultado;
  }
}
