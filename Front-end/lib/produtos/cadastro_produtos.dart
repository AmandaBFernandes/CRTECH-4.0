import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Produto {
  int? id;
  String? nome;
  double? preco;
  String? descricao;
  String? imagem;
  String? categoria;
  int? quantidade;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
        ),
      ),
      home: const PaginaCadastroProdutos(),
    );
  }
}

class PaginaCadastroProdutos extends StatefulWidget {
  const PaginaCadastroProdutos({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ConteudoPagina();
  }
}

Future<void> cadastrarProduto(String? nome, double? preco, String? descricao,
    String? imagem, String? categoria, int? quantidade, context) async {
  if (nome == null ||
      descricao == null ||
      preco == null ||
      quantidade == null ||
      categoria == null ||
      imagem == null) {
    const snackBar = SnackBar(
      content: Text(
          'Por favor, preencha todas informações para cadastrar o produto.',
          style: TextStyle(color: Color.fromRGBO(40, 40, 40, 1))),
      duration: Duration(seconds: 4),
      backgroundColor: Color.fromRGBO(233, 213, 2, 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } else if (nome.isEmpty ||
      descricao.isEmpty ||
      categoria.isEmpty ||
      preco.isNaN ||
      quantidade.isNaN ||
      imagem.isEmpty) {
    const snackBar = SnackBar(
      content: Text(
          'Por favor, preencha todas informações para cadastrar o produto.',
          style: TextStyle(color: Color.fromRGBO(40, 40, 40, 1))),
      duration: Duration(seconds: 4),
      backgroundColor: Color.fromRGBO(233, 213, 2, 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } else {
    await http
        .post(Uri.parse('http://localhost:8000/api/produtos'),
            headers: <String, String>{'Content-type': 'application/json'},
            body: jsonEncode(<String, dynamic>{
              'nome': nome,
              'preco': preco,
              'descricao': descricao,
              'imagem': imagem,
              'categoria': categoria,
              'quantidade': quantidade
            }))
        .then((value) => {
              if (value.statusCode == 201)
                {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Item cadastrado com sucesso.'),
                    duration: Duration(seconds: 4),
                    backgroundColor: Colors.green,
                  ))
                }
              else
                {throw Error}
            })
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Ocorreu um erro ao registrar o produto.'),
        duration: Duration(seconds: 4),
        backgroundColor: Colors.red,
      ));
    });
  }
}

Future<List<Produto>> selecionarProdutosGamer() async {
  var retorno = await http.get(Uri.parse(' http://localhost:8000/api/produtos?categoria=gamer'));
  var dados = jsonDecode(retorno.body);
  List<Produto> produtos = [];
  for (var obj in dados) {
    Produto produto = Produto();
    produto.id = obj["id"];
    produto.nome = obj["nome"];
    produto.descricao = obj["descricao"];
    produto.preco = obj["preco"];
    produto.quantidade = obj["quantidade"];
    produto.imagem = obj["imagem"];
    produtos.add(produto);
  }
  return produtos;
}

Future<List<Produto>> selecionarProdutosHardware() async {
  var retorno =
      await http.get(Uri.parse(' http://localhost:8000/api/produtos?categoria=hardware'));
  var dados = jsonDecode(retorno.body);
  List<Produto> produtos = [];
  for (var obj in dados) {
    Produto produto = Produto();
    produto.id = obj["id"];
    produto.nome = obj["nome"];
    produto.descricao = obj["descricao"];
    produto.preco = obj["preco"];
    produto.quantidade = obj["quantidade"];
    produto.imagem = obj["imagem"];
    produtos.add(produto);
  }
  return produtos;
}

Future<List<Produto>> selecionarProdutosRede() async {
  var retorno = await http.get(Uri.parse(' http://localhost:8000/api/produtos?categoria=rede'));
  var dados = jsonDecode(retorno.body);
  List<Produto> produtos = [];
  for (var obj in dados) {
    Produto produto = Produto();
    produto.id = obj["id"];
    produto.nome = obj["nome"];
    produto.descricao = obj["descricao"];
    produto.preco = obj["preco"];
    produto.quantidade = obj["quantidade"];
    produto.imagem = obj["imagem"];
    produtos.add(produto);
  }
  return produtos;
}

Future<void> apagarProduto(int id) async {
  await http.delete(
    Uri.parse('http://localhost:8000/api/produtos/$id'),
    headers: <String, String>{'Content-type': 'application/json'},
  );
}

