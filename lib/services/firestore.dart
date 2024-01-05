import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ibet/models/bet.dart';
import 'package:ibet/models/user.dart';

class FireStoreService {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference _bets =
      FirebaseFirestore.instance.collection('bets');

// user methods
  Future createUser(AppUser user) async {
    try {
      await _users.doc(user.userid).set(user.toJson());
    } catch (e) {
      return e;
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _users.doc(uid).get();
      return AppUser.fromJson(userData.data() as Map<String, dynamic>);
    } catch (e) {
      return e;
    }
  }

  Future updateUsername(String uid, String username) async {
    try {
      await _users.doc(uid).update({'username': username});
    } catch (e) {
      return e;
    }
  }

// bet methods
  Future createBet(Map<String, dynamic> bet) async {
    try {
      var betData = await _bets.add(bet);
      return betData.id;
    } catch (e) {
      return e;
    }
  }

  Future<Bet?> getBetByID(String betid) async {
    try {
      var betData = await _bets.doc(betid).get();
      return Bet.fromJson(betData.data() as Map<String, dynamic>, betid);
    } catch (e) {
      return null;
    }
  }

  Stream<QuerySnapshot> getBets() {
    final betsStream = _bets.orderBy('ends').snapshots();
    return betsStream;
  }

  Future updateBet(Bet bet) async {
    try {
      await _bets.doc(bet.betid).update(bet.toJson());
    } catch (e) {
      return e;
    }
  }

  Future deleteBet(String betid) async {
    try {
      await _bets.doc(betid).delete();
    } catch (e) {
      return e;
    }
  }
}