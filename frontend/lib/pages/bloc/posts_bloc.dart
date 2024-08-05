import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/models/post_model.dart';
import 'package:frontend/services/http_services.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitialState()) {
    on(postsEventControl);
  }

  Future<void> postsEventControl(PostsEvent event, Emitter<PostsState> emit) async {
    if (event is PostsStartEvent) {
      emit(PostsLoadingState());
      List<PostModel> posts = [];
      await HttpServices().getAllPosts().then((value) {
        posts = value;
      });
      emit(PostsLoadedState(posts: posts));
    } else if (event is PostsCreateEvent) {
      emit(PostsCreateLoadingState());
      HttpServices().createPost(event.post);
      emit(PostsCreateLoadedState());
    } else if (event is PostsUpdateEvent) {
      emit(PostsUpdateLoadingState());
      HttpServices().updatePost(event.post);
      emit(PostsUpdateLoadedState());
    } else if (event is PostsDeleteEvent) {
      emit(PostsDeleteLoadingState());
      HttpServices().deletePost(event.post);
      emit(PostsDeleteLoadedState());
    }
  }
}