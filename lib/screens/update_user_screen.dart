import 'package:flutter/material.dart';
import 'package:lab_1/repositories/shared_prefs_user_repository.dart';
import 'package:lab_1/widgets/custom_textfield.dart';
import 'package:lab_1/widgets/custom_button.dart';
import 'package:lab_1/validations/validation_register_fields.dart';
import 'package:lab_1/models/user.dart';
import 'package:provider/provider.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userRepository = context.read<SharedPrefsUserRepository>();

    final currentUser = await userRepository.getUser();

    if (currentUser != null) {
      setState(() {
        _nameController = TextEditingController(text: currentUser.name);
        _emailController = TextEditingController(text: currentUser.email);
        _passwordController = TextEditingController(text: currentUser.password);
      });
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final updatedUser = User(
        name: name,
        email: email,
        password: password,
        isLoggedIn: true,
      );

      final userRepository = context.read<SharedPrefsUserRepository>();
      await userRepository.updateUser(updatedUser);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редагування профілю'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
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
                  mainAxisSize: MainAxisSize.min,
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
                      text: 'Оновити профіль',
                      onPressed: _updateUser,
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
