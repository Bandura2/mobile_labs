import 'package:flutter/material.dart';
import 'package:lab_1/repositories/shared_prefs_user_repository.dart';
import 'package:lab_1/routes.dart';
import 'package:provider/provider.dart';
import 'package:lab_1/network/network_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userRepository = SharedPrefsUserRepository();
  final isLoggedIn = await userRepository.isUserLoggedIn();

  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPrefsUserRepository>.value(value: userRepository),
        ChangeNotifierProvider<NetworkService>(
          create: (_) => NetworkService(),
        ),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();
  bool? _wasConnected;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final networkService = Provider.of<NetworkService>(context);

    networkService.addListener(() {
      final isConnected = networkService.isConnected;

      if (_wasConnected != null && _wasConnected != isConnected) {
        final message =
        isConnected ? 'Wi-Fi connected' : 'Wi-Fi disconnected';

        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 2),
            backgroundColor: isConnected ? Colors.green : Colors.red,
          ),
        );
      }

      _wasConnected = isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      title: 'Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: widget.isLoggedIn ? '/profile' : '/',
      routes: appRoutes,
    );
  }
}
