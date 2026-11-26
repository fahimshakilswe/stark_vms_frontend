/// Domain entity representing an authenticated user profile.
class UserEntity {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.createdAt,
  });

  bool get isAdmin => role.toUpperCase() == 'ADMIN';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
