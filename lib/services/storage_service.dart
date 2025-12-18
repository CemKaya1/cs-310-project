import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not authenticated');
    return uid;
  }

  Future<({String downloadUrl, String fullPath})> uploadItemImage({
    required String itemId,
    required File file,
  }) async {
    final ref = _storage.ref().child('users/$_uid/items/$itemId.jpg');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();
    return (downloadUrl: url, fullPath: ref.fullPath);
  }

  Future<({String downloadUrl, String fullPath})> uploadOutfitImage({
    required String outfitId,
    required File file,
  }) async {
    final ref = _storage.ref().child('users/$_uid/outfits/$outfitId.jpg');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();
    return (downloadUrl: url, fullPath: ref.fullPath);
  }

  Future<void> deleteByFullPath(String fullPath) async {
    await _storage.ref(fullPath).delete();
  }
}

