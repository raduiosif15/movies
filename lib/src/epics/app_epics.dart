import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/data/auth_api.dart';
import 'package:movies/src/data/movies_api.dart';
import 'package:movies/src/models/index.dart';

class AppEpics {
  const AppEpics({required MoviesApi moviesApi, required AuthApi authApi})
      : _moviesApi = moviesApi,
        _authApi = authApi;

  final MoviesApi _moviesApi;
  final AuthApi _authApi;

  Epic<AppState> get epics {
    return combineEpics<AppState>(<Epic<AppState>>[
      TypedEpic<AppState, InitializeAppStart>(_initializeApp),
      TypedEpic<AppState, GetMoviesStart>(_getMovies),
      TypedEpic<AppState, RegisterStart>(_register),
      TypedEpic<AppState, SignOutStart>(_signOut),
    ]);
  }

  Stream<AppAction> _initializeApp(Stream<InitializeAppStart> actions, EpicStore<AppState> store) {
    return actions
        .asyncMap((InitializeAppStart action) => _authApi.getCurrentUser())
        .map((AppUser? user) => InitializeApp.successful(user))
        .onErrorReturnWith((Object error, StackTrace stackTrace) => InitializeApp.error(error, stackTrace));
  }

  Stream<AppAction> _getMovies(Stream<GetMoviesStart> actions, EpicStore<AppState> store) {
    return actions
        .asyncMap((GetMoviesStart action) => _moviesApi.getMovies(store.state.page))
        .map((List<Movie> movies) => GetMovies.successful(movies))
        .onErrorReturnWith((Object error, StackTrace stackTrace) => GetMovies.error(error, stackTrace));
  }

  Stream<AppAction> _register(Stream<RegisterStart> actions, EpicStore<AppState> store) {
    return actions //
        .flatMap((RegisterStart action) => Stream<void>.value(null)
            .asyncMap((_) => _authApi.register(action.email, action.password))
            .map((AppUser user) => Register.successful(user))
            .onErrorReturnWith((Object error, StackTrace stackTrace) => Register.error(error, stackTrace))
            .doOnData(action.result));
  }

  Stream<AppAction> _signOut(Stream<SignOutStart> actions, EpicStore<AppState> store) {
    return actions
        .asyncMap((SignOutStart action) => _authApi.signOut())
        .map((_) => const SignOut.successful())
        .onErrorReturnWith((Object error, StackTrace stackTrace) => SignOut.error(error, stackTrace));
  }
}
