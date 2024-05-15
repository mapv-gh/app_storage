import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Functions {
  String revisarMes(String mes) {
    switch (mes) {
      case 'January':
        return '01';
      case 'February':
        return '02';
      case 'March':
        return '03';
      case 'April':
        return '04';
      case 'May':
        return '05';
      case 'June':
        return '06';
      case 'July':
        return '07';
      case 'August':
        return '08';
      case 'September':
        return '09';
      case 'October':
        return '10';
      case 'November':
        return '11';
      case 'December':
        return '12';
      default:
        return '';
    }
  }

  String formatPrecio(int precio) {
    final formatoPesosChilenos = NumberFormat.currency(
      locale: 'es_CL',
      symbol: '',
      decimalDigits: 0,
    );
    return formatoPesosChilenos.format(precio);
  }

  void mostrarSnackbar(String mensaje, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(mensaje),
      ),
    );
  }
}
