// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:brd/controller/address_controller.dart';
import 'package:brd/view/auth/custom_button.dart';
import 'package:brd/view/auth/dialog.dart';
import 'package:brd/view/auth/entry_field.dart';
import 'package:brd/view/home/home_screen.dart';
import 'package:brd/view/home/map_screen.dart';
import 'package:brd/view/home/npwp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({
    super.key,
  });

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final emailController = TextEditingController();
  final labelController = TextEditingController();
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  final posController = TextEditingController();
  final pinController = TextEditingController();
  final npwpController = TextEditingController();
  final alamatController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? npwp;
  double? latitude;
  double? longitude;
  String? q;

  final controller = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blue.shade900,
            )),
        title: Text(
          'Alamat Pengiriman',
          style: TextStyle(
              color: Colors.blue.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(height: 10),
                EntryField(
                  keyboardType: TextInputType.text,
                  title: 'Label Alamat',
                  hint: 'Label Alamat',
                  bintang: true,
                  controller: labelController,
                  icon: CupertinoIcons.placemark,
                ),
                EntryField(
                  keyboardType: TextInputType.text,
                  title: 'Nama Penerima',
                  hint: 'Nama Penerima',
                  bintang: true,
                  controller: nameController,
                  icon: CupertinoIcons.person_solid,
                ),
                EntryField(
                  keyboardType: TextInputType.number,
                  title: 'Nomor Telepon',
                  hint: 'Nomor Telepon',
                  controller: phoneController,
                  icon: CupertinoIcons.phone_solid,
                  bintang: true,
                ),
                EmailField(
                  keyboardType: TextInputType.text,
                  title: 'Email',
                  hint: 'Email',
                  controller: emailController,
                  icon: CupertinoIcons.mail_solid,
                ),
                EntryField(
                  keyboardType: TextInputType.text,
                  title: 'Kecamatan',
                  hint: 'Kecamatan',
                  bintang: true,
                  controller: cityController,
                  icon: CupertinoIcons.building_2_fill,
                ),
                EntryField(
                  keyboardType: TextInputType.text,
                  title: 'Kode Pos',
                  hint: 'Kode Pos',
                  bintang: true,
                  controller: posController,
                  icon: CupertinoIcons.building_2_fill,
                ),
                AlamatField(
                  keyboardType: TextInputType.text,
                  title: 'Alamat Lengkap',
                  hint: 'Alamat Lengkap',
                  bintang: true,
                  controller: alamatController,
                  icon: CupertinoIcons.placemark_fill,
                ),
                InkWell(
                  onTap: () async {
                    final result = await Get.to(() => const MapScreen());

                    if (result != null) {
                      String address = result['address'];
                      latitude = result['latitude'];
                      longitude = result['longitude'];
                      q = result['q'];

                      pinController.text = address;
                    }
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: EntryField(
                      keyboardType: TextInputType.text,
                      title: 'Pin Alamat ',
                      hint: 'Pin Alamat ',
                      bintang: true,
                      controller: pinController,
                      icon: CupertinoIcons.placemark_fill,
                    ),
                  ),
                ),
                EntryField(
                  keyboardType: TextInputType.text,
                  title: 'NPMWP ',
                  hint: 'NPMWP ',
                  bintang: true,
                  controller: npwpController,
                  icon: CupertinoIcons.person_solid,
                ),
                NPWPFoto(
                  bukti: npwp,
                  methodFoto: () {
                    _showImagePickerBottomSheet(context, (File image) {
                      setState(() {
                        npwp = image;
                      });
                    });
                  },
                  deleteFoto: () {
                    setState(() {
                      npwp = null;
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  splashColor: Colors.blue,
                  title: 'Simpan',
                  height: 50,
                  width: 200,
                  font: 20,
                  color: Colors.blue[900]!,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      // Navigator.of(context).pop();
                      return;
                    }
                    _formKey.currentState!.save();
                    showProcessingDialog();
                    String npwpLink='';
                    var msg = await controller.fetchSub(cityController.text);
                    if (!msg.contains('Berhasil')) {
                      showFailedDialog(context, msg);
                    } else {
                      if (npwp != null) {
                        String link = await controller.uplpadImage(npwp);
                        npwpLink = link;
                      }
                      var response = await controller.addAddress(
                          alamatController.text,
                          labelController.text,
                          nameController.text,
                          phoneController.text,
                          emailController.text,
                          posController.text,
                          latitude ?? 0,
                          longitude ?? 0,
                          pinController.text,
                          npwpController.text,
                          npwpLink);
                      if (response.contains('berhasil')) {
                        showSuksesDialog(context, () async {
                        await  controller.fetchAddresses();
                          Get.offAll(() => const HomeScreen());
                        }, response);
                      } else {
                        showFailedDialog(context, response);
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showProcessingDialog() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const ProcessingDialog();
      },
    );
  }

  void showSuksesDialog(
      BuildContext context, VoidCallback ontap, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return SuksesDialogWidget(
          text: message,
          ontap: ontap,
          title: 'Tutup',
        );
      },
    );
  }

  void showFailedDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialogWidget(
          message: message,
          ontap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> _showImagePickerBottomSheet(
      BuildContext context, Function(File) onImageSelected) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading:
                  const Icon(Icons.camera_alt), // Ikon kamera yang lebih umum
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context); // Tutup bottom sheet
                _onAddPhotoKamera(onImageSelected);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library), // Ikon galeri tetap sesuai
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context); // Tutup bottom sheet
                _onAddPhotoGalery(onImageSelected);
              },
            ),
          ],
        );
      },
    );
  }

  void _onAddPhotoGalery(Function(File) onImageSelected) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File selectedImage = File(pickedFile.path);

      final last = File(selectedImage.path);
      setState(() {
        onImageSelected(last);
      });
    }
  }

  void _onAddPhotoKamera(Function(File) onImageSelected) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File selectedImage = File(pickedFile.path);

      final last = File(selectedImage.path);
      setState(() {
        onImageSelected(last);
      });
    }
  }
}
