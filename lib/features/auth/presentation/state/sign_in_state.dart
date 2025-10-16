import 'package:formativa_ponto_trabalho/core/dependency_injection/riverpod.dart';
import 'package:formativa_ponto_trabalho/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:riverpod/riverpod.dart';

class SignInState {
  final bool isLoading;
  final bool success;

  SignInState({this.isLoading = false, this.success = false});
}

class SignInStateNotifier extends Notifier<SignInState>{
  late final SignInUseCase signInUseCase;
  
  @override
  SignInState build() {
    signInUseCase = ref.watch(signInUseCaseProvider);
    return SignInState();
  }

  Future<void> signIn({required String email, required String password}) async {
    state = SignInState(isLoading: true);
    try{
      await signInUseCase.call(email: email, password: password);
      state = SignInState(isLoading: false, success: true);
    } catch(e){
      state = SignInState(isLoading: false, success: true);
    }
  }
}