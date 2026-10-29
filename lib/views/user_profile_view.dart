import 'package:flutter/material.dart';
import 'package:flutter_supabase/viewmodel/profile_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../models/user_profile.dart';
import 'widget/bottom_nav_bar.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  DateTime? _selectedDate;
  File? _selectedFile;
  bool _isSaving = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);

    profileVM.loadUserProfile().then((_) {
      if (!mounted) return;

      final profile = profileVM.profile;

      if (profile != null) {
        _usernameController.text = profile.name;
        _selectedDate = profile.birthDate;
        setState(() {});
      }
    });
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = Provider.of<ProfileViewModel>(context);
    final profile = profileVM.profile;

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),

      body: profileVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _pickImageFromGallery,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _selectedFile != null
                              ? FileImage(_selectedFile!)
                              : profile?.avatarUrl != null &&
                                      profile!.avatarUrl!.isNotEmpty
                                  ? NetworkImage(profile.avatarUrl!)
                                  : const AssetImage(
                                      'assets/avatar_placeholder.png',
                                    ) as ImageProvider,
                          child: _selectedFile != null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Inserisci il tuo username';
                          }
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Data di nascita'),
                      subtitle: Text(
                        _selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                            : 'Seleziona la tua data di nascita',
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: Text(_isSaving ? 'Salvataggio...' : 'Salva'),
                      onPressed: _isSaving
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              if (_selectedDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Seleziona la tua data di nascita',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final scaffoldMessenger = ScaffoldMessenger.of(
                                context,
                              );
                              setState(() {
                                _isSaving = true;
                              });

                              try {
                                final avatarUrl = _selectedFile != null
                                    ? await profileVM.uploadProfileImage(
                                        _selectedFile!,
                                      )
                                    : profile?.avatarUrl;
                                final updatedProfile = UserProfile(
                                  id: profile?.id ?? '',
                                  name: _usernameController.text.trim(),
                                  birthDate: _selectedDate!,
                                  avatarUrl: avatarUrl,
                                );

                                if (profile == null) {
                                  await profileVM.createUserProfile(
                                    updatedProfile,
                                  );
                                } else {
                                  await profileVM.updateUserProfile(
                                    updatedProfile,
                                  );
                                }

                                if (!mounted) return;
                                setState(() {
                                  _selectedFile = null;
                                });
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      profile == null
                                          ? 'Profilo creato con successo'
                                          : 'Profilo aggiornato con successo',
                                    ),
                                  ),
                                );
                              } catch (error) {
                                if (!mounted) return;
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Errore durante il salvataggio del profilo: $error',
                                    ),
                                  ),
                                );
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    _isSaving = false;
                                  });
                                }
                              }
                            },
                    ),
                  ],
                ),
              ),
            ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
