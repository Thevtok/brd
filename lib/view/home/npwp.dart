import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../profile/foto_view.dart';

class NPWPFoto extends StatefulWidget {
  final File? bukti;

  final Function() methodFoto;
  final VoidCallback deleteFoto;

  const NPWPFoto({
    super.key,
    this.bukti,
    required this.methodFoto,
    required this.deleteFoto,
  });

  @override
  // ignore: library_private_types_in_public_api
  _NPWPFotoState createState() => _NPWPFotoState();
}

class _NPWPFotoState extends State<NPWPFoto> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Unggah File'),
          const SizedBox(height: 5),
          InkWell(
            onTap: () {
              if (widget.bukti != null) {
                Get.to(() => PhotoViewGalleryScreen(images: widget.bukti!));
              } else {
                widget.methodFoto();
              }
            },
            onLongPress: () {
              _showDeleteDialog(context);
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(
                    color: Colors.grey.shade300, // Warna border
                    width: 2,
                  ),
                ),
                child: Center(
                    child: widget.bukti != null
                        ? Image.file(
                          widget.bukti!,
                          fit: BoxFit.cover,
                        )
                        : const Icon(Icons.camera_alt))),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Hapus Foto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus foto ini?',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('BATAL'),
            ),
            TextButton(
              onPressed: () {
                widget.deleteFoto(); // Panggil fungsi hapus
                Navigator.of(context).pop();
              },
              child: const Text('HAPUS'),
            ),
          ],
        );
      },
    );
  }
}
