import 'package:flutter/material.dart';
import '/widgets/custom_button.dart';

class AuthButtons extends StatelessWidget {
  final VoidCallback onReload;

  const AuthButtons({super.key, required this.onReload});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Увійдіть/Зареєструйтесь',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        CustomButton(
          onPressed: () async {
            await Navigator.pushNamed(context, '/login');
            onReload();
          },
          text: 'Увійти',
        ),
        const SizedBox(height: 10),
        CustomButton(
          onPressed: () async {
            await Navigator.pushNamed(context, '/register');
            onReload();
          },
          text: 'Зареєструватися',
        ),
      ],
    );
  }
}
