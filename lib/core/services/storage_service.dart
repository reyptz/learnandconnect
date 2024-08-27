import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

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

  // Télécharger un fichier depuis Firebase Storage et le stocker localement
  Future<File> downloadFile(String url, String localPath) async {
    try {
      // Télécharger le fichier depuis l'URL
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Écrire les données du fichier dans un fichier local
        final file = File(localPath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Failed to download file');
      }
    } catch (e) {
      print('Error downloading file: $e');
      throw Exception('Failed to download file');
    }
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
