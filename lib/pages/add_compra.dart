import 'package:app_storage/provider/articulo_provider.dart';
import 'package:app_storage/provider/compra_provider.dart';
import 'package:app_storage/provider/proveedor_provider.dart';
import 'package:app_storage/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_storage/models/compra.dart';
import 'package:app_storage/models/proveedor.dart'; // Asegúrate de importar tu modelo de datos
import 'package:app_storage/provider/provider.dart';

class AddCompra extends StatefulWidget {
  final String id;
  const AddCompra({super.key, required this.id});

  @override
  State<AddCompra> createState() => _AddCompraState();
}

class _AddCompraState extends State<AddCompra> {
  final dbHelper = DatabaseHelper();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  int? selectedProveedorId;
  List<Proveedor> listaProveedores = [];

  @override
  void initState() {
    super.initState();
    cargarProveedores();
  }

  Future<void> cargarProveedores() async {
    final List<Proveedor> proveedores =
        await ProveedorProvider().getProveedores();
    setState(() {
      listaProveedores = proveedores;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(15),
        height: screenSize.height,
        width: screenSize.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: Icon(
                  Icons.arrow_back,
                  size: 35,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // DropdownButton para seleccionar el proveedor
                  DropdownButton<int?>(
                    hint: const Text('Selecciona un proveedor'),
                    value: selectedProveedorId,
                    onChanged: (selectedProviderId) {
                      setState(() {
                        selectedProveedorId = selectedProviderId;
                      });
                    },
                    items: listaProveedores.map((Proveedor proveedor) {
                      return DropdownMenuItem<int?>(
                        value: proveedor.id,
                        child: Text(proveedor.nombre),
                      );
                    }).toList(),
                  ),

                  TextField(
                    controller: precioController,
                    decoration:
                        const InputDecoration(labelText: 'Precio del articulo'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: cantidadController,
                    decoration: const InputDecoration(
                        labelText: 'Cantidad de articulos'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 241, 70, 127))),
                    onPressed: () async {
                      await _insertCompra();
                      await ArticuloProvider().updateStock(
                          int.tryParse(widget.id) ?? 0,
                          int.tryParse(cantidadController.text) ?? 0);
                      precioController.clear();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, true);
                      Functions()
                          .mostrarSnackbar('Nuevo precio agregado', context);
                      setState(() {});
                    },
                    child: const Text(
                      'Agregar Precio',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _insertCompra() async {
    final precio = int.tryParse(precioController.text) ?? 0;
    final cantidad = int.tryParse(cantidadController.text) ?? 0;
    if (cantidad > 0 && precio > 0 && selectedProveedorId != null) {
      final compraF = Compra(
          precio: precio,
          idArticulo: int.tryParse(widget.id) ?? 0,
          idProveedor: selectedProveedorId,
          cantidad: cantidad,
          fecha: DateFormat('dd/MM/yyyy').format(DateTime.now()));

      await CompraProvider().insertCompra(compraF);
      setState(() {});
    } else {
      Functions().mostrarSnackbar('Verifica los campos', context);
    }
  }
}
