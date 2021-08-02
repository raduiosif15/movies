import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/container/selected_movie_container.dart';
import 'package:movies/src/container/user_container.dart';
import 'package:movies/src/models/index.dart';
import 'package:movies/src/presentation/user_avatar.dart';

class MovieDetails extends StatelessWidget {
  const MovieDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserContainer(
      builder: (BuildContext context, AppUser? user) {
        return SelectedMovieContainer(
          builder: (BuildContext context, Movie movie) {
            return Scaffold(
              appBar: AppBar(
                title: Text(movie.title),
                leading: const UserAvatar(),
              ),
              body: GestureDetector(
                onTap: () {
                  final Store<AppState> store = StoreProvider.of<AppState>(context);
                  final List<Movie> movies = store.state.movies.toList()..shuffle();
                  store.dispatch(SetSelectedMovie(movies.first.id));
                },
                child: Image.network(movie.largeImage),
              ),
              floatingActionButton: FloatingActionButton.extended(
                label: const Text('Review'),
                icon: const Icon(Icons.message_outlined),
                onPressed: () {
                  if (user == null) {
                    Navigator.pushNamed(context, '/login');
                  } else {
                    // show reviews page
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
