// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:login_prog_app/utils/colors.dart';

class MySplashScreen extends StatelessWidget {
  const MySplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: backgroundColorl,
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: size.height * 0.53,
                width: size.width,
                decoration: BoxDecoration(
                  color: primaryColor,
                  image: DecorationImage(
                    image: AssetImage("assets/images/image.png"),
                    fit: BoxFit.cover, // Adicionei isso para ajustar a imagem
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
