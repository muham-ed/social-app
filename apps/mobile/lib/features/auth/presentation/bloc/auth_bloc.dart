import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _login;
  final RegisterUseCase _register;
  final LogoutUseCase _logout;
  final AuthRepository _repo;
  final NotificationService _notifications;

  AuthBloc(
    this._login,
    this._register,
    this._logout,
    this._repo,
    this._notifications,
  ) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheck);
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onCheck(AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await _repo.getCurrentUser();
    result.fold(
      (_) => emit(const AuthUnauthenticated()),
      (user) {
        _registerFcm();
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await _login(
      emailOrUsername: event.emailOrUsername,
      password: event.password,
    );
    result.fold(
      (f) => emit(AuthError(f.message)),
      (user) {
        _registerFcm();
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onRegister(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await _register(
      name: event.name,
      username: event.username,
      email: event.email,
      password: event.password,
    );
    result.fold(
      (f) => emit(AuthError(f.message)),
      (user) {
        _registerFcm();
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    await _logout();
    emit(const AuthUnauthenticated());
  }

  Future<void> _registerFcm() async {
    final token = await _notifications.getToken();
    if (token != null) {
      try {
        // TODO: send token to backend via NotificationRepository
      } catch (_) {}
    }
  }
}