import 'package:formativa_ponto_trabalho/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../di/auth_providers.dart';

class SignInState {
  final String? errorMessage;
  final bool isLoading;
  final bool success;

  SignInState({this.errorMessage,this.isLoading = false, this.success = false});
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
      state = SignInState(errorMessage: "Error on signing in",isLoading: false, success: false);
    }
  }
}

final signInNotifierProvider = NotifierProvider<SignInStateNotifier, SignInState>(() => SignInStateNotifier(),);