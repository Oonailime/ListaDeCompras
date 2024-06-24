import 'package:lista_de_compras/app/features/pages/splash.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lista de compras',
        theme: ThemeData(
         fontFamily: 'Roboto',
        ),
        home: const SplashView());
  }
}

void main() {
  runApp(const MyApp());
}
