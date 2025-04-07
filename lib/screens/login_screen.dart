import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import '../user_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  void _loginUser() {
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      if (_emailController.text.trim() == UserData.email &&
          _passwordController.text.trim() == UserData.password) {

        UserData.isLoggedIn = true;
        Navigator.pushNamed(context, '/profile');
      } else {
        setState(() {
          _errorMessage = "Неправильний email або пароль";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вхід'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🖼️ Background image
          Image.network(
            'https://images.unsplash.com/photo-1503264116251-35a269479413?auto=format&fit=crop&w=1050&q=80',
            fit: BoxFit.cover,
          ),
          Center(
            // padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 250,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_errorMessage != null) // Відображаємо помилку, якщо є
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введіть email';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      label: 'Пароль',
                      isPassword: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введіть пароль';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomButton(text: 'Увійти', onPressed: _loginUser),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
