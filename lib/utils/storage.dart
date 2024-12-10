import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const secureStorage = FlutterSecureStorage();

Future<void> writeToken(String token) async {
  final expiryTime =
      DateTime.now().add(const Duration(days: 1)); // Waktu sesi 10 detik
  await secureStorage.write(key: 'token', value: token);
  await secureStorage.write(
      key: 'expiry_time', value: expiryTime.toIso8601String());
}

/// Baca token jika sesi masih aktif
Future<String?> readToken() async {
  final expiryTimeString = await secureStorage.read(key: 'expiry_time');
  if (expiryTimeString != null) {
    final expiryTime = DateTime.parse(expiryTimeString);
    if (DateTime.now().isBefore(expiryTime)) {
      // Sesi masih aktif
      return await secureStorage.read(key: 'token');
    } else {
      // Sesi habis
      await deleteToken();
      return null;
    }
  }
  return null; // Tidak ada sesi
}

/// Hapus token dan waktu kedaluwarsa
Future<void> deleteToken() async {
  await secureStorage.delete(key: 'token');
  await secureStorage.delete(key: 'expiry_time');
}

/// Periksa apakah sesi masih aktif
Future<bool> isSessionActive() async {
  final expiryTimeString = await secureStorage.read(key: 'expiry_time');
  if (expiryTimeString != null) {
    final expiryTime = DateTime.parse(expiryTimeString);
    return DateTime.now().isBefore(expiryTime);
  }
  return false; // Tidak ada sesi
}



Future<void> saveUserToSecureStorage(Map<String, dynamic> userData) async {
  final userDataJson = jsonEncode(userData);
  await secureStorage.write(key: 'user_data', value: userDataJson);
}

Future<Map<String, dynamic>?> getUserFromSecureStorage() async {
  final userDataJson = await secureStorage.read(key: 'user_data');
  if (userDataJson != null) {
    return jsonDecode(userDataJson);
  } else {
    return null;
  }
}

/// Menghapus data user dari Secure Storage
Future<void> deleteUserFromSecureStorage() async {
  await secureStorage.delete(key: 'user_data');
}

Future<String?> getUserEmail() async {
  final user = await getUserFromSecureStorage();
  if (user != null && user.containsKey('email')) {
    return user['email'];
  } else {
    return null;
  }
}
