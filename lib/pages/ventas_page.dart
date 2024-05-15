import 'package:app_storage/models/venta.dart';
import 'package:app_storage/pages/detalle_venta.dart';
import 'package:app_storage/provider/provider.dart';
import 'package:app_storage/provider/venta_provider.dart';
import 'package:app_storage/util/theme.dart';
import 'package:app_storage/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:app_storage/pages/add_venta.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VentasPage extends StatefulWidget {
  const VentasPage({super.key});

  @override
  State<VentasPage> createState() => _VentasPageState();
}

class _VentasPageState extends State<VentasPage> {
  TextEditingController searchController = TextEditingController();
  final dbHelper = DatabaseHelper();
  List<Venta?> ventas = [];
  late String mesActual =
      Functions().revisarMes(DateFormat('MMMM').format(DateTime.now()));

  @override
  void initState() {
    super.initState();
    _cargarVentas(mesActual);
  }

  Future<void> _cargarVentas(String mes) async {
    final listaVentas = await VentaProvider().getVentas(mes);
    setState(() {
      ventas = listaVentas;
    });
  }

  Future<int> _cargarTotal(int id) async {
    return await dbHelper.getTotalPrice(id);
  }

  Future<void> _buscarVentas(String query) async {
    final venta = await VentaProvider().buscarVentas(query);
    setState(() {
      ventas = venta;
    });
  }

  Future<int> _totalMes(String mes) async {
    return await DatabaseHelper().getTotalMes(mes);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: screenSize.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: AppColors.colorSecondary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  )),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ventas del Mes',
                          style: TextStyle(
                              fontSize: 22,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w600)),
                      DropdownButton<String>(
                        style: const TextStyle(color: AppColors.textColor),
                        hint: const Text('Selecciona un Mes',
                            style: TextStyle(color: AppColors.textColor)),
                        value: mesActual,
                        underline:
                            Container(), // Esta línea oculta la línea de separación
                        dropdownColor: AppColors.colorSecondary,
                        onChanged: (selectedMes) {
                          setState(() {
                            mesActual = selectedMes!;
                            _cargarVentas(mesActual);
                            _totalMes(mesActual);
                          });
                        },
                        items: List.generate(8, (index) {
                          int numeroMes = index + 5;
                          String valorMes =
                              numeroMes.toString().padLeft(2, '0');
                          String nombreMes = DateFormat('MMMM')
                              .format(DateTime(2022, numeroMes));
                          return DropdownMenuItem(
                            value: valorMes,
                            child: Text('$nombreMes 2024'),
                          );
                        }),
                      )
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: FutureBuilder(
                        future: _totalMes(mesActual),
                        builder: (context, snapshot) {
                          final texto = snapshot.data;
                          return Text(
                            'Total Vendido: \$${Functions().formatPrecio(texto ?? 0)}',
                            style: const TextStyle(
                                fontSize: 20, color: AppColors.textColor),
                          );
                        },
                      ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(7),
              child: TextField(
                style:
                    const TextStyle(color: AppColors.textColor, fontSize: 25),
                cursorColor: AppColors.textColor,
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Buscar por Cliente',
                  labelStyle: TextStyle(color: AppColors.textColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textColor),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: AppColors.textColor,
                  ),
                ),
                onChanged: (value) {
                  _buscarVentas(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: ventas.length,
                itemBuilder: (context, index) {
                  final venta = ventas[index];
                  if (ventas.isNotEmpty) {
                    return Container(
                      decoration: const BoxDecoration(
                          color: AppColors.colorSecondary,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          )),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(venta!.nombreCliente,
                            style: const TextStyle(
                                fontSize: 22,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w600)),
                        leading: Text(
                          '#${venta.id.toString()}',
                          style: const TextStyle(
                              fontSize: 25,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          venta.fecha,
                          style: const TextStyle(color: AppColors.textColor),
                        ),
                        trailing: FutureBuilder(
                          future: _cargarTotal(venta.id!),
                          builder: (context, snapshot) {
                            final totalPrecio = snapshot.data;
                            if (totalPrecio == null) {
                              return const Text(
                                'Desconocido',
                                style: TextStyle(
                                    color: AppColors.textColor, fontSize: 15),
                              );
                            } else {
                              return Text(
                                '\$${Functions().formatPrecio(totalPrecio)}',
                                style: const TextStyle(
                                    color: AppColors.textColor, fontSize: 15),
                              );
                            }
                          },
                        ),
                        onTap: () async {
                          var respuesta = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetalleVentaPage(id: venta.id!)));
                          if (respuesta != null) {
                            setState(() {});
                          }
                        },
                        onLongPress: () {
                          mostrarConfirmacion(context, venta.id!);
                        },
                      ),
                    );
                  } else if (ventas.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Center(
                        child: Text(
                          'No hay ventas este mes.',
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Center(
                        child: Text(
                          'No hay ventas este mes.',
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          var respuesta = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddVenta()));
          if (respuesta != null) {
            setState(() {
              _cargarVentas(mesActual);
            });
          }
        },
        backgroundColor: AppColors.colorSecondary,
        child: Icon(
          MdiIcons.plus,
          color: Colors.white,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void mostrarConfirmacion(BuildContext context, int idVenta) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Venta', style: TextStyle(fontSize: 26)),
          content: const Text(
            '¿Estás seguro que quieres eliminar esta venta?',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar', style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () async {
                await VentaProvider().deleteVenta(idVenta);
                // ignore: use_build_context_synchronously

                setState(() {
                  Navigator.of(context).pop();
                  Functions().mostrarSnackbar('Venta Eliminada', context);
                  _cargarVentas(mesActual);
                });
                // Aquí puedes mostrar un mensaje o realizar alguna acción adicional
              },
              child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  child: const Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ),
          ],
        );
      },
    );
  }
}
