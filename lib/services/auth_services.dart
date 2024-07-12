import 'package:dars9/services/auth_firebase_services.dart';

class AuthController {
  final _firebaseAuthService = AuthFirebaseServices();

  Future<void> register({
    required email,
    required password,
  }) async {
    await _firebaseAuthService.register(
      email: email,
      password: password,
    );
    
  }

  Future<void> login({
    required email,
    required password,
  }) async {
    await _firebaseAuthService.login(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
  }
}