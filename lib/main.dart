import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formativa_ponto_trabalho/core/configs/firebase_options.dart';
import 'package:formativa_ponto_trabalho/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:formativa_ponto_trabalho/features/auth/presentation/screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(ProviderScope(child: MainApp(),));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/signIn", 
      routes: {
        "/signIn": (context) => const SignInScreen(),
        "/signUp": (context) => const SignUpScreen(),
      },
    );
  }
}
