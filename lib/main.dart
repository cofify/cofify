import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// widgets
// import 'package:cofify/screens/wrapper.dart';

// models
import 'package:cofify/firebase_options.dart';
import 'package:cofify/models/user.dart';
import 'package:cofify/services/auth_service.dart';

import 'providers/dots_track_provider.dart';
import 'providers/search_provider.dart';

// other
import 'constants/theme_constants.dart';
import 'constants/theme_manager.dart';
import 'constants/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeManager()),
      ChangeNotifierProvider(create: (_) => PageTracker()),
      ChangeNotifierProvider(create: (_) => ChooseCityDataProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _auth = AuthService.firebase();

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return StreamProvider<MyUser>.value(
      value: _auth.user,
      initialData: MyUser(uid: ''),
      child: MaterialApp(
        initialRoute: '/',
        routes: appRoutes,
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeManager.themeMode,
        // home: Wrapper(),
      ),
    );
  }
}
