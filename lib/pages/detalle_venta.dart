import 'package:app_storage/models/detalle_compra.dart';
import 'package:app_storage/models/venta.dart';
import 'package:app_storage/pages/detalle_articulo.dart';
import 'package:app_storage/provider/articulo_provider.dart';
import 'package:app_storage/provider/detalle_ventas_provider.dart';
import 'package:app_storage/provider/venta_provider.dart';
import 'package:app_storage/util/theme.dart';
import 'package:app_storage/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:app_storage/provider/provider.dart';

class DetalleVentaPage extends StatefulWidget {
  final int id;
  const DetalleVentaPage({
    super.key,
    required this.id,
  });

  @override
  State<DetalleVentaPage> createState() => _DetalleVentaPageState();
}

class _DetalleVentaPageState extends State<DetalleVentaPage> {
  late int ventaId;
  Venta venta = Venta(nombreCliente: '', fecha: '');
  final dbHelper = DatabaseHelper();
  List<DetalleVenta> detallesList = [];

  @override
  void initState() {
    super.initState();
    ventaId = widget.id;
    _cargarDetalles();
    _cargaVenta();
  }

  Future<void> _cargarDetalles() async {
    final listaDetalles =
        await DetalleVentasProvider().getDetallesVentaById(ventaId);
    setState(() {
      detallesList = listaDetalles;
    });
  }

  Future<void> _cargaVenta() async {
    final ventaA = await VentaProvider().getVentaPorId(ventaId);
    setState(() {
      venta = ventaA;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 19),
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
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Información de la venta',
                style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Card(
              color: AppColors.colorSecondary,
              child: Container(
                width: screenSize.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    campoInfo('Nombre Cliente', venta.nombreCliente),
                    campoInfo('Rut', venta.rut!),
                    campoInfo('Celular', venta.celular!),
                    campoInfo('Correo', venta.correo!),
                    campoInfo('Región', venta.region!),
                    campoInfo('Dirección', venta.direccion!),
                    campoInfo('Instagram', venta.user!),
                    campoInfo('Fecha', venta.fecha),
                    Padding(
                      padding: const EdgeInsets.only(top: 19.0),
                      child: FutureBuilder(
                        future: dbHelper.getTotalPrice(venta.id ?? 0),
                        builder: (context, snapshot) {
                          final totalPrecio = snapshot.data;
                          return Text(
                            'Total: \$${Functions().formatPrecio(totalPrecio ?? 0)}',
                            style: const TextStyle(
                              fontSize: 19,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 19),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'ID',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          color: AppColors.textColor),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Nombre',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
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
                          fontSize: 19,
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
                          fontSize: 19,
                          color: AppColors.textColor),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: detallesList.length,
                itemBuilder: (context, index) {
                  final detalle = detallesList[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: const BoxDecoration(
                        color: AppColors.colorSecondary,
                        borderRadius: BorderRadius.all(
                          Radius.circular(19),
                        )),
                    child: ListTile(
                      leading: Text(
                        '#${detalle.idArticulo.toString()}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 234, 234, 234)),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 4,
                              child: FutureBuilder<String>(
                                future: ArticuloProvider()
                                    .getNombreArticuloPorId(detalle.idArticulo),
                                builder: (context, snapshot) {
                                  final nombreArticulo = snapshot.data;
                                  return Container(
                                    margin: const EdgeInsets.only(right: 30),
                                    child: Text(
                                      nombreArticulo ?? '',
                                      style: const TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                },
                              )),
                          Expanded(
                            flex: 2,
                            child: Text(
                              detalle.cantidad.toString(),
                              style: const TextStyle(
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '\$${Functions().formatPrecio(detalle.precio)}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleArticulo(
                                  id: detalle.idArticulo.toString()),
                            ));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding campoInfo(String titulo, String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$titulo: $texto',
        style: const TextStyle(
          fontSize: 19,
          color: AppColors.textColor,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 2,
      ),
    );
  }
}
