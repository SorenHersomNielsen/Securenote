class Keys {
  final int id;
  final String key;
  final String aes;
  final int user_id;

  const Keys(
      {required this.id,
      required this.key,
      required this.aes,
      required this.user_id});

  factory Keys.fromJson(Map<String, dynamic> json) {
    return Keys(
        id: json['id'],
        key: json['key'],
        aes: json['aes'],
        user_id: json['user_id']);
  }
}
