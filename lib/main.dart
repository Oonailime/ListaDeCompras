import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Lista de compras",
    theme: ThemeData(
      brightness: Brightness.dark, 
      
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

  final List _compras = [];
  String _input = "";  

 
  
  @override
  void initState() {
    super.initState();
    _compras.add('Produto 1');
    _compras.add('Produto 2');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de compras'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _compras.length,
        itemBuilder: (BuildContext context, int index){
          return Dismissible(
            key: Key(_compras[index]),
            child: Card(
              shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
              ),
              child: ListTile(
                title: Text(_compras[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: (){
                    setState(() {
                      _compras.removeAt(index);
                    });
                  },
                ),
                ),
                ),
           );
        }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(
              context: context, 
              builder: (BuildContext context){
                return AlertDialog(
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                    ),
                  title: Text("Adicione um produto"),
                  content: TextField(
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Digite o nome do produto',
            ),
                    onChanged: (String value){
                      _input = value;
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: (){
                        setState(() {
                          _compras.add(_input);
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('Adicionar')
                    )
                  ],
                );
              });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          )
        
        ),
    );
  }
}
