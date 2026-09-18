import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

class Room extends Equatable {
  final String id;
  final String title;
  final String description;
  final User owner;
  final String type; // audio | video
  final bool isActive;
  final int listenersCount;
  final String channelName;

  const Room({
    required this.id,
    required this.title,
    required this.owner,
    required this.channelName,
    this.description = '',
    this.type = 'audio',
    this.isActive = true,
    this.listenersCount = 0,
  });

  @override
  List<Object?> get props => [id, title, isActive];
}