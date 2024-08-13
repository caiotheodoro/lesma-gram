import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post_model.dart';
import 'package:frontend/pages/bloc/posts_bloc.dart';

class CreateScreenPage extends StatefulWidget {
  final void Function() refreshFn;

  const CreateScreenPage({required this.refreshFn, Key? key}) : super(key: key);

  @override
  _CreateScreenPageState createState() => _CreateScreenPageState();
}

class _CreateScreenPageState extends State<CreateScreenPage> {
  PostsBloc bloc = PostsBloc();
  TextEditingController imageController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsBloc, PostsState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is PostsCreateLoadingState) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Please Wait'),
              content: const Text('Creating.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Okay'),
                  child: const Text('Okay'),
                ),
              ],
            ),
          );
        } else if (state is PostsCreateLoadedState) {
          Navigator.pop(context);
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Created.'),
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
            title: const Text("Create"),
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
                      PostsCreateEvent(
                        PostModel(
                            id: null,
                            content: contentController.text,
                            image: imageController.text,
                            userId: 1),
                      ),
                    );
                  },
                  child: const Text("Create"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
