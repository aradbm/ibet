import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ibet/models/user.dart';

class FireStoreService {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  Future createUser(User user) async {
    try {
      await _users.doc(user.userid).set(user.toJson());
    } catch (e) {
      return e;
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _users.doc(uid).get();
      return User.fromJson(userData.data() as Map<String, dynamic>);
    } catch (e) {
      return e;
    }
  }
}
