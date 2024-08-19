import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/resources/AuthMethods.dart';
import 'package:frontend/responsive/mobile_screen_layout.dart';
import 'package:frontend/responsive/web_screen_layout.dart';
import 'package:frontend/screens/add_post_screen.dart';
import 'package:frontend/screens/feed_screen.dart';
import 'package:frontend/screens/likes_screen.dart';
import 'package:frontend/screens/profile_screen.dart';
import 'package:frontend/screens/search_screen.dart';
import 'package:frontend/screens/signup_screen.dart';
import 'package:frontend/screens/update_user_screen.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/globals.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/widgets/text_field_input.dart';

import '../responsive/responsive_layout_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    setState(() {
      _isLoading = false;
      homeScreenItems = [
        FeedScreen(),
        SearchScreen(),
        AddPostScreen(),
        LikesScreen(),
        ProfileScreen(
          id: AuthMethods().getIdUserAuth(),
        ),
        UpdateUserScreen(),
      ];
    });
    if (res == "success") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
          (route) => false);
      ;
    } else {
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            //SVG image
            if (MediaQuery.of(context).size.height > 500)
              SvgPicture.asset(
                'assets/logo.svg',
                height: 80,
              ),

            const SizedBox(
              height: 32,
            ),

            const Text(
              "Bem vindo!",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 32,
            ),

            //text field input for email
            TextFieldInput(
                hintText: 'E-mail',
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress),

            const SizedBox(
              height: 24,
            ),
            //text field input for password
            TextFieldInput(
              hintText: 'Senha',
              textEditingController: _passwordController,
              textInputType: TextInputType.text,
              isPass: true,
            ),
            const SizedBox(
              height: 24,
            ),

            //button login
            InkWell(
              onTap: loginUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    color: yellowColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)))),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: blackColor,
                      ))
                    : const Text(
                        "Entrar",
                        style: TextStyle(
                            color:
                                blackColor,
                                fontWeight: FontWeight.bold), // Set the foreground color to blackColor
                      ),
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return SignupScreen();
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
                        borderRadius: BorderRadius.all(Radius.circular(4)))),
                child: _isLoading
                    ? const Center(
                    child: CircularProgressIndicator(
                      color: blackColor,
                    ))
                    : const Text(
                  "Cadastre-se",
                  style: TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Flexible(child: Container(), flex: 2),

            //transition to login
            Container(
              child: Text(""),
            )
          ],
        ),
      ),
    ));
  }
}
