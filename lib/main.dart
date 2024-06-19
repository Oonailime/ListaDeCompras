import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

final List<String> _categorias = [
  'Ferramentas',
  'Comida',
  'Eletronicos',
  'Limpeza',
  'Jogos',
  'Bebidas'
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Compras',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  get _quantidadeController => null;

  get _valorController => null;

  @override
  Widget build(BuildContext context) {
    var produtoController;
    return Scaffold(
      backgroundColor: const Color(0xffD2F8D6),
      appBar: AppBar(
        backgroundColor: const Color(0XFF11E333),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.cancel_outlined,
              color: Colors.white,
            ),
            Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const Text(
                'Novo produto',
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: produtoController,
                decoration: InputDecoration(
                    labelText: 'Nome do poduto',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _quantidadeController,
                decoration: InputDecoration(
                    labelText: 'Quantidade',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(
                    labelText: 'Valor(Unidade)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              const DropdownButtonWidget(
                categorias: [],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownButtonWidget extends StatefulWidget {
  final List<String> categorias;

  const DropdownButtonWidget({super.key, required this.categorias});

  @override
  _DropdownButtonWidgetState createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  String dropdownValue = 'Ferramentas'; // Valor inicial do dropdown

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Categorias',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: _categorias.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
