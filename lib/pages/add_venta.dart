// ignore_for_file: use_build_context_synchronously

import 'package:app_storage/provider/articulo_provider.dart';
import 'package:app_storage/provider/detalle_ventas_provider.dart';
import 'package:app_storage/provider/venta_provider.dart';
import 'package:app_storage/util/theme.dart';
import 'package:app_storage/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_storage/models/articulo.dart';
import 'package:app_storage/models/detalle_compra.dart';
import 'package:app_storage/models/venta.dart';
import 'package:app_storage/provider/provider.dart';

class AddVenta extends StatefulWidget {
  const AddVenta({super.key});

  @override
  State<AddVenta> createState() => _AddVentaState();
}

class _AddVentaState extends State<AddVenta> {
  final dbHelper = DatabaseHelper();
  final TextEditingController nombreClienteController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController rutController = TextEditingController();
  final TextEditingController direccionClienteController =
      TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  List<int> precios = [];
  List<int> cantidades = [];
  int? selectedArticuloId;
  List<int?> idArticulos = [];
  List<Articulo> listaArticulos = [];
  List<DetalleVenta> listaDetallesVenta = [];

  @override
  void initState() {
    super.initState();
    cargarArticulos();
    precios.add(0);
    cantidades.add(0);
  }

  Future<void> cargarArticulos() async {
    final List<Articulo> articulos = await ArticuloProvider().getArticulos();
    setState(() {
      listaArticulos = articulos;
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
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        title: const Text('Agregar nueva venta',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(205, 241, 70, 127),
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                style:
                    const TextStyle(color: AppColors.textColor, fontSize: 20),
                controller: nombreClienteController,
                cursorColor: AppColors.textColor,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    labelText: 'Nombre del cliente',
                    labelStyle: TextStyle(color: AppColors.textColor)),
              ),
              TextField(
                style:
                    const TextStyle(color: AppColors.textColor, fontSize: 20),
                controller: celularController,
                cursorColor: AppColors.textColor,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    labelText: 'Celular',
                    labelStyle: TextStyle(color: AppColors.textColor)),
              ),
              TextField(
                style:
                    const TextStyle(color: AppColors.textColor, fontSize: 20),
                controller: rutController,
                cursorColor: AppColors.textColor,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    labelText: 'Rut',
                    labelStyle: TextStyle(color: AppColors.textColor)),
              ),
              TextField(
                style:
                    const TextStyle(color: AppColors.textColor, fontSize: 20),
                controller: direccionClienteController,
                cursorColor: AppColors.textColor,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    labelText: 'Dirección',
                    labelStyle: TextStyle(color: AppColors.textColor)),
              ),
              TextField(
                style:
                    const TextStyle(color: AppColors.textColor, fontSize: 20),
                controller: regionController,
                cursorColor: AppColors.textColor,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    labelText: 'Región',
                    labelStyle: TextStyle(color: AppColors.textColor)),
              ),
              TextField(
                style:
                    const TextStyle(color: AppColors.textColor, fontSize: 20),
                controller: correoController,
                cursorColor: AppColors.textColor,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    labelText: 'Correo Electrónico',
                    labelStyle: TextStyle(color: AppColors.textColor)),
              ),
              TextField(
                style:
                    const TextStyle(color: AppColors.textColor, fontSize: 20),
                controller: userController,
                cursorColor: AppColors.textColor,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textColor),
                    ),
                    labelText: 'Usuario de Instagram',
                    labelStyle: TextStyle(color: AppColors.textColor)),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.colorSecondary)),
                  onPressed: () {
                    setState(() {
                      listaDetallesVenta
                          .add(DetalleVenta(cantidad: 0, precio: 0));
                    });
                  },
                  child: const Text(
                    'Agregar Artículo',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                ),
              ),
              SizedBox(
                width: screenSize.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listaDetallesVenta.length,
                  itemBuilder: (BuildContext context, int index) {
                    precios.add(0);
                    cantidades.add(0);
                    return agregarArticulo(index);
                  },
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.colorSecondary)),
                  onPressed: () async {
                    await _insertVenta();
                    setState(() {});
                  },
                  child: const Text(
                    'Agregar Venta',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget agregarArticulo(int index) {
    final Size screenSize = MediaQuery.of(context).size;

    idArticulos.add(null);
    return SizedBox(
      width: screenSize.width,
      child: Row(
        children: [
          SizedBox(
            width: screenSize.width / 6,
            child: TextField(
              style: const TextStyle(color: AppColors.textColor),
              cursorColor: AppColors.textColor,
              onChanged: (value) {
                setState(() {
                  cantidades[index] = int.tryParse(value) ?? 0;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                labelStyle: TextStyle(color: AppColors.textColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textColor),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            width: screenSize.width / 2.1,
            child: DropdownButton<int?>(
              style: const TextStyle(color: AppColors.textColor),
              hint: const Text('Selecciona un Artículo',
                  style: TextStyle(color: AppColors.textColor)),
              value: idArticulos[index],
              dropdownColor: AppColors.colorSecondary,
              onChanged: (selectedArticulo) {
                setState(() {
                  idArticulos[index] = selectedArticulo;
                });
              },
              items: listaArticulos.map((Articulo articulo) {
                return DropdownMenuItem<int?>(
                  value: articulo.id,
                  child: Text(
                    articulo.nombre,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: screenSize.width / 5,
            child: TextField(
              style: const TextStyle(color: AppColors.textColor),
              cursorColor: AppColors.textColor,
              onChanged: (value) {
                precios[index] = int.tryParse(value) ?? 0;
              },
              decoration: const InputDecoration(
                labelText: 'Precio',
                labelStyle: TextStyle(color: AppColors.textColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textColor),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _insertVenta() async {
    if (nombreClienteController.text.isNotEmpty) {
      final venta = Venta(
          fecha: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
          nombreCliente: nombreClienteController.text,
          celular: celularController.text,
          correo: correoController.text,
          direccion: direccionClienteController.text,
          region: regionController.text,
          rut: rutController.text,
          user: userController.text);

      int idVenta = await VentaProvider().insertVenta(venta);

      bool camposValidos = true;
      final List<DetalleVenta> detallesVenta = [];

      for (int i = 0; i < listaDetallesVenta.length; i++) {
        final cantidad = cantidades[i];
        final precio = precios[i];
        final idArticulo = idArticulos[i];
        if (cantidad > 0 && precio > 0 && idArticulo != null) {
          detallesVenta.add(DetalleVenta(
            idVenta: idVenta,
            cantidad: cantidad,
            precio: precio,
            idArticulo: idArticulo,
          ));
        } else {
          camposValidos = false;
          Functions().mostrarSnackbar('Verifica los campos', context);
          break;
        }
      }

      if (camposValidos) {
        await DetalleVentasProvider().insertDetallesVenta(detallesVenta);
        for (int i = 0; i < listaDetallesVenta.length; i++) {
          final cantidad = cantidades[i];
          final idArticulo = idArticulos[i];
          await ArticuloProvider().restarArticulo(idArticulo!, cantidad);
        }
        Functions().mostrarSnackbar('Nueva venta agregada', context);
        // ignore: duplicate_ignore
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        await VentaProvider().deleteVenta(idVenta);
        Functions().mostrarSnackbar('Verifica los campos', context);
      }
    } else {
      Functions().mostrarSnackbar('Escribe el nombre del cliente', context);
    }
  }
}
