import 'package:app_storage/models/proveedor.dart';
import 'package:app_storage/provider/proveedor_provider.dart';
import 'package:app_storage/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:app_storage/provider/provider.dart';

class DetalleProveedor extends StatefulWidget {
  final String id;
  const DetalleProveedor({
    super.key,
    required this.id,
  });

  @override
  State<DetalleProveedor> createState() => _DetalleProveedorState();
}

class _DetalleProveedorState extends State<DetalleProveedor> {
  late String proveedorId;
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    proveedorId = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.colorPrimary,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: Icon(
                  Icons.arrow_back,
                  size: 35,
                  color: AppColors.textColor,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              color: Colors.black,
            ),
            FutureBuilder<Proveedor?>(
              future: ProveedorProvider()
                  .getProveedorPorId(int.tryParse(proveedorId) ?? 0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final proveedor = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Datos del Proveedor',
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 30,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width,
                        child: Card(
                          color: AppColors.colorSecondary,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '#${proveedor!.id} ${proveedor.nombre.toUpperCase()}',
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 30,
                                  ),
                                ),
                                Text(
                                  'Celular: ${proveedor.celular!}',
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Dirección: ${proveedor.direccion!}',
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Correo: ${proveedor.correo!}',
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Pagina web: ${proveedor.paginaWeb!}',
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Datos de Transferencia',
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 30,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width,
                        child: Card(
                          color: AppColors.colorSecondary,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  proveedor.banco!,
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  proveedor.tipoCuenta!,
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Rut: ${proveedor.rut!}',
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'N° Cuenta: ${proveedor.numCuenta!}',
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
