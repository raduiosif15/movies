import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/container/is_loading_container.dart';
import 'package:movies/src/container/movies_container.dart';
import 'package:movies/src/models/index.dart';
import 'package:movies/src/presentation/user_avatar.dart';
import 'package:redux/redux.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final bool isLoading = store.state.isLoading;
    final double max = _controller.position.maxScrollExtent;
    final double offset = _controller.offset;
    final double delta = max - offset;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double threshold = screenHeight * 0.5;

    if (delta < threshold && !isLoading) {
      store.dispatch(const GetMovies());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        leading: const UserAvatar(),
        actions: <Widget>[
          IsLoadingContainer(
            builder: (BuildContext context, bool isLoading) {
              if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: MoviesContainer(
        builder: (BuildContext context, List<Movie> movies) {
          return IsLoadingContainer(
            builder: (BuildContext context, bool isLoading) {
              if (isLoading && movies.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.69,
                ),
                controller: _controller,
                itemCount: movies.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final Movie movie = movies[index];

                  return GestureDetector(
                    onTap: () {
                      StoreProvider.of<AppState>(context).dispatch(SetSelectedMovie(movie.id));
                      Navigator.pushNamed(context, '/details');
                    },
                    child: GridTile(
                      child: Image.network(
                        movie.image,
                        fit: BoxFit.cover,
                      ),
                      footer: GridTileBar(
                        backgroundColor: Colors.black38,
                        title: Text(movie.title),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
