import 'package:flutter/material.dart';
import 'widget/add_book_view.dart';
import 'welcome_view.dart';
import 'auth/login_view.dart';
import '../viewmodel/auth_view_model.dart';

import 'package:provider/provider.dart';

import 'auth/register_view.dart';
import 'widget/custom_app_bar.dart';

// Import della BottomNavBar
import 'widget/bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),

      body: Center(
        child: Text('Benvenuto nella Home'),
      ),

      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
