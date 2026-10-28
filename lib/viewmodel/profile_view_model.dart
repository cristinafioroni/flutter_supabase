import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/profile_service.dart';
import '../models/user_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final SupabaseClient _client = Supabase.instance.client;

  UserProfile? profile;
  bool isLoading = false;

  Future<void> loadUserProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      profile = await _profileService.fetchUserProfile();
    } catch (e) {
      // Gestione degli errori
      print('Errore durante il caricamento del profilo: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> createUserProfile(UserProfile updatedProfile) async {
    final id = _client.auth.currentUser?.id;

    if (id == null) return;

    final newProfile = UserProfile(
      id: id,
      name: updatedProfile.name,
      avatarUrl: updatedProfile.avatarUrl,
      birthDate: updatedProfile.birthDate,
    );

    try {
      await _profileService.createUserProfile(newProfile);
      profile = newProfile;
      notifyListeners();
    } catch (e) {
      // Gestione degli errori
      print('Errore durante la creazione del profilo: $e');
    }

    notifyListeners();
  }

  Future<void> updateUserProfile(UserProfile updatedProfile) async {
    final id = _client.auth.currentUser?.id;

    if (id == null) return;

    try {
      await _profileService.updateUserProfile(updatedProfile);
      profile = updatedProfile;
      notifyListeners();
    } catch (e) {
      // Gestione degli errori
      print('Errore durante l\'aggiornamento del profilo: $e');
    }

    notifyListeners();
  }
}
