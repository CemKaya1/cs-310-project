import 'package:flutter/material.dart';
import 'package:cs_310_project/services/database_service.dart';
import 'package:cs_310_project/services/storage_service.dart';
import 'dart:io';

class ItemCreatorProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final StorageService _storage = StorageService();

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  Future<void> _setLoading(bool v) async {
    _loading = v;
    notifyListeners();
  }

  /// Save an item to Firestore under users/{uid}/items. imageUrl should be a
  /// download URL (Firebase Storage) or an asset placeholder when no image picked.
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
      final ref = _db.newItemRef();

      String imageUrl = 'lib/core/mock/mock_images/white_placeholder.png';
      String? imageStoragePath;

      if (imageFile != null) {
        final uploaded = await _storage.uploadItemImage(itemId: ref.id, file: imageFile);
        imageUrl = uploaded.downloadUrl;
        imageStoragePath = uploaded.fullPath;
      }

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
