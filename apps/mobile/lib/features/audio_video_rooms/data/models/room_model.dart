import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/room.dart';

class RoomModel extends Room {
  const RoomModel({
    required super.id,
    required super.title,
    required super.owner,
    required super.channelName,
    super.description,
    super.type,
    super.isActive,
    super.listenersCount,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      owner: UserModel.fromJson(json['owner'] ?? {}),
      channelName: json['channelName'] ?? '',
      type: json['type'] ?? 'audio',
      isActive: json['isActive'] ?? true,
      listenersCount: json['listenersCount'] ?? 0,
    );
  }
}