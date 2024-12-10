import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'foto_view.dart';

class FotoProfil extends StatefulWidget {
  final File? bukti;

  final Function() methodFoto;
  final VoidCallback deleteFoto;

  const FotoProfil({
    super.key,
    this.bukti,
    required this.methodFoto,
    required this.deleteFoto,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FotoProfilState createState() => _FotoProfilState();
}

class _FotoProfilState extends State<FotoProfil> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade300, // Warna border
                  width: 2,
                ),
              ),
              child: Center(
                  child: widget.bukti != null
                      ? ClipOval(
                          child: Image.file(
                            widget.bukti!,
                            fit: BoxFit.cover,
                            width: 75.0,
                            height: 75.0,
                          ),
                        )
                      : Image.asset(
                          'assets/images/profil.png',
                          fit: BoxFit.cover,
                        ))),
        ),
        // Icon pensil di sudut kanan bawah
        Positioned(
          bottom: 20, // Jarak dari bawah
          right: 0, // Jarak dari kanan
          child: GestureDetector(
            onTap: () {
              // Tambahkan logika ketika ikon pensil ditekan
            },
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[900], // Warna background ikon
              ),
              child: const Icon(
                Icons.edit, // Ikon pensil
                color: Colors.white, // Warna ikon
                size: 20,
              ),
            ),
          ),
        ),
      ],
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
