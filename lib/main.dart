import 'package:flutter/material.dart';
import 'package:flutter_supabase/views/auth/login_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_supabase/views/home_view.dart';
import 'package:flutter_supabase/views/user_profile_view.dart';

import 'viewmodel/auth_view_model.dart';
import 'viewmodel/profile_view_model.dart';
import 'core/supabase_client.dart';

void main() async {
  // Assicura che i binding di Flutter siano inizializzati prima di eseguire altre operazioni asincrone
  WidgetsFlutterBinding.ensureInitialized();
  // Inizializzazione del client Supabase, ha preso le credenziali dal file .env
  await SupabaseClientManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Utilizzo di MultiProvider per fornire più ChangeNotifier
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: auth.session != null ? const HomeView() : const LoginView(),
          );
        },
      ),
    );
  }
}
