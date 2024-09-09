import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroUserPage extends StatefulWidget {
  @override
  _CadastroUserPageState createState() => _CadastroUserPageState();
}

class _CadastroUserPageState extends State<CadastroUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final String jwtToken = 's234fddfs2';


  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String username = _usernameController.text;
      String password = _passwordController.text;

      // Requisição POST ao backend
      final url = Uri.parse('http://localhost:3025/users');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken', // Incluindo o token JWT
        },
        body: jsonEncode(<String, String>{
          'name': username,
          'email': email,
          'password': password,
        }),
      );

      // Verificando a resposta do servidor
      if (response.statusCode == 200) {
        // Sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário cadastrado com sucesso!')),
        );
      } else if (response.statusCode == 400) {
        // Email já existente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email já cadastrado.')),
        );
      } else {
        // Outro erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar o usuário.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email',
                style: TextStyle(fontSize: 16, color: Colors.purple),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Digite seu e-mail',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu e-mail';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Nome de Usuário',
                style: TextStyle(fontSize: 16, color: Colors.purple),
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Digite seu nome de usuário',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome de usuário';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Senha',
                style: TextStyle(fontSize: 16, color: Colors.purple),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Digite sua senha',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40, width: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.purple,
                    backgroundColor: Colors.yellow,
                  ),
                  child: Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
