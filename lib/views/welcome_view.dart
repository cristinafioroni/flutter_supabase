import 'package:flutter/material.dart';

import 'auth/login_view.dart';
import '../viewmodel/auth_view_model.dart';

import 'package:provider/provider.dart';
import 'widget/custom_app_bar.dart';
import 'auth/register_view.dart';
import '../core/theme/app_color.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        color: AppColors.sage,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Image.asset('assets/logo.png', height: 350),
            Center(
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lavender,
                  foregroundColor: AppColors.textPrimary,
                ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginView()),
                    );
                  },
                  child: const Text('Login'),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                
                foregroundColor: AppColors.textPrimary,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterView()),
                );
              },
              child: const Text('Non hai un account? Registrati'),
            ),
          ],
        ),
      ),
    );
  }
}
