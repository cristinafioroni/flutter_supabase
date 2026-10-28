import 'package:flutter/material.dart';

import 'auth/login_view.dart';
import '../viewmodel/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'auth/register_view.dart';

// Import della BottomNavBar
import 'widget/bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SupabaseApp'),
        actions: [
          IconButton(
            onPressed: () async {
              final vm = Provider.of<AuthViewModel>(context, listen: false);
              await vm.logout();

              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      body: Center(
        child: Text(
          'Benvenuto nella Home!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
      ),

      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}