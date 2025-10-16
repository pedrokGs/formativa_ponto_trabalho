import 'package:firebase_auth/firebase_auth.dart';
import 'package:formativa_ponto_trabalho/features/auth/data/datasource/auth_datasource.dart';

class AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepository({required this.authDataSource});

  Stream<User?> get authUser => authDataSource.authUser;

  User? get currentUser => authDataSource.currentUser;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await authDataSource.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await authDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
        rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      authDataSource.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
