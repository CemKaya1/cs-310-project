import 'package:flutter/material.dart';
import 'package:cs_310_project/services/database_service.dart';
import 'package:cs_310_project/services/storage_service.dart';
import 'dart:io';

// Manages the state and logic for creating new wardrobe items, 
// handling both image uploads and database persistence.
class ItemCreatorProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final StorageService _storage = StorageService();

  // UI State: Tracks whether an operation is in progress or if an error occurred.
  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  Future<void> _setLoading(bool v) async {
    _loading = v;
    notifyListeners();
  }

  /// Saves an item's metadata and its image (if provided) to Firebase.
  /// Returns [true] if the operation was successful.
  Future<bool> saveItem({
    required String name,
    required String category,
    required String style,
    required String season,
    required String color,
    File? imageFile,
  }) async {
    await _setLoading(true);
    _error = null;
    try {
      // Create a reference first to get a unique ID before uploading the image.
      final ref = _db.newItemRef();

      String imageUrl = 'lib/core/mock/mock_images/white_placeholder.png';
      String? imageStoragePath;
      
      // Only attempt upload if a local file was selected.
      if (imageFile != null) {
        final uploaded = await _storage.uploadItemImage(itemId: ref.id, file: imageFile);
        imageUrl = uploaded.downloadUrl;
        imageStoragePath = uploaded.fullPath;
      }
      
      // Save the record to Firestore using the generated reference.
      await _db.setItem(ref, {
        'name': name,
        'category': category,
        'style': style,
        'season': season,
        'color': color,
        'imageUrl': imageUrl,
        'imagePath': imageStoragePath,
      });
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      await _setLoading(false);
    }
  }
}
