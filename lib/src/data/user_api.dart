import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserApi {
  UserApi({required FirebaseFirestore firestore, required FirebaseStorage storage})
      : _firestore = firestore,
        _storage = storage;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  Future<String> updateProfileUrl(String uid, String path) async {
    await _storage //
        .ref('users/$uid/profile.png')
        .putFile(File(path));

    final String url = await _storage //
        .ref('users/$uid/profile.png')
        .getDownloadURL();

    await _firestore //
        .doc('users/$uid')
        .update(<String, dynamic>{'photoUrl': url});

    return url;
  }
}
