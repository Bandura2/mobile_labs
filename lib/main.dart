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

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  static final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkService>(
      builder: (context, networkService, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleNetworkStatusChange(networkService);
        });

        return MaterialApp(
          scaffoldMessengerKey: _scaffoldMessengerKey,
          title: 'Flutter App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: isLoggedIn ? '/profile' : '/',
          routes: appRoutes,
        );
      },
    );
  }

  static bool? _wasConnected;

  static void _handleNetworkStatusChange(NetworkService networkService) {
    final isConnected = networkService.isConnected;

    if (_wasConnected != null && _wasConnected != isConnected) {
      final message = isConnected ? 'Wi-Fi connected' : 'Wi-Fi disconnected';

      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: isConnected ? Colors.green : Colors.red,
        ),
      );
    }

    _wasConnected = isConnected;
  }
}
