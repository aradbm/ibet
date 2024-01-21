//userid, username, number of points
class AppUser {
  final String userid;
  final String username;
  final int points;

  AppUser({
    required this.userid,
    required this.username,
    required this.points,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
        userid: json['userid'],
        username: json['username'],
        points: json['points']);
  }

  // getter for user id
  String get uid => userid;

  // getter for user name
  String get name => username;

  // getter for user points
  int get userPoints => points;

  Map<String, dynamic> toJson() {
    return {'userid': userid, 'username': username, 'points': points};
  }

  @override
  String toString() {
    return 'User{userid: $userid, username: $username, points: $points}';
  }
}
