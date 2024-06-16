import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "Lista de compras",
    theme: ThemeData(
      brightness: Brightness.dark, 
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(secondary: Colors.brown),
    ),
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de compras'),
        centerTitle: true,
      ),
    );
  }
}
