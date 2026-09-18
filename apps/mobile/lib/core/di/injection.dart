import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../network/token_storage.dart';
import '../network/websocket_client.dart';
import '../services/storage_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/permission_service.dart';
import '../services/agora_service.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/short_video/data/datasources/video_remote_datasource.dart';
import '../../features/short_video/data/repositories/video_repository_impl.dart';
import '../../features/short_video/domain/repositories/video_repository.dart';
import '../../features/short_video/presentation/bloc/feed_bloc.dart';

import '../../features/direct_messaging/data/datasources/message_remote_datasource.dart';
import '../../features/direct_messaging/data/repositories/message_repository_impl.dart';
import '../../features/direct_messaging/domain/repositories/message_repository.dart';
import '../../features/direct_messaging/presentation/bloc/conversations_bloc.dart';
import '../../features/direct_messaging/presentation/bloc/chat_bloc.dart';

import '../../features/audio_video_rooms/data/datasources/room_remote_datasource.dart';
import '../../features/audio_video_rooms/data/repositories/room_repository_impl.dart';
import '../../features/audio_video_rooms/domain/repositories/room_repository.dart';
import '../../features/audio_video_rooms/presentation/bloc/rooms_bloc.dart';

import '../../features/location_discovery/data/datasources/discover_remote_datasource.dart';
import '../../features/location_discovery/data/repositories/discover_repository_impl.dart';
import '../../features/location_discovery/domain/repositories/discover_repository.dart';
import '../../features/location_discovery/presentation/bloc/discover_bloc.dart';

import '../../features/notifications/data/datasources/notification_remote_datasource.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';

import '../../features/report_block/data/repositories/report_repository_impl.dart';
import '../../features/report_block/domain/repositories/report_repository.dart';
import '../../features/report_block/presentation/bloc/report_block_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerLazySingleton<StorageService>(() => StorageService(prefs));
  getIt.registerLazySingleton<TokenStorage>(
    () => TokenStorage(const FlutterSecureStorage()),
  );
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt()));
  getIt.registerLazySingleton<WebSocketClient>(() => WebSocketClient(getIt()));
  getIt.registerLazySingleton<LocationService>(LocationService.new);
  getIt.registerLazySingleton<NotificationService>(NotificationService.new);
  getIt.registerLazySingleton<PermissionService>(PermissionService.new);
  getIt.registerLazySingleton<AgoraService>(AgoraService.new);

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt(), getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerFactory(() => AuthBloc(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ));

  // Video
  getIt.registerLazySingleton<VideoRemoteDataSource>(
    () => VideoRemoteDataSource(getIt()),
  );
  getIt.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => FeedBloc(getIt()));

  // Messages
  getIt.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageRemoteDataSource(getIt()),
  );
  getIt.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerFactory(() => ConversationsBloc(getIt()));
  getIt.registerFactory(() => ChatBloc(getIt()));

  // Rooms
  getIt.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSource(getIt()),
  );
  getIt.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => RoomsBloc(getIt()));

  // Discover
  getIt.registerLazySingleton<DiscoverRemoteDataSource>(
    () => DiscoverRemoteDataSource(getIt()),
  );
  getIt.registerLazySingleton<DiscoverRepository>(
    () => DiscoverRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => DiscoverBloc(getIt(), getIt()));

  // Notifications
  getIt.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSource(getIt()),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => NotificationsBloc(getIt()));

  // Report & Block
  getIt.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => ReportBlockBloc(getIt()));
}