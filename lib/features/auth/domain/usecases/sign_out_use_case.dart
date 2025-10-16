import 'package:formativa_ponto_trabalho/features/auth/data/repository/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository authRepository;

  SignOutUseCase({required this.authRepository});

  Future<void> call({required String email, required String password}) =>
      authRepository.signOut();
}