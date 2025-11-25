import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadancompanionapp/firebase_options.dart';
import 'package:ramadancompanionapp/pages/auth/auth_page.dart';
import 'package:ramadancompanionapp/pages/auth/auth_wrapper.dart';
import 'package:ramadancompanionapp/pages/auth/login_page.dart';
import 'package:ramadancompanionapp/services/auth/data/firebase_auth_repo.dart';
import 'package:ramadancompanionapp/services/auth/domain/repos/auth_repo.dart';
import 'package:ramadancompanionapp/services/auth/presentation/provider/auth_provider.dart';
import 'package:ramadancompanionapp/services/auth/presentation/provider/auth_states.dart';
import 'package:ramadancompanionapp/themes/theme_data.dart';

void main() async {
  // firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //run app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // auth repo
  final AuthRepo authRepo = FirebaseAuthRepo();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepo: authRepo),
        ),
      ],
      child: MaterialApp(
        title: 'Ramadan Companion App',
        debugShowCheckedModeBanner: false,
        theme: normalTheme,
        // builder: (context, child) {
        //   return AuthWrapper();
        // },
        home: AuthWrapper(),
      ),
    );
  }
}
