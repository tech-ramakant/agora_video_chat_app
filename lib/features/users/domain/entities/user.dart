class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatar;
  final String phone; // Fake phone for UI

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatar,
    required this.phone,
  });
}
