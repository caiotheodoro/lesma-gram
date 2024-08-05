part of 'posts_bloc.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostsInitialState extends PostsState {}

class PostsLoadingState extends PostsState {}

class PostsLoadedState extends PostsState {
  final List<PostModel> posts;
  const PostsLoadedState({required this.posts});
  @override
  List<Object> get props => [posts];
}

class PostsCreateLoadingState extends PostsState {}

class PostsCreateLoadedState extends PostsState {}

class PostsUpdateLoadingState extends PostsState {}

class PostsUpdateLoadedState extends PostsState {}

class PostsDeleteLoadingState extends PostsState {}

class PostsDeleteLoadedState extends PostsState {}