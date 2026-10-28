import 'package:flutter/material.dart';
import 'package:flutter_supabase/viewmodel/profile_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user_profile.dart';
import '../viewmodel/auth_view_model.dart';
import 'auth/login_view.dart';
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
                        onTap: () {
                          //* struttura della modifica dell'immagine
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: profile?.avatarUrl != null
                              ? NetworkImage(profile!.avatarUrl!)
                              : const AssetImage(
                                  'assets/avatar_placeholder.png',
                                ) as ImageProvider,
                          child: profile?.avatarUrl == null
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
                      label: const Text('Salva'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _selectedDate != null) {
                          final username = _usernameController.text.trim();
                          if (profile == null) {
                            //* crea profilo se non esiste
                            await profileVM.createUserProfile(
                              UserProfile(
                                id: '',
                                name: username,
                                birthDate: _selectedDate!,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profilo creato con successo'),
                              ),
                            );
                          } else {
                            //* aggiorna profilo se esiste

                            final updated = UserProfile(
                              id: profile!.id,
                              name: username,
                              birthDate: _selectedDate!,
                              avatarUrl: profile.avatarUrl,
                            );
                            await profileVM.updateUserProfile(updated);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Profilo aggiornato con successo',
                                ),
                              ),
                            );
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
