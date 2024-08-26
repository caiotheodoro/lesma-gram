import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/models/PostWithUser.dart';
import 'package:frontend/resources/AuthMethods.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/globals.dart';
import 'package:frontend/widgets/post_card.dart';
import 'package:frontend/resources/ApiMethods.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({Key? key}) : super(key: key);

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  late Future<List<PostWithUser>> _likedPostsFuture;
  String? authUserId;

  @override
  void initState() {
    super.initState();
    _likedPostsFuture = Future.value([]); 
    fetchLikedPosts();
  }

  Future<void> fetchLikedPosts() async {
    authUserId = await AuthMethods().getIdUserAuth();
    _likedPostsFuture = ApiMethods().getPostsByUserLiked(authUserId!);
    setState(() {});
  }

  Future<void> _refreshLikedPosts() async {
    setState(() {
      _likedPostsFuture = ApiMethods().getPostsByUserLiked(authUserId!);
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
        onRefresh: _refreshLikedPosts,
        child: FutureBuilder(
          future: _likedPostsFuture,
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
                child: Text('Você ainda não curtiu nenhum post.'),
              );
            }

            final likedPosts = snapshot.data!;
            return ListView.builder(
              itemCount: likedPosts.length,
              itemBuilder: (ctx, index) {
                final data = likedPosts[index];
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: width > webScreenSize ? width * 0.3 : 0,
                    vertical: width > webScreenSize ? 15 : 0,
                  ),
                  child: PostCard(
                    data: data,
                    onPostDeleted: _refreshLikedPosts,
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