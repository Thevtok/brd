// ignore_for_file: library_prefixes

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as Dio;

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';

import '../utils/storage.dart';

class AuthController extends GetxController {
  final Dio.Dio _dio = Dio.Dio();

  Dio.Options options = Dio.Options(
    headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
  );

  void setAuthToken(String token) {
    options = Dio.Options(
      headers: {
        'AccessToken': token,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
    );
  }

  var isLoading = false.obs;
   Future<String> uplpadImage(File? image) async {
    try {
      final token = await readToken();
      setAuthToken(token ?? '');

      final formData = Dio.FormData.fromMap({
        'image_file': await Dio.MultipartFile.fromFile(image?.path ?? ''),
      });

      final response = await _dio.post(
        dotenv.env['UP_IMAGE'] ?? "",
        options: options,
        data: formData,
      );

      if (response.statusCode == 201) {
        if (response.data['action'] == false) {
          var data = response.data['message'];
          var pesan = jsonEncode(data).replaceAll('"', '');
          return pesan;
        }
        var data = response.data['image_url'];
        var pesan = jsonEncode(data).replaceAll('"', '');
        return pesan;
      }
    } catch (error) {
      return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti.';
    }
    return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti.';
  }

  Future<String> login(String email, String password) async {
    try {
      final data = {
        'user_id': email,
        'password': password,
      };

      final response = await _dio.post(
        dotenv.env['LOGIN_USER'] ?? '',
        options: options,
        data: data,
      );

      if (response.statusCode == 200) {
        if (response.data['login'] == false) {
          var data = response.data['message'];
          var pesan = jsonEncode(data).replaceAll('"', '');
          return pesan;
        }

        var token = response.data['token'];

        await writeToken(token);
        // var user = response.data['data']['user'];

        // await saveUserToSecureStorage(user);

        return 'Berhasil Login';
      } else {
        return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti';
      }
    } catch (e) {
      return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti.';
    }
  }

  Future<String> regisMini(String email) async {
    try {
      final data = {
        'user_id': email,
      };

      setAuthToken(dotenv.env['TOKEN'] ?? '');

      final response = await _dio.post(
        dotenv.env['REGIS_MINI'] ?? '',
        options: options,
        data: data,
      );

      if (response.statusCode == 200) {
        if (response.data['action'] == false) {
          var data = response.data['message'];
          var pesan = jsonEncode(data).replaceAll('"', '');
          return pesan;
        }

        var respon = response.data['message'];

        return respon;
      } else {
        return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti';
      }
    } catch (e) {
      return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti.';
    }
  }

  Future<String> regisVerif(String email, String kode) async {
    try {
      final data = {'user_id': email, 'code': kode};

      final response = await _dio.post(
        dotenv.env['REGIS_VERIF'] ?? '',
        options: options,
        data: data,
      );

      if (response.statusCode == 200) {
        if (response.data['action'] == false) {
          var data = response.data['message'];
          var pesan = jsonEncode(data).replaceAll('"', '');
          return pesan;
        }

        var respon = response.data['message'];

        return respon;
      } else {
        return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti';
      }
    } catch (e) {
      return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti.';
    }
  }

  Future<String> resendCode(String email) async {
    try {
      final data = {
        'user_id': email,
      };
      setAuthToken(dotenv.env['TOKEN'] ?? '');

      final response = await _dio.post(
        dotenv.env['RESEND_CODE'] ?? '',
        options: options,
        data: data,
      );

      if (response.statusCode == 200) {
        if (response.data['action'] == false) {
          var data = response.data['message'];
          var pesan = jsonEncode(data).replaceAll('"', '');
          return pesan;
        }

        var respon = response.data['message'];

        return respon;
      } else {
        return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti';
      }
    } catch (e) {
      return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti.';
    }
  }

  Future<String> register(String email, String firt, String last,
      String password, String gender, String birthday,String? avatar) async {
    try {
      final data = {
        'user_id': email,
        "first_name": firt,
        "last_name": last,
        "password": password,
        'gender': gender,
        'birthday': birthday,
        'avatar':avatar
      };
      setAuthToken(dotenv.env['TOKEN'] ?? '');

      final response = await _dio.post(
        dotenv.env['REGIS_MANDA'] ?? '',
        options: options,
        data: data,
      );

      if (response.statusCode == 200) {
        if (response.data['action'] == false) {
          var data = response.data['message'];
          var pesan = jsonEncode(data).replaceAll('"', '');
          return pesan;
        }

        var respon = response.data['message'];

        return respon;
      } else {
        return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti';
      }
    } catch (e) {
      return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti.';
    }
  }


}
