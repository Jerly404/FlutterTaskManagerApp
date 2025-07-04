class UserModel {
  String id;
  String username;
  String password;

  UserModel({this.id = '', required this.username, required this.password});

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
        id: j['id'] ?? '',
        username: j['username'] ?? '',
        password: j['password'] ?? '',
      );

  Map<String, String> toJson() => {
        'username': username,
        'password': password,
      };
}