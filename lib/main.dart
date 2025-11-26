import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadancompanionapp/firebase_options.dart';
import 'package:ramadancompanionapp/pages/auth/auth_wrapper.dart';
import 'package:ramadancompanionapp/providers/tab_switcher.dart';
import 'package:ramadancompanionapp/services/api/data/http_client.dart';
import 'package:ramadancompanionapp/services/api/data/prayer_api.dart';
import 'package:ramadancompanionapp/services/api/domain/repos/prayer_repo.dart';
import 'package:ramadancompanionapp/services/api/presentation/provider/prayer_provider.dart';
import 'package:ramadancompanionapp/services/auth/data/firebase_auth_repo.dart';
import 'package:ramadancompanionapp/services/auth/domain/repos/auth_repo.dart';
import 'package:ramadancompanionapp/services/auth/presentation/provider/auth_provider.dart';
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

  // for prayer api
  final HttpClientService httpClient = HttpClientService();
  PrayerApi get prayerApi =>
      PrayerApi(httpClient: httpClient);
  PrayerRepo get prayerRepo =>
      PrayerRepo(prayerApi: prayerApi);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepo: authRepo),
        ),
        ChangeNotifierProvider(
            create: (_) => TabSwitcher()),
        ChangeNotifierProvider(
            create: (_) =>
                PrayerProvider(prayerRepo: prayerRepo))
      ],
      child: MaterialApp(
        title: 'Ramadan Companion App',
        debugShowCheckedModeBanner: false,
        theme: normalTheme,
        home: AuthWrapper(),
      ),
    );
  }
}
