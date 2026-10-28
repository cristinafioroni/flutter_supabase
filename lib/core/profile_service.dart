import '../models/user_profile.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  //* metodo per recuperare i dati del profilo utente
  Future<UserProfile?> fetchUserProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return null;
    }
    //* query al database per recuperare i dati del profilo utente
    final response = await _client.from('profiles').select().eq('id', userId).single();

    return UserProfile.fromMap(response);
  }

  //* metodo per la creazione del profilo utente
  Future<void> createUserProfile(UserProfile profile) async {
    await _client.from('profiles').insert(profile.toMap());
  }

  //* metodo per aggiornare il profilo utente
  Future<void> updateUserProfile(UserProfile profile) async {
    await _client.from('profiles').update(profile.toMap()).eq('id', profile.id);
  }

    
}

