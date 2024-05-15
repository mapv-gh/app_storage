import 'package:app_storage/pages/detalle_proveedor.dart';
import 'package:app_storage/provider/articulo_provider.dart';
import 'package:app_storage/provider/compra_provider.dart';
import 'package:app_storage/provider/proveedor_provider.dart';
import 'package:app_storage/util/theme.dart';
import 'package:app_storage/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:app_storage/models/articulo.dart';
import 'package:app_storage/models/compra.dart';
import 'package:app_storage/pages/add_compra.dart';
import 'package:app_storage/provider/provider.dart';

class DetalleArticulo extends StatefulWidget {
  final String id;
  const DetalleArticulo({
    super.key,
    required this.id,
  });

  @override
  State<DetalleArticulo> createState() => _DetalleArticuloState();
}

class _DetalleArticuloState extends State<DetalleArticulo> {
  late String articuloId;
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    articuloId = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Card(
              color: AppColors.colorSecondary,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Image.asset(
                              "assets/images/nodispo.jpg",
                              width: 150,
                              height: 150,
                            )),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          flex: 4,
                          child: FutureBuilder<Articulo?>(
                            future: ArticuloProvider()
                                .getArticuloById(int.tryParse(widget.id) ?? 0),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final articulo = snapshot.data;
                                return Text(
                                  '#${articulo!.id} ${articulo.nombre.toUpperCase()}',
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Descripcion:',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    FutureBuilder<Articulo?>(
                      future: ArticuloProvider()
                          .getArticuloById(int.tryParse(widget.id) ?? 0),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final articulo = snapshot.data;
                          String? nombreArticulo;
                          if (articulo?.descripcion != null) {
                            nombreArticulo = articulo?.descripcion;
                          } else {
                            nombreArticulo = 'Sin descripcion.';
                          }
                          return Text(
                            nombreArticulo!,
                            style: const TextStyle(
                              color: AppColors.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.colorSecondary)),
                    onPressed: () async {
                      var respuesta = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCompra(id: widget.id)));
                      if (respuesta != null) {
                        setState(() {});
                      }
                    },
                    child: const Text('Agregar compra',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w600,
                        ))),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Nombre',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: AppColors.textColor),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Cantidad',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: AppColors.textColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Precio',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: AppColors.textColor),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Compra>>(
                future: _getPrecios(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final precios = snapshot.data!;
                    if (precios.isEmpty) {
                      return const Center(
                        child: Text(
                            'No hay precios disponibles para este artículo.'),
                      );
                    } else {
                      return _buildPreciosList(precios);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Compra>> _getPrecios() async {
    return await CompraProvider()
        .getPreciosPorArticulo(int.tryParse(widget.id));
  }

  Widget _buildPreciosList(List<Compra> precios) {
    return ListView.builder(
      itemCount: precios.length,
      itemBuilder: (context, index) {
        final precio = precios[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: const BoxDecoration(
              color: AppColors.colorSecondary,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              )),
          child: ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetalleProveedor(id: precio.idProveedor.toString()))),
            title: FutureBuilder<String>(
              future: ProveedorProvider()
                  .getNombreProveedorPorId(precio.idProveedor),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Cargando proveedor...');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final nombreProveedor =
                      snapshot.data ?? 'Proveedor no encontrado';
                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          nombreProveedor,
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            '${precio.cantidad}',
                            style: const TextStyle(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            trailing: Text(
              '\$${Functions().formatPrecio(precio.precio)}',
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              precio.fecha,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 234, 234, 234)),
            ),
          ),
        );
      },
    );
  }
}
