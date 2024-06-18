import 'package:flutter/material.dart';
import 'package:lista_de_compras/app/features/main_list/main_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Lista de compras",
    theme: ThemeData(
        brightness: Brightness.dark, 
        
    ),
    home: const MainListView(),
  ));
} 


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _compras = []; // Alteração na declaração da lista

  String _input = "";

  @override
  void initState() {
    super.initState();
    _loadCompras(); // Carrega os dados ao iniciar a tela
  }

  // Método para carregar os dados salvos
  void _loadCompras() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _compras = prefs.getStringList('compras') ?? []; // Atribui diretamente à lista _compras
    });
  }

  // Método para salvar os dados
  void _saveCompras() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('compras', _compras); // Salva a lista _compras diretamente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de compras'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _compras.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(_compras[index]),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(_compras[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      _compras.removeAt(index);
                      _saveCompras(); // Salva os dados após remover um item
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text("Adicione um produto"),
                content: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Digite o nome do produto',
                  ),
                  onChanged: (String value) {
                    _input = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _compras.add(_input); // Adiciona o produto diretamente à lista _compras
                        _saveCompras(); // Salva os dados após adicionar um item
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Adicionar'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

