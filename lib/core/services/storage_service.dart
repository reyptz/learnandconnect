import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // Téléverser un fichier vers Firebase Storage
  Future<String> uploadFile(File file, String path) async {
    try {
      Reference ref = _firebaseStorage.ref().child(path);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      throw Exception('Failed to upload file');
    }
  }

  // Télécharger un fichier depuis Firebase Storage
  Future<File> downloadFile(String url, String localPath) async {
    // Implémentez la logique pour télécharger un fichier et le stocker localement
  }

  // Supprimer un fichier depuis Firebase Storage
  Future<void> deleteFile(String path) async {
    try {
      Reference ref = _firebaseStorage.ref().child(path);
      await ref.delete();
    } catch (e) {
      print('Error deleting file: $e');
      throw Exception('Failed to delete file');
    }
  }
}
