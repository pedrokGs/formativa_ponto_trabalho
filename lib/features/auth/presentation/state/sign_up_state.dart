import 'package:formativa_ponto_trabalho/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../di/auth_providers.dart';

class SignUpState {
  final String? errorMessage;
  final bool isLoading;
  final bool success;

  SignUpState({this.errorMessage,this.isLoading = false, this.success = false});
}

class SignUpStateNotifier extends Notifier<SignUpState>{
  late final SignUpUseCase signUpUseCase;
  
  @override
  SignUpState build() {
    signUpUseCase = ref.watch(signUpUseCaseProvider);
    return SignUpState();
  }

  Future<void> signUp({required String email, required String password}) async {
    state = SignUpState(isLoading: true);
    try{
      await signUpUseCase.call(email: email, password: password);
      state = SignUpState(isLoading: false, success: true);
    } catch(e){
      state = SignUpState(errorMessage: "Error on signing up",isLoading: false, success: false);
    }
  }
}

final signUpNotifierProvider = NotifierProvider<SignUpStateNotifier, SignUpState>(() => SignUpStateNotifier(),);