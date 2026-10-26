import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/auth_view_model.dart';
import 'login_view.dart';
import '../home_view.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
      //* app bar
      appBar: AppBar(
        title: Text('Registrati'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeView()),
              );
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      //gestione dello stato di caricamento con isLoading
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  //* campo per l'email
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  //* campo per la password
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await vm.register(
                        emailController.text,
                        passwordController.text,
                      );
                      // context.mounted assicura che il contesto sia ancora valido prima di navigare
                      if (vm.session != null && context.mounted) {
                        //pushReplacement serve a sostituire la schermata corrente con la nuova, evitando che l'utente possa tornare indietro con il back button
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeView()),
                        );
                      }
                    },
                    child: Text('Registrati'),
                  ),
                  //* pulsante per tornare al login
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LoginView()),
                      );
                    },
                    child: const Text('Hai un account? Vai al login'),
                  ),
                ],
              ),
            ),
    );
  }
}
