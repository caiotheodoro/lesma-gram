import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post_model.dart';
import 'package:frontend/pages/create_screen.dart';
import 'package:frontend/pages/update_screen.dart';

import 'bloc/posts_bloc.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({Key? key}) : super(key: key);

  @override
  _HomeScreenPageState createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  PostsBloc bloc = PostsBloc();
  var loaded = false;
  List<PostModel>? posts;

  @override
  void initState() {
    super.initState();
    bloc.add(PostsStartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsBloc(),
      child: BlocListener(
        bloc: bloc,
        listener: (context, state) {
          print(state);
          print(PostsLoadingState);
          if (state is PostsLoadingState) {
            setState(() {
              loaded = false;
            });
          } else if (state is PostsLoadedState) {
            posts = state.posts;
            setState(() {
              loaded = true;
            });
          } else if (state is PostsDeleteLoadingState) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Please Wait'),
                content: const Text('Deleting.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Okay'),
                    child: const Text('Okay'),
                  ),
                ],
              ),
            );
          } else if (state is PostsDeleteLoadedState) {
            Navigator.pop(context);
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Success'),
                content: const Text('Deleted.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Okay'),
                    child: const Text('Okay'),
                  ),
                ],
              ),
            );
            bloc.add(PostsStartEvent());
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            title: const Text('Posts', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            leading: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.black),
              onPressed: () {
              },
            ),
          ),
          body: loaded
              ? ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: posts!.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 16), // Espaçamento entre os cards
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Adicione uma imagem ou um espaço para a imagem do post
                      Image.network(
                        posts![index].image ?? 'https://www.example.com/placeholder-image.png', // URL da imagem
                        width: double.infinity,
                        height: 200, // Ajuste a altura conforme necessário
                        fit: BoxFit.cover, // Ajuste o ajuste da imagem
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Text('Erro ao carregar imagem', style: TextStyle(color: Colors.red)));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              posts![index].content,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                      // Adiciona os botões de edição e exclusão
                      ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateScreenPage(
                                    post: posts![index],
                                    refreshFn: () {
                                      bloc.add(PostsStartEvent());
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirmar Exclusão'),
                                    content: Text('Você tem certeza que deseja excluir este post?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Excluir'),
                                        onPressed: () {
                                          bloc.add(
                                            PostsDeleteEvent(posts![index]),
                                          );
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
              : const Center(child: CircularProgressIndicator()),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateScreenPage(
                    refreshFn: () {
                      bloc.add(PostsStartEvent());
                    },
                  ),
                ),
              );
            },
            backgroundColor: Colors.pink,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}