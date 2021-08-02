import 'package:flutter/material.dart';
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
              body: Image.network(movie.largeImage),
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
