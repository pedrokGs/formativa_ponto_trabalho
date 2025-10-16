import 'package:formativa_ponto_trabalho/features/auth/data/repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository authRepository;

  SignInUseCase({required this.authRepository});

  Future<void> call({required String email, required String password}) =>
      authRepository.signIn(email: email, password: password);
}
