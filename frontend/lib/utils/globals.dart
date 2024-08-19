import 'package:flutter/material.dart';
import 'package:frontend/resources/AuthMethods.dart';
import 'package:frontend/screens/add_post_screen.dart';
import 'package:frontend/screens/feed_screen.dart';
import 'package:frontend/screens/likes_screen.dart';
import 'package:frontend/screens/profile_screen.dart';
import 'package:frontend/screens/search_screen.dart';
import 'package:frontend/screens/update_user_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  LikesScreen(),
  ProfileScreen (
    id: AuthMethods().getIdUserAuth(),
  ),
  UpdateUserScreen(),
];
