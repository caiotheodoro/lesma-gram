import 'package:flutter/material.dart';
import 'package:frontend/models/PostWithUser.dart';
import 'package:frontend/resources/ApiMethods.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/globals.dart';
import 'package:frontend/utils/utils.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final PostWithUser data;

  const PostCard({
    required this.data,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.data.isLiked;
  }

  deletePost(String postId) async {
    try {
      await ApiMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  likePost() async {
    try {
      if (isLiked) {
        await ApiMethods().deleteLikePost(widget.data.postId, widget.data.userId);
      } else {
        await ApiMethods().likePost(widget.data.postId, widget.data.userId);
      }
      setState(() {
        isLiked = !isLiked;
      });
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                         !widget.data.isAnonymous ? widget.data.name : "Usuario Anónimo",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: [
                                'Delete',
                              ]
                                  .map(
                                    (e) => InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                        onTap: () {
                                          deletePost(
                                            widget.data.postId.toString(),
                                          );
                                          // remove the dialog box
                                          Navigator.of(context).pop();
                                        }),
                                  )
                                  .toList()),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              widget.data.image.toString(),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        color: isLiked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: likePost,
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: ' ${widget.data.content}',
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(
                        DateTime.parse(widget.data.createdAt.toString())),
                    style: const TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
