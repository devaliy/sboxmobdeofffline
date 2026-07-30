/// Server-side shape of a user row (spec Section 2's account domain) —
/// includes the password, unlike [AppUser] which is the client-facing
/// model returned over the wire.
class MockUser {
  MockUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.currentClassId,
    this.userType = 'student',
  });

  final int id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String password;
  int currentClassId;
  final String userType;

  bool matchesLogin(String identifier) => email == identifier || phoneNumber == identifier;

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'current_class_id': currentClassId,
        'user_type': userType,
      };
}
