import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/models/PostWithUser.dart';
import 'package:frontend/resources/AuthMethods.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/globals.dart';
import 'package:frontend/widgets/post_card.dart';
import 'package:frontend/resources/ApiMethods.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<PostWithUser>> _postsFuture;
  String? authUserId;

  @override
  void initState() {
    super.initState();
    _postsFuture = Future.value([]);
    fetchData();
  }

  Future<void> fetchData() async {
    authUserId = await AuthMethods().getIdUserAuth();
    _postsFuture = ApiMethods().getPosts(authUserId!);
    setState(() {});
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _postsFuture = ApiMethods().getPosts(authUserId!);
    });
  }

  void _reloadAfterDeletion() {
    setState(() {
      _postsFuture = ApiMethods().getPosts(authUserId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/logo.svg',
                height: 32,
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.messenger_outline,
                    color: primaryColor,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: FutureBuilder(
          future: _postsFuture,
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text('An error occurred.'),
              );
            }

            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No data available.'),
              );
            }

            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (ctx, index) {
                final data = posts[index];
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: width > webScreenSize ? width * 0.3 : 0,
                    vertical: width > webScreenSize ? 15 : 0,
                  ),
                  child: PostCard(
                    data: data,
                    onPostDeleted: _reloadAfterDeletion,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
