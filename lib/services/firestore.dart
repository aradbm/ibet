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

// bet methods
  Future createBet(Map<String, dynamic> bet) async {
    // try {
    //   await _bets.doc(bet.betid).set(bet.toJson());
    // } catch (e) {
    //   return e;
    // }

    // get a bet and returns the betid
    try {
      var betData = await _bets.add(bet);
      return betData.id;
    } catch (e) {
      return e;
    }
  }

  Future getBet(String betid) async {
    try {
      var betData = await _bets.doc(betid).get();
      return Bet.fromJson(betData.data() as Map<String, dynamic>);
    } catch (e) {
      return e;
    }
  }

  Future getBets() async {
    try {
      var betsData = await _bets.get();
      return betsData.docs
          .map((bet) => Bet.fromJson(bet.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return e;
    }
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
