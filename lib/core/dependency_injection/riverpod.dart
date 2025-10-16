import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formativa_ponto_trabalho/features/auth/data/datasource/auth_datasource.dart';
import 'package:formativa_ponto_trabalho/features/auth/data/repository/auth_repository.dart';
import 'package:formativa_ponto_trabalho/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:formativa_ponto_trabalho/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:formativa_ponto_trabalho/features/auth/domain/usecases/sign_up_use_case.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final authDataSourceProvider = Provider((ref) => AuthDataSource(firebaseAuth: ref.watch(firebaseAuthProvider)),);
final authRepositoryProvider = Provider((ref) => AuthRepository(authDataSource: ref.watch(authDataSourceProvider)),);
final signInUseCaseProvider = Provider((ref) => SignInUseCase(authRepository: ref.watch(authRepositoryProvider)),);
final signUpUseCaseProvider = Provider((ref) => SignUpUseCase(authRepository: ref.watch(authRepositoryProvider)),);
final signOutUseCaseProvider = Provider((ref) => SignOutUseCase(authRepository: ref.watch(authRepositoryProvider)),);
final authUserProvider = StreamProvider((ref) => ref.watch(authRepositoryProvider).authUser,);
