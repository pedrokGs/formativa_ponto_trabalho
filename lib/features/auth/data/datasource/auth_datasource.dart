import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSource{
    final FirebaseAuth firebaseAuth;

    const AuthDataSource({required this.firebaseAuth});
    
    Stream<User?> get authUser => firebaseAuth.authStateChanges();

    User? get currentUser => firebaseAuth.currentUser;

    Future<void> signInWithEmailAndPassword({required String email, required String password}) async{
        try {
          await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        } catch (e) {
          throw Exception("Erro no firebase");
        }
    }

    Future<void> signUpWithEmailAndPassword({required String email, required String password}) async{
        try{    
            await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        } catch (e){
            throw Exception("Erro no firebase");
        }
    }

    Future<void> signOut() async {
        try{
            await firebaseAuth.signOut();
        } catch(e){
            throw Exception("Erro no firebase");
        }
    }
}