import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  //* metodo per registrare un nuovo utente
  Future<AuthResponse> signUp(String email, String password) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  //*metodo per effettuare il login
  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  //*metodo per effettuare il logout
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  //*metodo per ottenere la sessione corrente
  Session? get currentSession => _client.auth.currentSession;
}
