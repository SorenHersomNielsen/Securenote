class Keys {
  final int id;
  final String key;
  final int user_id;

  const Keys({required this.id, required this.key, required this.user_id});

  factory Keys.fromJson(Map<String, dynamic> json) {
    return Keys(id: json['id'], key: json['key'], user_id: json['user_id']);
  }
}
