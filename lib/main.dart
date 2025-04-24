import 'package:flutter/material.dart';
import 'package:lab_1/repositories/shared_prefs_user_repository.dart';
import 'package:lab_1/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userRepository = SharedPrefsUserRepository();
  final isLoggedIn = await userRepository.isUserLoggedIn();

  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPrefsUserRepository>.value(value: userRepository),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: isLoggedIn ? '/profile' : '/',
      routes: appRoutes,
    );
  }
}
