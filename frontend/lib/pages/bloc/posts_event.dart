part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class PostsStartEvent extends PostsEvent {}

class PostStartEvent extends PostsEvent {
  final int id;
  const PostStartEvent(this.id);

  @override
  List<Object> get props => [id];
}

class PostsCreateEvent extends PostsEvent {
  final PostModel post;
  const PostsCreateEvent(this.post);
  @override
  List<Object> get props => [post];
}

class PostsUpdateEvent extends PostsEvent {
  final PostModel post;
  const PostsUpdateEvent(this.post);
  @override
  List<Object> get props => [post];
}

class PostsDeleteEvent extends PostsEvent {
  final PostModel post;
  const PostsDeleteEvent(this.post);
  @override
  List<Object> get props => [post];
}