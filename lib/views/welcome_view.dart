import 'package:flutter/material.dart';
import 'auth/login_view.dart';
import '../viewmodel/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'auth/register_view.dart';


class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SupabaseApp'),
        // actions: [
        //   IconButton(onPressed: () async {
        //     final vm = Provider.of<AuthViewModel>(context, listen: false);
        //     await vm.logout();
        //     if (context.mounted) {
        //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView()));
        //     }
        //   }, icon: Icon(Icons.logout))
        // ]
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          // Image.asset(
          //   'assets/logo.png',
          //   height: 100,
          // ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView()));
            },
            child: Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterView()));
            },
            child: Text('Non hai un account? Registrati'),
          )
        ],
      ),
    );
  }
}
