import 'package:flutter/material.dart';
import 'package:lab_1/widgets/custom_button.dart';
import 'package:lab_1/validations/validation_register_fields.dart';
import 'package:lab_1/widgets/custom_textfield.dart';
import 'package:lab_1/repositories/shared_prefs_user_repository.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _errorMessage;

  Future<void> _loginUser() async {
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      final userRepository = context.read<SharedPrefsUserRepository>();
      final savedUser = await userRepository.getUser();

      if (savedUser != null &&
          _emailController.text.trim() == savedUser.email &&
          _passwordController.text.trim() == savedUser.password) {
        await userRepository.setUserLoggedIn(true);
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/profile');
        }
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
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(128),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_errorMessage != null)
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
                      validator: Validators.validateEmail,
                    ),
                    CustomTextField(
                      label: 'Пароль',
                      isPassword: true,
                      controller: _passwordController,
                      validator: Validators.validatePassword,
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
