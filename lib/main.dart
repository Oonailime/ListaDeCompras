import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Lista de compras",
    theme: ThemeData(
      brightness: Brightness.light,
    ),
    home: HomePage(),
  ));
}

class Produto {
  double preco;
  String nomeProduto;

  Produto({this.nomeProduto = '', this.preco = 0.0});
}
double TotalPreco(List<Produto> produto, int tamanho){
  double soma = 0;
  for(int i = 0; i<tamanho;i++){
    soma += produto[i].preco;
  }
  return soma;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Produto> _compras = [];
  double _totalPreco = 0;

  @override
  void initState() {
    super.initState();
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
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(_compras[index].nomeProduto),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  
                    Text('${_compras[index].nomeProduto}'),
                    Text('\$ ${_compras[index].preco.toStringAsFixed(2)}')

                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      _compras.removeAt(index);
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
              Produto novoProduto = Produto(); // Criando um novo produto vazio

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text("Adicione um produto"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Digite o NOME do produto',
                      ),
                      onChanged: (String value) {
                        novoProduto.nomeProduto = value; // Atualiza o nome do produto
                      },
                    ),
                    SizedBox(height: 12),
                    
                    SizedBox(
                      width: 140,
                      child: TextField(
                        decoration: InputDecoration(
                          
                          border: OutlineInputBorder(),
                          hintText: 'Digite o PREÇO',
                          
                          
                        ),
                        
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (String value) {
                          
                          novoProduto.preco = double.tryParse(value) ?? 0.0; // Atualiza o preço do produto
                          
                          
                        },
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _compras.add(novoProduto); // Adiciona o novo produto à lista
                        _totalPreco = TotalPreco(_compras, _compras.length); // Atualiza o preço total da lista
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Adicionar'),
                  )
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        
        
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.grey[800],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'R\$ ${_totalPreco}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    
    );
  }
}
