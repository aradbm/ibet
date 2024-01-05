//userid, username, number of points
class User {
  final String userid;
  final String username;
  final int points;

  User({
    required this.userid,
    required this.username,
    required this.points,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userid: json['id'], username: json['username'], points: json['points']);
  }

  Map<String, dynamic> toJson() {
    return {'id': userid, 'username': username, 'points': points};
  }

  @override
  String toString() {
    return 'User{userid: $userid, username: $username, points: $points}';
  }
}
