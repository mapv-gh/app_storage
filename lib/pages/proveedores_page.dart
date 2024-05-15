import 'package:app_storage/pages/detalle_proveedor.dart';
import 'package:app_storage/provider/proveedor_provider.dart';
import 'package:app_storage/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:app_storage/models/proveedor.dart';
import 'package:app_storage/pages/add_proveedor.dart';
import 'package:app_storage/provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProveedoresPage extends StatefulWidget {
  const ProveedoresPage({super.key});

  @override
  State<ProveedoresPage> createState() => _ProveedoresPageState();
}

class _ProveedoresPageState extends State<ProveedoresPage> {
  final dbHelper = DatabaseHelper();
  late TextEditingController searchController;
  List<Proveedor> proveedores = [];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _cargarProveedores();
  }

  Future<void> _cargarProveedores() async {
    final listaProveedores = await ProveedorProvider().getProveedores();
    setState(() {
      proveedores = listaProveedores;
    });
  }

  Future<void> _buscarProveedores(String query) async {
    final resultados = await ProveedorProvider().buscarProveedores(query);
    setState(() {
      proveedores = resultados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                cursorColor: AppColors.textColor,
                style:
                    const TextStyle(color: AppColors.textColor, fontSize: 25),
                controller: searchController,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textColor),
                  ),
                  labelText: 'Buscar proveedores',
                  labelStyle: TextStyle(color: AppColors.textColor),
                  suffixIcon: Icon(
                    Icons.search,
                    color: AppColors.textColor,
                  ),
                ),
                onChanged: (value) {
                  _buscarProveedores(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: proveedores.length,
                  itemBuilder: (context, index) {
                    final proveedor = proveedores[index];
                    if (proveedor.id != 0) {
                      return Container(
                        decoration: const BoxDecoration(
                            color: AppColors.colorSecondary,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            )),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ListTile(
                          title: Text(
                            '#${proveedor.id} ${proveedor.nombre}'
                                .toUpperCase(),
                            style: const TextStyle(
                                fontSize: 25,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: Icon(
                            applyTextScaling: true,
                            MdiIcons.store,
                            size: 60,
                            color: AppColors.textColor,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              MdiIcons.pen,
                              color: AppColors.textColor,
                            ),
                            onPressed: () {},
                          ),
                          onTap: () async {
                            var respuesta = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetalleProveedor(
                                          id: proveedor.id.toString(),
                                        )));
                            if (respuesta != null) {
                              setState(() {
                                _cargarProveedores();
                              });
                            }
                          },
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          var respuesta = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddProveedor()));
          if (respuesta != null) {
            setState(() {
              _cargarProveedores();
            });
          }
        },
        backgroundColor: AppColors.colorSecondary,
        child: Icon(MdiIcons.plus, color: AppColors.textColor, size: 35),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
