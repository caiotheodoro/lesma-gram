import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login_prog_app/screem/cadastro_user.dart'; // Para manipular JSON

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    Future<void> _login() async {
      final email = _emailController.text;
      final password = _passwordController.text;
      final String jwtToken = 's234fddfs2';
      final url = Uri.parse('http://localhost:3025/auth'); // Ajuste a URL conforme necessário

      try {
        final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken', // Incluindo o token JWT
        },
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
        );

        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          final token = responseData['access_token'];

          // Armazene o token e navegue para a próxima tela
          // Você pode usar um package como flutter_secure_storage para armazenar o token

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login bem-sucedido!')),
          );

          // Navegue para a tela principal ou qualquer outra tela
          //Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email ou senha incorretos')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao fazer login')),
        );
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Manchas roxas
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          // Conteúdo principal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/image.png',
                        height: 150, // ajuste o tamanho conforme necessário
                      ),
                      SizedBox(height: 32),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.amber,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.amber,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua senha';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity, // Botão com largura total
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _login();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber, // Cor do botão
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0), // Aumentar o tamanho do botão
                            textStyle: TextStyle(
                              fontSize: 18, // Tamanho do texto
                            ),
                          ),
                          child: Text('Entrar'),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity, // Botão com largura total
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CadastroUserPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber, // Cor do botão
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0), // Aumentar o tamanho do botão
                            textStyle: TextStyle(
                              fontSize: 18, // Tamanho do texto
                            ),
                          ),
                          child: Text('Cadastrar-se'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
