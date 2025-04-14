import 'package:flutter/material.dart';
import '/widgets/custom_button.dart';

class ProfileInfo extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onLogout;

  const ProfileInfo({
    super.key,
    required this.name,
    required this.email,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Профіль',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text('Привіт, $name!', style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 8),
        Text(email, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
        CustomButton(
          onPressed: () => Navigator.pushNamed(context, '/update'),
          text: 'Редагувати профіль',
        ),
        const SizedBox(height: 20),
        CustomButton(onPressed: onLogout, text: 'Вийти з акаунту'),
      ],
    );
  }
}
