import 'package:flutter/material.dart';
import '/user_data.dart';
import 'profile_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _isLoggedIn = false;
  String? _name;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    final isLoggedIn = await UserPreferences.isUserLoggedIn();
    if (isLoggedIn) {
      final name = await UserPreferences.getUserName();
      final email = await UserPreferences.getUserEmail();

      setState(() {
        _isLoggedIn = true;
        _name = name;
        _email = email;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    setState(() {
      _isLoggedIn = false;
      _name = null;
      _email = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ви вийшли з системи')),
    );
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
        isLoggedIn: _isLoggedIn,
        name: _name,
        email: _email,
        onLogout: _logout,
        onReload: _loadUserData,
      ),
    );
  }
}
