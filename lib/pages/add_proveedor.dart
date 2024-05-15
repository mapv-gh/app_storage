import 'package:app_storage/provider/proveedor_provider.dart';
import 'package:app_storage/util/theme.dart';
import 'package:app_storage/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:app_storage/models/proveedor.dart';
import 'package:app_storage/provider/provider.dart';

class AddProveedor extends StatefulWidget {
  const AddProveedor({super.key});

  @override
  State<AddProveedor> createState() => _AddProveedorState();
}

class _AddProveedorState extends State<AddProveedor> {
  final dbHelper = DatabaseHelper();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController rutController = TextEditingController();
  final TextEditingController paginaController = TextEditingController();
  final TextEditingController numCuentaController = TextEditingController();
  String? tipoBanco;
  String? tipoCuenta;
  final TextEditingController correoController = TextEditingController();

  final List<String> bancosChile = [
    'Banco de Chile',
    'Banco Estado',
    'Banco Falabella',
    'Banco Santander Chile',
    'Banco BCI',
    'Banco Itaú Chile',
    'Banco Scotiabank Chile',
    'Banco Security',
    'Banco Corpbanca',
    'Banco Ripley',
    'Banco Internacional',
    'Banco Consorcio',
    'Banco Paris',
    'Banco CrediChile'
  ];
  final List<String> tipodeCuenta = [
    'Cuenta Corriente',
    'Cuenta Vista',
    'Cuenta Rut',
    'Chequera Electronica',
  ];

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          width: screenSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Icon(
                    Icons.arrow_back,
                    size: 35,
                    color: AppColors.textColor,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      color: AppColors.colorSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Center(
                          child: Text(
                        'Datos Proveedor',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                    ),
                    TextField(
                      style: const TextStyle(color: AppColors.textColor),
                      controller: nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre *',
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
                    ),
                    TextField(
                      style: const TextStyle(color: AppColors.textColor),
                      controller: celularController,
                      decoration: const InputDecoration(
                        labelText: 'Celular',
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
                    ),
                    TextField(
                      style: const TextStyle(color: AppColors.textColor),
                      controller: direccionController,
                      decoration: const InputDecoration(
                        labelText: 'Direccion',
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
                    ),
                    TextField(
                      style: const TextStyle(color: AppColors.textColor),
                      controller: paginaController,
                      decoration: const InputDecoration(
                        labelText: 'Pagina web',
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
                    ),
                    TextField(
                      style: const TextStyle(color: AppColors.textColor),
                      controller: rutController,
                      decoration: const InputDecoration(
                        labelText: 'Rut',
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
                    ),
                    TextField(
                      style: const TextStyle(color: AppColors.textColor),
                      controller: correoController,
                      decoration: const InputDecoration(
                        labelText: 'Correo',
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      color: AppColors.colorSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Center(
                          child: Text(
                        'Datos transferencia',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                    ),
                    DropdownButton<String?>(
                      dropdownColor: AppColors.colorSecondary,
                      value: tipoBanco,
                      onChanged: (newValue) {
                        setState(() {
                          tipoBanco = newValue!;
                        });
                      },
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Selecciona un Banco',
                              style: TextStyle(color: AppColors.textColor)),
                        ),
                        ...bancosChile.map((value) {
                          return DropdownMenuItem<String?>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(
                                    color: AppColors.textColor)),
                          );
                        }),
                      ],
                      hint: const Text('Selecciona un banco',
                          style: TextStyle(color: AppColors.textColor)),
                    ),
                    DropdownButton<String?>(
                      dropdownColor: AppColors.colorSecondary,
                      value: tipoCuenta,
                      onChanged: (newValue) {
                        setState(() {
                          tipoCuenta = newValue!;
                        });
                      },
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text(
                            'Selecciona un Tipo de Cuenta',
                            style: TextStyle(color: AppColors.textColor),
                          ),
                        ),
                        ...tipodeCuenta.map((value) {
                          return DropdownMenuItem<String?>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(
                                    color: AppColors.textColor)),
                          );
                        }),
                      ],
                      hint: const Text('Selecciona Tipo de Cuenta'),
                    ),
                    TextField(
                      style: const TextStyle(color: AppColors.textColor),
                      controller: numCuentaController,
                      decoration: const InputDecoration(
                        labelText: 'Número de Cuenta',
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
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        await _insertProveedor();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.colorSecondary)),
                      child: const Text(
                        'Agregar Proveedor',
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

  Future<void> _insertProveedor() async {
    final nombre = nombreController.text;
    final direccion = direccionController.text;
    final celular = celularController.text;
    final pagina = paginaController.text;
    final rut = rutController.text;
    final correo = correoController.text;
    final numCuenta = numCuentaController.text;

    if (nombre.isNotEmpty) {
      final proveedor = Proveedor(
          nombre: nombre,
          celular: celular,
          direccion: direccion,
          rut: rut,
          paginaWeb: pagina,
          correo: correo,
          banco: tipoBanco,
          numCuenta: numCuenta,
          tipoCuenta: tipoCuenta);

      await ProveedorProvider().insertProveedor(proveedor);
      setState(() {
        nombreController.clear();
        direccionController.clear();
        celularController.clear();
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
        Functions().mostrarSnackbar('Proveedor agregado', context);
      });
    } else {
      Functions().mostrarSnackbar('Agregar agregado', context);
    }
  }
}
