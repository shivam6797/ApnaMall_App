import 'package:apnamall_ecommerce_app/features/auth/data/auth_api_client.dart';
import 'package:apnamall_ecommerce_app/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signUp({
    required String firstname,
    required String lastName,
    required String email,
    required String password,
    required String mobile,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiClient api;
  AuthRepositoryImpl(this.api);

  @override
  Future<UserModel> signUp({
    required String firstname,
    required String lastName,
    required String email,
    required String password,
    required String mobile,
  }) {
    // API already returns UserModel or throws ApiException
    return api.signUp(
      firstName: firstname,
      lastName: lastName,
      email: email,
      password: password,
      mobile: mobile,
    );
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) {
    // API already returns UserModel or throws ApiException
    return api.login(
      email: email,
      password: password,
    );
  }
}
