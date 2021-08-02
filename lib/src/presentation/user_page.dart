import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/container/user_container.dart';
import 'package:movies/src/models/index.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserContainer(
      builder: (BuildContext context, AppUser? user) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 500);
                      if (file == null) {
                        return;
                      }

                      StoreProvider.of<AppState>(context).dispatch(UpdateProfileUrl(file.path));
                    },
                    child: CircleAvatar(
                      backgroundImage: (user!.photoUrl != null) ? NetworkImage(user.photoUrl!) : null,
                      child: (user.photoUrl != null)
                          ? null
                          : Text(
                              user.username[0].toUpperCase(),
                              style: const TextStyle(fontSize: 100.0),
                            ),
                      backgroundColor: Theme.of(context).accentColor,
                      radius: 200.0,
                    ),
                  ),
                ),
                const SizedBox(height: 64.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Username: ',
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.green[200],
                      ),
                    ),
                    Text(
                      user.username,
                      style: const TextStyle(
                        fontSize: 32.0,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
