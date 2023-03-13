import 'package:flutter/foundation.dart';
import 'package:submission/data/api/api_service.dart';
import 'package:submission/data/model/login_response.dart';
import 'package:submission/data/model/register_response.dart';

import '../data/db/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;

  AuthProvider(this.apiService, this.authRepository);

  final AuthRepository authRepository;
  bool isLoadingLogout = false;
  bool isLoggedIn = false;
  bool isRegistered = false;

  String message = '';

  RegisterResponse? registerResponse;
  LoginResponse? loginResponse;

  Future register(String name, String email, String password) async {
    try {
      message = '';
      registerResponse = null;
      isRegistered = true;
      notifyListeners();

      registerResponse = await apiService.register(name, email, password);

      message = registerResponse?.message ?? 'User Created';
      isRegistered = false;
      notifyListeners();
    } catch (e) {
      isRegistered = false;
      message = e.toString();
      notifyListeners();
    }
  }

  Future login(String email, String password) async {
    try {
      message = '';
      loginResponse = null;
      isLoggedIn = true;
      notifyListeners();

      loginResponse = await apiService.login(email, password);

      message = loginResponse?.message ?? 'success';
      isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      isLoggedIn = false;
      message = e.toString();
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();
    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogout = false;
    notifyListeners();
    return !isLoggedIn;
  }
}
