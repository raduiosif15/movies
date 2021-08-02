import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/container/user_container.dart';
import 'package:movies/src/models/index.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserContainer(
      builder: (BuildContext context, AppUser? user) {
        if (user == null) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                child: const Icon(Icons.person),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              StoreProvider.of<AppState>(context).dispatch(const SignOut());
            },
            child: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              child: Text(user.username[0].toUpperCase()),
            ),
          ),
        );
      },
    );
  }
}
