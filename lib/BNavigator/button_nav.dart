import 'package:app_storage/util/theme.dart';
import 'package:flutter/material.dart';

class BNavigator extends StatefulWidget {
  final Function currentIndex;
  const BNavigator({super.key, required this.currentIndex});

  @override
  State<BNavigator> createState() => _BNavigatorState();
}

class _BNavigatorState extends State<BNavigator> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.textColor,
      iconSize: 30,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      currentIndex: index,
      backgroundColor: AppColors.colorSecondary,
      onTap: (int i) {
        setState(() {
          index = i;
          widget.currentIndex(i);
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.inbox_outlined),
          label: 'Productos',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_outlined), label: 'Ventas'),
        BottomNavigationBarItem(
          icon: Icon(Icons.house_siding_sharp),
          label: 'Proveedores',
        )
      ],
    );
  }
}
