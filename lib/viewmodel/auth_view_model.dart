import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  //* stato di caricamento per le operazioni di autenticazione
  bool isLoading = false;

  // variabile di tipo session che può essere null, rappresenta la sessione corrente dell'utente mantenendo le informazioni di autenticazione
  Session? session;

  // costruttore della classe che inizializza la sessione corrente dell'utente
  AuthViewModel() {
    session = _authService.currentSession;
  }

  //* metodo per effettuare il login
  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.signIn(
        email.trim(),
        password,
      );

      // se la login ha successo aggiorno la sessione corrente
      session = response.session;
    } catch (e) {
      print('Errore durante il login: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //* metodo per la registrazione
  Future<bool> register(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.signUp(
        //trim per rimuovere eventuali spazi bianchi dall'email
        email.trim(),
        password,
      );

      // aggiorno la sessione dopo la registrazione
      session = response.session;

      return session != null;
    } catch (e) {
      print('Errore durante la registrazione: $e');
      session = null;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //* metodo per effettuare il logout
  Future<void> logout() async {
    await _authService.signOut();

    // l'utente non è più loggato, l'interfaccia potrà tornare allo stato di login
    session = null;
    notifyListeners();
  }
}