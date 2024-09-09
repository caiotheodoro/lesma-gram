import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/resources/AuthMethods.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome do usuário é obrigatório')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    } if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email é obrigatório')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    } if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha é obrigatório')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    } if (_confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Confirmar senha é obrigatório')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showSnackBar("As senhas não coincidem", context);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text);

    setState(() {
      _isLoading = false;
    });

    if (res == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Parabéns! Cadastro realizado com sucesso')),
      );

      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cadastrar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(),
                  flex: 2,
                ),

                if (MediaQuery.of(context).size.height > 500)
                  SvgPicture.asset(
                    'assets/logo.svg',
                    height: 80,
                  ),

                const SizedBox(
                  height: 16,
                ),

                const Text(
                  "Cadastre-se!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                //text field input for name
                TextFieldInput(
                  hintText: 'Nome completo',
                  textEditingController: _nameController,
                  textInputType: TextInputType.name,
                ),
                const SizedBox(
                  height: 8,
                ),

                //text field input for email
                TextFieldInput(
                  hintText: 'E-mail',
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress,
                ),

                const SizedBox(
                  height: 8,
                ),
                //text field input for password
                //text field input for password
                TextFieldInput(
                  hintText: 'Senha',
                  textEditingController: _passwordController,
                  textInputType: TextInputType.text,
                  isPass: true,
                ),

                const SizedBox(
                  height: 8,
                ),

                //text field input for confirming password
                TextFieldInput(
                  hintText: 'Confirmar senha',
                  textEditingController: _confirmPasswordController,
                  textInputType: TextInputType.text,
                  isPass: true,
                ),

                const SizedBox(
                  height: 16,
                ),

                //button login
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      color: yellowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text(
                            "Cadastrar",
                            style: TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const LoginScreen();
                      },
                    ));
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      color: yellowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                    child: const Text(
                      "Voltar",
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Flexible(child: Container(), flex: 2),

                Container(
                  child: Text(""),
                )
              ],
            ),
          ),
        ));
  }
}
