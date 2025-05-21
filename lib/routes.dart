import 'package:flutter/material.dart';
import 'package:lab_1/screens/home_screen.dart';
import 'package:lab_1/screens/login_screen.dart';
import 'package:lab_1/screens/register_screen.dart';
import 'package:lab_1/screens/profile/profile_screen.dart';
import 'package:lab_1/screens/update_user_screen.dart';
import 'package:lab_1/screens/uart_settings_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/update': (context) => const UpdateUserScreen(),
  '/uart_settings': (context) => const UARTSettingsScreen(),
};
