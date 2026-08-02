/// Account domain subset (API_DOCUMENTATION.md Section 2) — fetched/cached
/// via the API only, never read directly from any local database.
class AppUser {
  const AppUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.currentClassId,
    required this.userType,
    this.studentLinkCode,
    this.pointsBalance = 0,
    this.createdAt,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  // Optional at registration — a real account can genuinely have none.
  final String? phoneNumber;
  // Required for student accounts, absent for parent accounts (the only
  // other `userType`) — this app only builds the student experience, but
  // the field still has to tolerate a real parent record without crashing
  // rather than assume every account has a class.
  final int? currentClassId;
  final String userType; // student | parent
  // Only ever set for student accounts — the code a parent enters in the
  // (separate) parent-facing app to link this student. Nothing to do with
  // it client-side beyond showing it in Settings.
  final String? studentLinkCode;
  final int pointsBalance;
  final String? createdAt;

  String get fullName => '$firstName $lastName';

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as int,
        firstName: json['firstname'] as String,
        lastName: json['lastname'] as String,
        email: json['email'] as String,
        phoneNumber: json['phone_number'] as String?,
        currentClassId: json['current_class_id'] as int?,
        userType: json['user_type'] as String,
        studentLinkCode: json['student_link_code'] as String?,
        pointsBalance: json['points_balance'] as int? ?? 0,
        createdAt: json['created_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'current_class_id': currentClassId,
        'user_type': userType,
        'student_link_code': studentLinkCode,
        'points_balance': pointsBalance,
        'created_at': createdAt,
      };
}
