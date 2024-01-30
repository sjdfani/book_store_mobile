class User {
  final int id;
  final String email;
  final String fullname;
  final String? profile;

  User(this.id, this.email, this.fullname, this.profile);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'],
      json['email'],
      json['fullname'],
      json['profile'],
    );
  }
}
