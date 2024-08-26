import 'package:flutter/material.dart';
import 'package:frontend/resources/ApiMethods.dart';
import 'package:frontend/responsive/mobile_screen_layout.dart';
import 'package:frontend/responsive/responsive_layout_screen.dart';
import 'package:frontend/screens/feed_screen.dart';
import 'package:frontend/screens/profile_screen.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/responsive/web_screen_layout.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  Future<List<dynamic>> fetchUsers(String query) async {
    try {
      var users = await ApiMethods().getUsersByName(query);
      if (users == null) {
        throw Exception('No users found');
      }
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Buscar usuário...',
            ),
            onFieldSubmitted: (String query) async {
              try {
                var users = await fetchUsers(query);
                if (users.isNotEmpty) {
                  setState(() {
                    isShowUsers = true;
                  });
                } else {
                  setState(() {
                    isShowUsers = false;
                  });
                }
              } catch (e) {
                print('Error: $e');
              }
            },
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder<List<dynamic>>(
              future: fetchUsers(searchController.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No users found');
                } else {
                  var users = snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index];
                      if (user == null) {
                        return const ListTile(
                          title: Text('Unknown user'),
                        );
                      }
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.grey),
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        onTap: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => const ResponsiveLayout(
                          //       mobileScreenLayout: FeedScreen(),
                          //       webScreenLayout: FeedScreen(),
                          //     ),
                          //   ),
                          // );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ResponsiveLayout(
                                mobileScreenLayout: ProfileScreen(
                                  id: Future.value(user.id),
                                ),
                                webScreenLayout: ProfileScreen(
                                  id: Future.value(user.id),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            )
          : const Center(child: Text('Nenhum usuário encontrado.')),
    );
  }
}
