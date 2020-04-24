import 'package:flutter/material.dart';
import 'client_model.dart';
import 'database.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatelessWidget {
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Clientes',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Clientes'),
      );
    }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  List<dynamic> _clientes = [];

  List<Widget> get _widgets =>
    _clientes.map((cliente) => clientesWidget(cliente)).toList();

    Widget clientesWidget(Cliente cliente) {
    return Dismissible(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Text(cliente.nome),
              Icon(cliente.marcado == true
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked),
            ],
          ), onPressed: () {},
        ),
      ), key: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView(
        children: _widgets,
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle_outline),
        onPressed: () {
          _addCliente(context);
        },
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
}