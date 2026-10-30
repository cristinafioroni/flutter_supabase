import 'package:flutter/material.dart';
import '../../core/theme/app_color.dart';
import '../auth/login_view.dart';
import '../auth/register_view.dart';
import '../welcome_view.dart';
import '../../viewmodel/auth_view_model.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      centerTitle: true,

      title: Image.asset(
        'assets/book_eater_title.png',
        height: 50,
        fit: BoxFit.contain,
      ),
      actions: [
          IconButton(
            color: AppColors.gold,
            onPressed: () async {
              final vm = Provider.of<AuthViewModel>(context, listen: false);
              await vm.logout();

              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeView()),
                );
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}