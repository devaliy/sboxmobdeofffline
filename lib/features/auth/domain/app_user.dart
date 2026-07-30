/// Account domain subset (spec Section 2) — fetched/cached via the API
/// only, never read directly from any local database.
class AppUser {
  const AppUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.currentClassId,
    required this.userType,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final int currentClassId;
  final String userType; // student | teacher | school_owner

  String get fullName => '$firstName $lastName';

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as int,
        firstName: json['firstname'] as String,
        lastName: json['lastname'] as String,
        email: json['email'] as String,
        phoneNumber: json['phone_number'] as String,
        currentClassId: json['current_class_id'] as int,
        userType: json['user_type'] as String,
      );

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
