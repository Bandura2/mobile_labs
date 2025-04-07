import 'package:flutter/material.dart';
import '../user_data.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1503264116251-35a269479413?auto=format&fit=crop&w=1050&q=80',
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              height: 250,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(128),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (UserData.isLoggedIn) ...[
                    const Text(
                      'Профіль',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Привіт, ${UserData.name}!',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(UserData.email, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                    CustomButton(
                      onPressed: () {
                        UserData.isLoggedIn = false;
                        Navigator.pushReplacementNamed(context, '/profile');
                      },
                      text: 'Вийти з акаунту',
                    ),
                  ] else ...[
                    const Text(
                      'Увійдіть/Зареєструйтесь',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      text: 'Увійти',
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      onPressed:
                          () => Navigator.pushNamed(context, '/register'),
                      text: 'Зареєструватися',
                    ),
                  ],
                  SizedBox(height: 10),
                  CustomButton(
                    onPressed: () => Navigator.pushNamed(context, '/'),
                    text: 'На головну',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
