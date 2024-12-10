// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../auth/custom_button.dart'; // Menggunakan latlong2 untuk koordinat

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? _pickedLocation;
  String _address = ''; // Menyimpan alamat yang dipilih
  String q = '';
  final TextEditingController _addressController = TextEditingController();

  // Fungsi untuk mengambil alamat berdasarkan latitude dan longitude
  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String address =
          "${place.street}, ${place.locality}, ${place.administrativeArea}";
      setState(() {
        _address = address;
        _addressController.text = address;
        q = place.locality ?? '';
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _addressController.text = _address; // Set value pada TextEditingController
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Pilih alamat...',
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
          controller: _addressController,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(
                    -6.200000, 106.816666), // Lokasi Jakarta default
                initialZoom: 13,
                onTap: (_, latlng) {
                  setState(() {
                    _pickedLocation = latlng;
                  });
                  _getAddressFromLatLng(latlng); // Ambil alamat dari LatLng
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _pickedLocation == null
                      ? []
                      : [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: _pickedLocation!,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
              splashColor: Colors.blue,
              title: 'Simpan',
              height: 50,
              width: 200,
              font: 20,
              color: Colors.blue[900]!,
              onPressed: () async {
                double latitude = _pickedLocation?.latitude ?? 0;
                double longitude = _pickedLocation?.longitude ?? 0;
                Map<String, dynamic> result = {
                  'address': _address,
                  'latitude': latitude,
                  'longitude': longitude,
                  'q': q
                };

                Get.back(result: result);
              }),
        ],
      ),
    );
  }
}
