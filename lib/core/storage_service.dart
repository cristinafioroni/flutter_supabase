import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:path/path.dart';

class StorageService {
  final SupabaseClient _client = Supabase.instance.client;
  final String bucket = 'media';

  //* metodo per il caricamento dei file nello storage
  Future<String> uploadImage(File imageFile, String bookId) async {
  final fileName = '${DateTime.now().millisecondsSinceEpoch}_${basename(imageFile.path)}';
  final filePath = '$bookId/$fileName';

  final storageResponse = await _client.storage.from(bucket).upload(filePath, imageFile);

  final publicUrl = _client.storage.from(bucket).getPublicUrl(filePath);
  return publicUrl;
  }
}
