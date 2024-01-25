class UserResponse {
  final String token;
  final int userid;

  const UserResponse({required this.token, required this.userid});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(token: json['token'], userid: json['userid']);
  }
}
