import 'package:formativa_ponto_trabalho/features/auth/data/repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository authRepository;

  SignUpUseCase({required this.authRepository});

  Future<void> call({required String email, required String password}) =>
      authRepository.signUp(email: email, password: password);
}