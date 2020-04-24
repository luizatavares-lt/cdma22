import 'package:flutter/material.dart';
import 'client_model.dart';
import 'database.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CADASTRO DE CLIENTES"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              DBProvider.db.deleteAll();
              setState(() {});
            },
          )
        ],
      ),
      body: FutureBuilder<List<Cliente>>(
        future: DBProvider.db.getAllClientes(),
        builder: (BuildContext context, AsyncSnapshot<List<Cliente>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Cliente item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    DBProvider.db.deleteCliente(item.id);
                  },
                  child: ListTile(
                    title: Text(item.nome + " " + item.sobrenome),
                    leading: Text(item.id.toString()),
                    trailing: Checkbox(
                      onChanged: (bool value) {
                        DBProvider.db.blockOrUnblock(item);
                        setState(() {});
                      },
                      value: item.marcado,
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          _addCliente(context);
        } 
      ),
    );
  }

  String _clienteNome;
  String _clienteSobrenome;

  void _addCliente(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Adicionar Tarefa"),
          actions: <Widget>[
            FlatButton(
              onPressed: () => _salvarCliente(),
              child: Text("Incluir"),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancelar"),
            ),
          ],
          content: Form(
            child: Column(children: <Widget>[
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Nome:",
                  hintText: "Insira o primeiro nome",
                ),
                onChanged: (valor) {
                  _clienteNome = valor;
                },
              ),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Sobrenome:",
                  hintText: "Insira o Sobrenome",
                ),
                onChanged: (valor) {
                  _clienteSobrenome = valor;
                },
              )
            ],),
          ) 
        );
      },
    );
  }

  _salvarCliente() async {
    Cliente cliente = Cliente(
      nome: _clienteNome,
      sobrenome: _clienteSobrenome,
      marcado: true,
    );

    await DBProvider.db.newCliente(cliente);
    setState(() => _clienteNome = '');
    setState(() => _clienteSobrenome = '');
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    DBProvider.db.initDB();
    super.initState();
  }

}