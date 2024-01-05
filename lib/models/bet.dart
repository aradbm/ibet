class Bet {
  final String betid;
  final String betopener;
  final int ends;
  final String name;
  final String description;
  final int entrypoints;
  final List<dynamic> options;
  final Map<dynamic, dynamic> userpicks;

  Bet({
    required this.betid,
    required this.betopener,
    required this.ends,
    required this.name,
    required this.description,
    required this.entrypoints,
    required this.options,
    required this.userpicks,
  });

  factory Bet.fromJson(Map<String, dynamic> json, String betid) {
    return Bet(
      betid: betid,
      betopener: json['betopener'],
      ends: json['ends'],
      name: json['name'],
      description: json['description'],
      entrypoints: json['entrypoints'],
      options: json['options'],
      userpicks: json['users'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'betuid': betid,
      'betopener': betopener,
      'ends': ends,
      'name': name,
      'description': description,
      'entrypoints': entrypoints,
      'options': options,
      'users': userpicks,
    };
  }
}
