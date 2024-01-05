//   'betuid':  4134
// 'betopener' : 123123
// 'ends':  dateTime
// 'name': billabord 100
// 'description': taylor swift again number 1
// 'entrypoints': 30
// 'options': [ "asd" , "asdwwda", "ASDWss"]
// 'users':[ 123123,12341]
class Bet {
  final String betuid;
  final String betopener;
  final DateTime ends;
  final String name;
  final String description;
  final int entrypoints;
  final List<String> options;
  final List<String> users;

  Bet({
    required this.betuid,
    required this.betopener,
    required this.ends,
    required this.name,
    required this.description,
    required this.entrypoints,
    required this.options,
    required this.users,
  });

  factory Bet.fromJson(Map<String, dynamic> json) {
    return Bet(
      betuid: json['betuid'],
      betopener: json['betopener'],
      ends: json['ends'],
      name: json['name'],
      description: json['description'],
      entrypoints: json['entrypoints'],
      options: json['options'],
      users: json['users'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'betuid': betuid,
      'betopener': betopener,
      'ends': ends,
      'name': name,
      'description': description,
      'entrypoints': entrypoints,
      'options': options,
      'users': users,
    };
  }

  @override
  String toString() {
    return 'Bet{betuid: $betuid, betopener: $betopener, ends: $ends, name: $name, description: $description, entrypoints: $entrypoints, options: $options, users: $users}';
  }
}
