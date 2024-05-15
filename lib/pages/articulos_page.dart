// home_page.dart
import 'package:app_storage/provider/articulo_provider.dart';
import 'package:app_storage/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:app_storage/models/articulo.dart';
import 'package:app_storage/pages/detalle_articulo.dart';
import 'package:app_storage/provider/provider.dart';
import 'package:app_storage/pages/add_articulo_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ArticulosPage extends StatefulWidget {
  const ArticulosPage({super.key});

  @override
  State<ArticulosPage> createState() => _ArticulosPageState();
}

class _ArticulosPageState extends State<ArticulosPage> {
  final dbHelper = DatabaseHelper();
  TextEditingController searchController = TextEditingController();
  List<Articulo> articulos = [];

  @override
  void initState() {
    super.initState();
    _cargarArticulos();
  }

  Future<void> _cargarArticulos() async {
    final listaArticulos = await ArticuloProvider().getArticulos();
    setState(() {
      articulos = listaArticulos;
    });
  }

  Future<void> _buscarArticulos(String query) async {
    final resultados = await ArticuloProvider().buscarArticulos(query);
    setState(() {
      articulos = resultados;
    });
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
              margin: const EdgeInsets.all(7),
              child: TextField(
                style:
                    const TextStyle(color: AppColors.textColor, fontSize: 25),
                cursorColor: AppColors.textColor,
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Buscar Articulo',
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
                  _buscarArticulos(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: articulos.length,
                itemBuilder: (context, index) {
                  final articulo = articulos[index];
                  return Container(
                    decoration: const BoxDecoration(
                        color: AppColors.colorSecondary,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        )),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(articulo.nombre.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 22,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w600)),
                      leading: Text(
                        '#${articulo.id.toString()}',
                        style: const TextStyle(
                            fontSize: 25,
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'Stock:${articulo.stock.toString()}',
                        style: const TextStyle(
                            color: AppColors.textColor, fontSize: 18),
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
                                builder: (context) => DetalleArticulo(
                                      id: articulo.id.toString(),
                                    )));
                        if (respuesta != null) {
                          setState(() {
                            _cargarArticulos();
                          });
                        }
                      },
                    ),
                  );
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
              MaterialPageRoute(builder: (context) => const AddArticulo()));
          if (respuesta != null) {
            setState(() {
              _cargarArticulos();
            });
          }
        },
        backgroundColor: AppColors.colorSecondary,
        child: Icon(
          MdiIcons.plus,
          color: AppColors.textColor,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
