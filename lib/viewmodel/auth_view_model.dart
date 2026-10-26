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
      final response = await _authService.signIn(email, password);
      // se la login ha successo aggiorno la sessione corrente
      session = response.session;
    } catch (e) {
      // stampare eventuali errori di login
      print('Errore durante il login: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  //* metodo per la registrazione
  Future<void> register(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.signUp(email, password);
      // se la registrazione ha successo aggiorno la sessione corrente
      session = response.session;
    } catch (e) {
      // stampare eventuali errori di registrazione
      print('Errore durante la registrazione: $e');
    }

      isLoading = false;
      notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    // l'utente non è più loggato, l'interfaccia potrà tornare allo stato di login
    session = null;
    notifyListeners();
  }
}

