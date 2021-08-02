import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/data/auth_api.dart';
import 'package:movies/src/data/movies_api.dart';
import 'package:movies/src/epics/app_epics.dart';
import 'package:movies/src/models/index.dart';
import 'package:movies/src/presentation/home_page.dart';
import 'package:movies/src/presentation/login_page.dart';
import 'package:movies/src/presentation/movie_details.dart';
import 'package:movies/src/reducer/reducer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const String apiUrl = 'https://yts.mx/api/v2';
  final Client client = Client();
  final MoviesApi moviesApi = MoviesApi(apiUrl: apiUrl, client: client);
  final AuthApi authApi = AuthApi(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance);
  final AppEpics epic = AppEpics(moviesApi: moviesApi, authApi: authApi);
  final Store<AppState> store = Store<AppState>(
    reducer,
    initialState: AppState(),
    middleware: <Middleware<AppState>>[
      EpicMiddleware<AppState>(epic.epics),
    ],
  );
  store //
    ..dispatch(const InitializeApp())
    ..dispatch(const GetMovies());

  runApp(YtsApp(store: store));
}

class YtsApp extends StatelessWidget {
  const YtsApp({Key? key, required this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        home: const HomePage(),
        theme: ThemeData.dark(),
        routes: <String, WidgetBuilder>{
          '/details': (BuildContext context) => const MovieDetails(),
          '/login': (BuildContext context) => const LoginPage()
        },
      ),
    );
  }
}
