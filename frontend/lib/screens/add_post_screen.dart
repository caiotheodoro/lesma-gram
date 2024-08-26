import 'dart:io';
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
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:frontend/utils/image-api.dart';
import 'package:uuid/uuid.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? _imageFile;
  Uint8List? _webImage;
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        var f = await pickedFile.readAsBytes();
        setState(() {
          _webImage = f;
          _imageUrl = null;
          _imageLinkController.clear();
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
          _imageUrl = pickedFile.path;
          _imageLinkController.clear();
        });
      }
    }
  }

  void _updateImagePreview() {
    setState(() {
      if (_imageFile == null && _webImage == null) {
        _imageUrl = _imageLinkController.text;
      }
    });
  }

  Future<void> submitPost() async {
    if ((_imageUrl == null || _imageUrl!.isEmpty) &&
        _webImage == null &&
        _descriptionController.text.isEmpty ||
        userId == null) {
      // Show error message
      return;
    }

    setState(() {
      isLoading = true;
    });

    String imageUrlToSubmit = _imageUrl ?? '';
    if (_webImage != null) {
      final response = await UploadImageCall.call(source: _webImage);
      if (response != null) {
        print(response);
        imageUrlToSubmit = response['image']['display_url'] ?? '';
        print(imageUrlToSubmit);
      } else {
        print('Image upload failed');
      }
    }

    var response = await ApiMethods().createPost(
        imageUrlToSubmit, _descriptionController.text, userId!);

    if (response == "success") {
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
                          filled: true,
                          fillColor: tertiaryColor,
                        ),
                        onChanged: (value) {
                          _updateImagePreview();
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: Text('Upload Image'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                          border: OutlineInputBorder(),
                          filled: true,
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
                      _imageUrl != null || _webImage != null
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  constraints: const BoxConstraints(
                                    minHeight: 300,
                                    maxHeight: 500,
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: _webImage != null
                                            ? Image.memory(
                                                _webImage!,
                                                width: constraints.maxWidth,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
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
