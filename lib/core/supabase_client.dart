import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseClientManager {
  // chiamate asincrone al client Supabase
  static Future<void> init() async {
    // Inizializzazione del client Supabase
    await dotenv.load();
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      publishableKey: dotenv.env['SUPABASE_PUBLISHABLE_KEY']!,
    );
  }
  // si collega al client Supabase esistente
  static SupabaseClient get client => Supabase.instance.client;
}
