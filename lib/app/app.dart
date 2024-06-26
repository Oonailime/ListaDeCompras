import 'package:flutter/material.dart';
import 'package:lista_de_compras/app/features/list_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lista de compras',
        theme: ThemeData.light(),
        home: ListaPage());
  }
}
