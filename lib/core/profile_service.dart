import '../models/user_profile.dart';

import 'dart:io';

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
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

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

  //* metodo per caricare l'immagine del profilo utente
  Future<String> uploadProfileImage(File imageFile) async {
    final userId = _client.auth.currentUser!.id;

    final path = 'avatars/$userId/avatar.jpg';

    // carica l'immagine nel bucket media
    await _client.storage
        .from('media')
        .upload(
          path,
          imageFile,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

    // recupera l'URL pubblico dell'immagine
    final imageUrl = _client.storage.from('media').getPublicUrl(path);

    return imageUrl;
  }
}
