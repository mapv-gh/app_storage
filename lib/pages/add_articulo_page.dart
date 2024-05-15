import 'package:app_storage/provider/articulo_provider.dart';
import 'package:app_storage/provider/compra_provider.dart';
import 'package:app_storage/provider/proveedor_provider.dart';
import 'package:app_storage/util/theme.dart';
import 'package:app_storage/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_storage/models/articulo.dart';
import 'package:app_storage/models/compra.dart';
import 'package:app_storage/models/proveedor.dart';
import 'package:app_storage/provider/provider.dart';

class AddArticulo extends StatefulWidget {
  const AddArticulo({super.key});

  @override
  State<AddArticulo> createState() => _AddArticuloState();
}

class _AddArticuloState extends State<AddArticulo> {
  final dbHelper = DatabaseHelper();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
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
    // ignore: avoid_print
    print('Tamaño de la lista de proveedores: ${proveedores.length}');
    setState(() {
      listaProveedores = proveedores;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, false);
          },
          color: Colors.white,
        ),
        title: const Text('Agregar articulo',
            style: TextStyle(color: AppColors.textColor)),
        backgroundColor: const Color.fromARGB(255, 241, 70, 127),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: screenSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Proveedor',
                      style:
                          TextStyle(fontSize: 17, color: AppColors.textColor),
                    ),
                    DropdownButton<int?>(
                      dropdownColor: AppColors.colorSecondary,
                      hint: const Text(
                        'Selecciona un proveedor',
                        style: TextStyle(color: AppColors.textColor),
                      ),
                      value: selectedProveedorId,
                      onChanged: (selectedProviderId) {
                        setState(() {
                          selectedProveedorId = selectedProviderId;
                        });
                      },
                      items: listaProveedores.map((Proveedor proveedor) {
                        return DropdownMenuItem<int?>(
                          value: proveedor.id,
                          child: Text(
                            proveedor.nombre,
                            style: const TextStyle(color: AppColors.textColor),
                          ),
                        );
                      }).toList(),
                    ),
                    TextField(
                      style: const TextStyle(color: AppColors.textColor),
                      controller: nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del articulo',
                        labelStyle: TextStyle(
                          color: AppColors.textColor,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textColor),
                        ),
                      ),
                      cursorColor: AppColors.textColor,
                    ),
                    TextField(
                      style: const TextStyle(color: AppColors.textColor),
                      controller: precioController,
                      decoration: const InputDecoration(
                        labelText: 'Precio del articulo',
                        labelStyle: TextStyle(
                          color: AppColors.textColor,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textColor),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      style: const TextStyle(color: AppColors.textColor),
                      controller: stockController,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad del articulo',
                        labelStyle: TextStyle(
                          color: AppColors.textColor,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textColor),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      style: const TextStyle(color: AppColors.textColor),
                      controller: descripcionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        labelStyle: TextStyle(
                          color: AppColors.textColor,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textColor),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        await _insertArticulo();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 241, 70, 127))),
                      child: const Text(
                        'Agregar articulo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _insertArticulo() async {
    final nombre = nombreController.text;
    final precio = int.tryParse(precioController.text) ?? 0;
    final stock = int.tryParse(stockController.text) ?? 0;
    final descripcion = descripcionController.text;

    if (nombre.isNotEmpty &&
        precio > 0 &&
        selectedProveedorId != null &&
        descripcion.isNotEmpty &&
        stock > 0) {
      final articulo = Articulo(
          nombre: nombre,
          stock: stock,
          idProveedor: selectedProveedorId,
          descripcion: descripcion);
      final articuloId = await ArticuloProvider().insertArticulo(articulo);

      final compraD = Compra(
          precio: precio,
          idArticulo: articuloId,
          idProveedor: selectedProveedorId,
          cantidad: stock,
          fecha: DateFormat('dd/MM/yyyy').format(DateTime.now()));

      await CompraProvider().insertCompra(compraD);

      setState(() {
        Navigator.pop(context, true);
        Functions().mostrarSnackbar('Articulo agregado', context);
      });
    } else {
      Functions().mostrarSnackbar('Verifica los campos', context);
    }
  }
}