Future<void> atualizarProduto(int id, String novoNome, double novoPreco,
    String novaDescricao, String novaImagem, int novaQuantidade) async {
  final String apiUrl =
      'http://localhost:8000/api/produtos/$id'; // URL do seu endpoint

  final response = await http.put(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'nome': novoNome,
      'preco': novoPreco,
      'descricao': novaDescricao,
      'imagem': novaImagem,
      'quantidade': novaQuantidade,
    }),
  );

  if (response.statusCode == 200) {
    // Produto atualizado com sucesso
    print('Produto atualizado com sucesso.');
  } else {
    // Falha ao atualizar o produto
    throw Exception('Falha ao atualizar o produto.');
  }
}

class ConteudoPagina extends State {
  String? nome;
  String? descricao;
  double? preco;
  int? quantidade;
  String? imagem;
  String? categoria;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text("Cadastro de Produtos"),
      ),
      body: Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Digite um nome',
                      ),
                      onChanged: (valor) {
                        setState(() {
                          nome = valor;
                        });
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Digite um categoria',
                      ),
                      onChanged: (valor) {
                        setState(() {
                          categoria = valor;
                        });
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Digite uma descrição',
                      ),
                      onChanged: (valor) {
                        setState(() {
                          descricao = valor;
                        });
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Digite um preço',
                      ),
                      onChanged: (valor) {
                        setState(() {
                          preco = double.tryParse(valor);
                        });
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Digite uma quantidade',
                      ),
                      onChanged: (valor) {
                        setState(() {
                          quantidade = int.tryParse(valor);
                        });
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Digite o endereço da imagem',
                      ),
                      onChanged: (valor) {
                        setState(() {
                          imagem = valor;
                        });
                      },
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          cadastrarProduto(nome, preco, descricao, imagem,
                              categoria, quantidade, context);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.pink,
                          fixedSize: const Size(210, 20)),
                      child: const Text("Cadastrar Produto"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: const TabBar(
                      indicator: BoxDecoration(
                        color: Colors.pink,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.pink,
                            width: 2.0,
                          ),
                        ),
                      ),
                      tabs: [
                        Tab(text: 'Gamer'),
                        Tab(text: 'Rede'),
                        Tab(text: 'Hardware'),
                      ],
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.pink,
                    ),
                    body: TabBarView(
                      children: [
                        _buildProdutoList(
                            selecionarProdutosGamer, apagarProduto),
                        _buildProdutoList(
                            selecionarProdutosRede, apagarProduto),
                        _buildProdutoList(
                            selecionarProdutosHardware, apagarProduto),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProdutoList(Future<List<Produto>> Function() fetchProdutos,
      Future<void> Function(int id) deletarProdutos) {
    return FutureBuilder(
      future: fetchProdutos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }
        return ListView.builder(
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Card(
                elevation: 3,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    "Nome: ${snapshot.data?[index].nome}",
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    "ID: ${snapshot.data?[index].id}",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          setState(() {
                            _mostrarDetalhesProduto(
                                context, snapshot.data![index]);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            int? id = snapshot.data![index].id;
                            deletarProdutos(id!);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            _atualizarProduto(context, snapshot.data![index]);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _mostrarDetalhesProduto(BuildContext context, Produto produto) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Detalhes do Produto"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ID: ${produto.id}"),
              Text("Nome: ${produto.nome}"),
              Text("Descrição: ${produto.descricao}"),
              Text("Preço: ${produto.preco?.toStringAsFixed(2) ?? 'N/A'}"),
              Text("Quantidade: ${produto.quantidade}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }
}

Future<void> _atualizarProduto(BuildContext context, Produto produto) async {
  String? novoNome;
  double? novoPreco;
  String? novaDescricao;
  String? novaImagem;
  int? novaQuantidade;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Atualizar Produto"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ID: ${produto.id}"),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Digite um novo Nome',
              ),
              onChanged: (valor) {
                novoNome = valor;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Digite um novo Preço',
              ),
              onChanged: (valor) {
                novoPreco = double.tryParse(valor);
              },
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Digite uma nova Descrição',
              ),
              onChanged: (valor) {
                novaDescricao = valor;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Digite uma nova Imagem',
              ),
              onChanged: (valor) {
                novaImagem = valor;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Digite uma nova Quantidade',
              ),
              onChanged: (valor) {
                novaQuantidade = int.tryParse(valor);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (novoNome != null &&
                  novoPreco != null &&
                  novaDescricao != null) {
                // Chama o método de atualização aqui
                atualizarProduto(produto.id!, novoNome!, novoPreco!,
                    novaDescricao!, novaImagem!, novaQuantidade!);
                Navigator.of(context).pop();
              }
            },
            child: const Text("Atualizar"),
          ),
        ],
      );
    },
  );
}
