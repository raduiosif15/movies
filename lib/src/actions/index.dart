library actions;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movies/src/models/index.dart';

part 'get_movies.dart';
part 'index.freezed.dart';
part 'initialize_app.dart';
part 'register.dart';
part 'set.dart';
part 'sign_out.dart';

abstract class AppAction {}

abstract class ErrorAction implements AppAction {
  Object get error;

  StackTrace get stackTrace;
}

typedef ActionResult = void Function(AppAction action);
