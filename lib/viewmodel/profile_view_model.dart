import 'dart:io';

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
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUserProfile(UserProfile updatedProfile) async {
    final id = _client.auth.currentUser?.id;

    if (id == null) {
      throw Exception('Utente non autenticato');
    }

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
      rethrow;
    }
  }

  Future<void> updateUserProfile(UserProfile updatedProfile) async {
    final id = _client.auth.currentUser?.id;

    if (id == null) {
      throw Exception('Utente non autenticato');
    }

    try {
      await _profileService.updateUserProfile(updatedProfile);
      profile = updatedProfile;
      notifyListeners();
    } catch (e) {
      // Gestione degli errori
      print('Errore durante l\'aggiornamento del profilo: $e');
      rethrow;
    }
  }

  // metodo per caricare l'immagine del profilo
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      return await _profileService.uploadProfileImage(imageFile);
    } catch (e) {
      print('Errore durante il caricamento dell\'immagine: $e');
      rethrow;
    }
  }
}