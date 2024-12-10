// ignore_for_file: library_prefixes

import 'dart:convert';
import 'dart:io';

import 'package:brd/model/address.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';

import '../utils/storage.dart';

class AddressController extends GetxController {
  final Dio.Dio _dio = Dio.Dio();

  Dio.Options options = Dio.Options(
    headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
  );

  void setAuthToken(String token) {
    options = Dio.Options(
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
    );
  }

  var currentPage = 1.obs;
  var addresses = <Address>[].obs; // Semua data dari API
  var displayedAddresses = <Address>[].obs; // Data yang sedang ditampilkan
  final ScrollController scrollController = ScrollController();
  final int limit = 10;
  var isLoading = false.obs;

  void sortAddresses() {
    addresses.sort((a, b) {
      if (b.primary && !a.primary) return 1; // Primary ke atas
      if (!b.primary && a.primary) return -1;
      return 0;
    });
  }

  Future<void> fetchAddresses({int page = 1}) async {
    try {
      isLoading(true);
      final token = await readToken();
      setAuthToken(token ?? '');

      final response = await _dio.get(
        dotenv.env['GET_ADDRESS'] ?? "",
        options: options,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<Address> newAddresses =
            data.map((e) => Address.fromJson(e)).toList();

        if (page == 1) {
          addresses.value = newAddresses; // Reset jika halaman pertama
        } else {
          // Tambahkan data baru tanpa duplikasi
          for (var newAddress in newAddresses) {
            if (!addresses
                .any((address) => address.addressId == newAddress.addressId)) {
              addresses.add(newAddress);
            }
          }
        }

        sortAddresses(); // Pastikan primary diurutkan ke atas
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadNextPage() async {
    if (!isLoading.value) {
      currentPage++;
      await fetchAddresses(page: currentPage.value);
    }
  }

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

  var province = 0.obs;
  var district = 0.obs;
  var subDistrict = 0.obs;
  Future<String> fetchSub(String q) async {
    try {
      isLoading(true);
      final token = await readToken();
      setAuthToken(token ?? '');

      final response = await _dio.get(
        '${dotenv.env['GET_SUB'] ?? ""}$q',
        options: options,
      );

      if (response.statusCode == 200) {
        if (response.data['action'] == false) {
          var data = response.data['message'];
          var pesan = jsonEncode(data).replaceAll('"', '');
          return pesan;
        }
        final List<dynamic> data = response.data['data'];
        if (data.isNotEmpty) {
          // Ambil data pertama sebagai contoh, bisa disesuaikan sesuai kebutuhan
          var addressData = data[0];

          // Simpan masing-masing value ke dalam Rx variabel
          province.value = addressData['province_id'] ?? '';
          district.value = addressData['district_id'] ?? '';
          subDistrict.value = addressData['sub_district_id'] ?? '';
          return 'Berhasil';
        }
      }
    } finally {
      isLoading(false);
    }
    return 'Lokasi tidak ditemukan';
  }

  Future<String> addAddress(
      String alamat,
      String label,
      String name,
      String phone,
      String email,
      String pos,
      double lat,
      double long,
      String pin,
      String noNpwp,
      String linkNpwp) async {
    try {
      final data = {
        "address": alamat,
        "address_label": label,
        "name": name,
        "phone_number": phone,
        "email": email,
        "province_id": province.value,
        "district_id": district.value,
        "sub_district_id": subDistrict.value,
        "postal_code": pos,
        "lat": lat,
        "long": long,
        "address_map": pin,
        "npwp": noNpwp,
        "npwp_file": linkNpwp
      };

      final token = await readToken();
      setAuthToken(token ?? '');

      final response = await _dio.post(
        dotenv.env['GET_ADDRESS'] ?? '',
        options: options,
        data: data,
      );

      if (response.statusCode == 400) {
        var data = response.data['message'];
        var pesan = jsonEncode(data).replaceAll('"', '');
        return pesan;
      } else if (response.statusCode == 201) {
        var respon = response.data['message'];
        var pesan = jsonEncode(respon).replaceAll('"', '');

        return pesan;
      } else {
        return 'Jaringan anda tidak stabil. Silahkan coba kembali ';
      }
    } catch (e) {
      return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti.';
    }
  }

  Future<String> deleteAddress(
    int id,
  ) async {
    try {
      final data = {
        "address_id": id,
      };

      final token = await readToken();
      setAuthToken(token ?? '');

      final response = await _dio.delete(
        dotenv.env['DELETE_ADDRESS'] ?? '',
        options: options,
        data: data,
      );

      if (response.statusCode == 200) {
        var error = response.data['error'];

        var gagal = jsonEncode(error).replaceAll('"', '');
        if (gagal.contains('Tidak')) {
          return gagal;
        }

        return 'Berhasil menghapus alamat';
      } else {
        return 'Jaringan anda tidak stabil. Silahkan coba kembali ';
      }
    } catch (e) {
      return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti.';
    }
  }

  Future<String> primaryAddress(
    int id,
  ) async {
    try {
      final data = {
        "address_id": id,
      };

      final token = await readToken();
      setAuthToken(token ?? '');

      final response = await _dio.post(
        dotenv.env['PRIMARY_ADDRESS'] ?? '',
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

        var pesan = jsonEncode(respon).replaceAll('"', '');

        return pesan;
      } else {
        return 'Jaringan anda tidak stabil. Silahkan coba kembali ';
      }
    } catch (e) {
      return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti.';
    }
  }

  Future<String> editAddress(
      String alamat,
      String label,
      String name,
      String phone,
      String email,
      String pos,
      double lat,
      double long,
      String pin,
      String noNpwp,
      String linkNpwp,
      int id) async {
    try {
      final data = {
        "address": alamat,
        "address_label": label,
        "name": name,
        "phone_number": phone,
        "email": email,
        "province_id": province.value,
        "district_id": district.value,
        "sub_district_id": subDistrict.value,
        "postal_code": pos,
        "lat": lat,
        "long": long,
        "address_map": pin,
        "npwp": noNpwp,
        "npwp_file": linkNpwp
      };

      final token = await readToken();
      setAuthToken(token ?? '');

      final response = await _dio.put(
        "${dotenv.env['GET_ADDRESS'] ?? ''}/$id",
        options: options,
        data: data,
      );

      if (response.statusCode == 400) {
        var data = response.data['message'];
        var pesan = jsonEncode(data).replaceAll('"', '');
        return pesan;
      } else if (response.statusCode == 200) {
        var respon = response.data['message'];
        var pesan = jsonEncode(respon).replaceAll('"', '');

        return pesan;
      } else {
        return 'Jaringan anda tidak stabil. Silahkan coba kembali ';
      }
    } catch (e) {
      return 'Jaringan anda tidak stabil. Silahkan coba kembali nanti.';
    }
  }
}
