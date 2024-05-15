import 'package:app_storage/BNavigator/button_nav.dart';
import 'package:app_storage/BNavigator/routes.dart';
import 'package:app_storage/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventario',
      theme: ThemeData(
        textTheme: GoogleFonts.albertSansTextTheme(),
        primaryColor: AppColors.colorPrimary,
        scaffoldBackgroundColor: AppColors.colorPrimary,
        appBarTheme: const AppBarTheme(
          actionsIconTheme: IconThemeData.fallback(),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30))),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  BNavigator? myBNB;
  @override
  void initState() {
    myBNB = BNavigator(currentIndex: (i) {
      setState(() {
        index = i;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorSecondary,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.babyBottle,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Mundo Bebe',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: myBNB,
      body: Routes(index: index),
    );
  }
}
