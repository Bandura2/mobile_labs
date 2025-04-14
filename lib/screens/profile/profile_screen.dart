import 'package:flutter/material.dart';
import '/models/user.dart';
import '/repositories/shared_prefs_user_repository.dart';
import 'profile_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userRepository = SharedPrefsUserRepository();

  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    final isLoggedIn = await _userRepository.isUserLoggedIn();
    if (isLoggedIn) {
      final user = await _userRepository.getUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } else {
      setState(() {
        _user = null;
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await _userRepository.logout();

    setState(() {
      _user = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ви вийшли з системи')),
      );
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black87,
      ),
      body: ProfileView(
        isLoading: _isLoading,
        isLoggedIn: _user != null,
        name: _user?.name,
        email: _user?.email,
        onLogout: _logout,
        onReload: _loadUserData,
      ),
    );
  }
}
