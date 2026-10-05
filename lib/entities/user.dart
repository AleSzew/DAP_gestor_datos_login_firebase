class User {
  String name;
  String email;
  String password;
  int? age;
  String? image;

  User({
    required this.name,
    required this.email,
    required this.password,
    this.age,
    this.image,
  });
}