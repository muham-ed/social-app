import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String username;
  final String email;
  final String avatar;
  final String bio;
  final String role;
  final bool isVerified;
  final int followersCount;
  final int followingCount;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.avatar = '',
    this.bio = '',
    this.role = 'user',
    this.isVerified = false,
    this.followersCount = 0,
    this.followingCount = 0,
  });

  @override
  List<Object?> get props => [id, name, username, email, avatar, role, isVerified];
}