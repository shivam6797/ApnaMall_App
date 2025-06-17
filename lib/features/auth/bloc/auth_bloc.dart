import 'dart:io'; // <-- SocketException के लिए
import 'package:apnamall_ecommerce_app/features/auth/data/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:apnamall_ecommerce_app/core/errors/api_exceptions.dart';

final _secureStorage = FlutterSecureStorage();

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;
  AuthBloc({required this.repo}) : super(AuthInitial()) {
    on<SignUpRequested>(_signUp);
    on<LoginRequested>(_login);
  }

  Future<void> _signUp(SignUpRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await repo.signUp(
        firstname: e.firstName,
        lastName: e.lastName,
        email: e.email,
        password: e.password,
        mobile: e.mobile,
      );
      await _secureStorage.write(key: 'token', value: user.token);
      emit(AuthSuccess(user.token));
    } on SocketException {
      emit(AuthFailure('No Internet connection. Please check your network.'));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('Something went wrong. Please try again.'));
    }
  }

  Future<void> _login(LoginRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await repo.login(email: e.email, password: e.password);
      await _secureStorage.write(key: 'token', value: user.token);
      print("Token to store: ${user.token}");
      emit(AuthSuccess(user.token));
    } on SocketException {
      emit(AuthFailure('No Internet connection. Please check your network.'));
    } on ApiException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('Something went wrong. Please try again.'));
    }
  }
}
