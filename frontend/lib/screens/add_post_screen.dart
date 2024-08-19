import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontend/resources/ApiMethods.dart';
import 'package:frontend/resources/AuthMethods.dart';
import 'package:frontend/responsive/mobile_screen_layout.dart';
import 'package:frontend/responsive/responsive_layout_screen.dart';
import 'package:frontend/responsive/web_screen_layout.dart';
import 'package:frontend/screens/feed_screen.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/globals.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/widgets/follow_button.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageLinkController = TextEditingController();
  String? _imageUrl;
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    userId = await AuthMethods().getIdUserAuth();
    setState(() {});
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _imageLinkController.dispose();
    super.dispose();
  }

  void _updateImagePreview() {
    setState(() {
      _imageUrl = _imageLinkController.text;
    });
  }

  void submitPost() async {
    if (_imageLinkController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        userId == null) {
      // Show error message
      return;
    }

    setState(() {
      isLoading = true;
    });

    var reponse = await ApiMethods().createPost(
        _imageLinkController.text, _descriptionController.text, userId!);

    if (reponse == "success") {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post criado com sucesso')),
      );
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível fazer o cadastro do post')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualizar publicação'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: blackColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _imageLinkController,
                        decoration: const InputDecoration(
                          labelText: 'Link da imagem',
                          border: OutlineInputBorder(),
                          filled: true, // Adiciona preenchimento
                          fillColor: tertiaryColor,
                        ),
                        onChanged: (value) {
                          _updateImagePreview();
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                          border: OutlineInputBorder(),
                          filled: true, // Adiciona preenchimento
                          fillColor: tertiaryColor,
                        ),
                        maxLines: null,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: FollowButton(
                          text: 'Adicionar',
                          backgroundColor: mobileBackgroundColor,
                          textColor: primaryColor,
                          borderColor: Colors.grey,
                          function: () {
                            isLoading ? null : submitPost();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      _imageUrl != null
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  constraints: const BoxConstraints(
                                    minHeight: 300, // Altura mínima
                                    maxHeight: 500, // Altura máxima
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 16 /
                                        9, // Ajuste a proporção conforme necessário
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.black, // Cor da borda
                                          width: 1.0, // Largura da borda
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          _imageUrl!,
                                          width: constraints.maxWidth,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                              child: Text('No image selected'),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Text('No image selected'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
