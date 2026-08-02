/// Server-side shape of a user row (API_DOCUMENTATION.md Section 2) —
/// includes the password, unlike [AppUser] which is the client-facing
/// model returned over the wire.
class MockUser {
  MockUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.password,
    this.currentClassId,
    this.userType = 'student',
    this.studentLinkCode,
    this.pointsBalance = 0,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toUtc().toIso8601String();

  final int id;
  String firstName;
  String lastName;
  String email;
  String? phoneNumber;
  String password;
  int? currentClassId;
  final String userType;
  final String? studentLinkCode;
  int pointsBalance;
  final String createdAt;

  bool matchesLogin(String identifier) => email == identifier || phoneNumber == identifier;

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstName,
        'lastname': lastName,
        'full_name': '$firstName $lastName',
        'email': email,
        'phone_number': phoneNumber,
        'user_type': userType,
        'current_class_id': currentClassId,
        'student_link_code': studentLinkCode,
        'points_balance': pointsBalance,
        'created_at': createdAt,
      };
}
