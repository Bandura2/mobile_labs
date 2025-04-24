import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lab_1/widgets/custom_textfield.dart';
import 'package:lab_1/widgets/custom_button.dart';
import 'package:lab_1/validations/validation_register_fields.dart';
import 'package:lab_1/models/user.dart';
import 'package:lab_1/repositories/shared_prefs_user_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final userRepository = context.read<SharedPrefsUserRepository>();

      final user = User(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userRepository.saveUser(user);
      await userRepository.setUserLoggedIn(true);

      if (mounted) {
        Navigator.pushNamed(context, '/profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реєстрація'),
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
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(128),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                      label: "Ім'я",
                      controller: _nameController,
                      validator: Validators.validateName,
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
                    CustomButton(
                      text: 'Зареєструватися',
                      onPressed: _registerUser,
                    ),
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
