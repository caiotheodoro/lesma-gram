import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post_model.dart';
import 'package:frontend/pages/bloc/posts_bloc.dart';
import 'package:http/http.dart';

class UpdateScreenPage extends StatefulWidget {
  final PostModel post;
  final void Function() refreshFn;

  const UpdateScreenPage({required this.post, required this.refreshFn, Key? key}) : super(key: key);

  @override
  _UpdateScreenPageState createState() => _UpdateScreenPageState();
}

class _UpdateScreenPageState extends State<UpdateScreenPage> {
  PostsBloc bloc = PostsBloc();
  TextEditingController idController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    idController.text = widget.post.id.toString();
    contentController.text = widget.post.content;
    imageController.text = widget.post.image;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsBloc, PostsState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is PostsUpdateLoadingState) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Please Wait'),
              content: const Text('Editing.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Okay'),
                  child: const Text('Okay'),
                ),
              ],
            ),
          );
        } else if (state is PostsUpdateLoadedState) {
          Navigator.pop(context);
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Edited.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Okay'),
                  child: const Text('Okay'),
                ),
              ],
            ),
          );
          widget.refreshFn();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("EDIT"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: "Content"),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: "Imagem"),
                ),
                ElevatedButton(
                  onPressed: () {
                    bloc.add(
                      PostsUpdateEvent(
                        PostModel(id: int.parse(idController.text), content: contentController.text, image: imageController.text, userId: 1),
                      ),
                    );
                  },
                  child: const Text("Edit"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}