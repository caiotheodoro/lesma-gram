import 'package:flutter/material.dart';
import 'package:frontend/resources/ApiMethods.dart';
import 'package:frontend/resources/AuthMethods.dart';
import 'package:frontend/utils/colors.dart'; // Certifique-se de importar o AuthMethods corretamente
import 'package:frontend/widgets/follow_button.dart';
import 'package:frontend/responsive/mobile_screen_layout.dart';
import 'package:frontend/responsive/web_screen_layout.dart';
import 'package:frontend/responsive/responsive_layout_screen.dart';
import 'package:frontend/widgets/text_field_input.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({Key? key}) : super(key: key);

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  var userDetails;
  var passwordCurrent;
  TextEditingController _idController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordCurrentController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isAnonymous = false;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    var userDetails = await AuthMethods().getUserDetail();
    var userSettings = await ApiMethods().getUserSettings(userDetails.id);
    setState(() {
      _idController.text = userDetails.id;
      _nameController.text = userDetails.name!;
      passwordCurrent = userDetails.password;
      _emailController.text = userDetails.email;
      _isAnonymous = userSettings.isAnonymous;
    });
  }

  void updateUser() async {
    String id = _idController.text;
    String name = _nameController.text;
    String email = _emailController.text;
    String currentPassword = _passwordCurrentController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome é obrgatório')),
      );
      return;
    } if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email é obrgatório')),
      );
      return;
    } if ((password.isNotEmpty && confirmPassword.isNotEmpty) && currentPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha atual é obrgatório')),
      );
      return;
    } if ((password.isEmpty && confirmPassword.isEmpty) && currentPassword.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nova senha é obrigatória')),
      );
      return;
    }
    if (password == confirmPassword) {
      var updated = await ApiMethods()
          .updateUser(id, name, email, currentPassword, password, _isAnonymous);

      if (updated == "Sucesso") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Suas informações foram editadas com sucesso'),
          ),
        );
      } else if (updated == "Senha incorreta") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha atual incorreta')),
        );
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível editar suas informações'),
          ),
        );
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar usuário'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFieldInput(
              hintText: 'Nome',
              textEditingController: _nameController,
              textInputType: TextInputType.name,
            ),
            const SizedBox(
              height: 12,
            ),
            TextFieldInput(
              hintText: 'Email',
              textEditingController: _emailController,
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 12,
            ),
            TextFieldInput(
              hintText: 'Senha atual',
              textEditingController: _passwordCurrentController,
              textInputType: TextInputType.text,
              isPass: true,
            ),
            const SizedBox(
              height: 12,
            ),
            TextFieldInput(
              hintText: 'Nova senha',
              textEditingController: _passwordController,
              textInputType: TextInputType.text,
              isPass: true,
            ),
            const SizedBox(
              height: 12,
            ),
            TextFieldInput(
              hintText: 'Confirmar nova senha',
              textEditingController: _confirmPasswordController,
              textInputType: TextInputType.text,
              isPass: true,
            ),
            const SizedBox(
              height: 12,
            ),
            SwitchListTile(
              title: const Text('Perfil Anônimo'),
              value: _isAnonymous,
              onChanged: (bool value) {
                setState(() {
                  _isAnonymous = value;
                });
              },
              activeColor:
                  Colors.green, // Add this line to set the active color
              inactiveThumbColor:
                  Colors.red, // Add this line to set the inactive thumb color
              inactiveTrackColor: Colors.red.withOpacity(
                  0.5), // Add this line to set the inactive track color
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                updateUser();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Atualizar',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
