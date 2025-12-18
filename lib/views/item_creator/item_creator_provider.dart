import 'package:flutter/material.dart';
import 'package:cs_310_project/services/database_service.dart';

class ItemCreatorProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  Future<void> _setLoading(bool v) async {
    _loading = v;
    notifyListeners();
  }

  /// Save an item to Firestore under users/{uid}/items. imageUrl should be a
  /// mock URL or asset path (we don't use Firebase Storage here).
  Future<bool> saveItem({
    required String name,
    required String category,
    required String style,
    required String season,
    required String color,
    required String imageUrl,
  }) async {
    await _setLoading(true);
    _error = null;
    try {
      await _db.addItem({
        'name': name,
        'category': category,
        'style': style,
        'season': season,
        'color': color,
        'imageUrl': imageUrl,
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
