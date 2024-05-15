import 'package:app_storage/pages/articulos_page.dart';
import 'package:flutter/material.dart';
import 'package:app_storage/pages/ventas_page.dart';
import 'package:app_storage/pages/proveedores_page.dart';

class Routes extends StatelessWidget {
  final int index;
  const Routes({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    List<Widget> myList = [
      const ArticulosPage(),
      const VentasPage(),
      const ProveedoresPage()
    ];
    return myList[index];
  }
}
