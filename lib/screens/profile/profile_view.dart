import 'package:flutter/material.dart';
import 'auth_buttons.dart';
import 'profile_info.dart';
import '/widgets/custom_button.dart';

class ProfileView extends StatelessWidget {
  final bool isLoading;
  final bool isLoggedIn;
  final String? name;
  final String? email;
  final VoidCallback onLogout;
  final VoidCallback onReload;

  const ProfileView({
    super.key,
    required this.isLoading,
    required this.isLoggedIn,
    this.name,
    this.email,
    required this.onLogout,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          'https://images.unsplash.com/photo-1503264116251-35a269479413?auto=format&fit=crop&w=1050&q=80',
          fit: BoxFit.cover,
        ),
        Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Container(
                  height: 400,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(180),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLoggedIn)
                        ProfileInfo(
                            name: name!, email: email!, onLogout: onLogout)
                      else
                        AuthButtons(onReload: onReload),
                      const SizedBox(height: 10),
                      CustomButton(
                        onPressed: () => Navigator.pushNamed(context, '/'),
                        text: 'На головну',
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
