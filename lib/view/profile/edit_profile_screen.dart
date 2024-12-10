// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:brd/view/auth/custom_button.dart';
import 'package:brd/view/auth/dialog.dart';
import 'package:brd/view/auth/entry_field.dart';
import 'package:brd/view/auth/login_screen.dart';
import 'package:brd/view/profile/edit_foto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../controller/auth_controller.dart';

class EditProfileScreen extends StatefulWidget {
  final String email;
  final String password;
  const EditProfileScreen(
      {super.key, required this.email, required this.password});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthDayController = TextEditingController();
  final phoneController = TextEditingController();
  String? gender;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final auth = Get.put(AuthController());
  File? foto;

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
  }

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
          'Ubah Profil',
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
                FotoProfil(
                  bukti: foto,
                  methodFoto: () {
                    _showImagePickerBottomSheet(context, (File image) {
                      setState(() {
                        foto = image;
                      });
                    });
                  },
                  deleteFoto: () {
                    setState(() {
                      foto = null;
                    });
                  },
                ),
                const SizedBox(height: 10),
                EntryField(
                  keyboardType: TextInputType.text,
                  title: 'Nama Depan',
                  hint: 'Nama Depan',
                  bintang: true,
                  controller: firstNameController,
                  icon: CupertinoIcons.person_solid,
                ),
                EntryField(
                  keyboardType: TextInputType.text,
                  title: 'Nama Belakang',
                  hint: 'Nama Belakang',
                  bintang: true,
                  controller: lastNameController,
                  icon: CupertinoIcons.person_solid,
                ),
                EmailField(
                  keyboardType: TextInputType.text,
                  title: 'Email',
                  hint: 'Email',
                  controller: emailController,
                  icon: CupertinoIcons.mail_solid,
                ),
                EntryField(
                  keyboardType: TextInputType.number,
                  title: 'Nomor Telepon',
                  hint: 'Nomor Telepon',
                  controller: phoneController,
                  icon: CupertinoIcons.phone_solid,
                ),
                InkWell(
                  onTap: () async {
                    // Menampilkan DatePicker
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), // Tanggal default
                      firstDate: DateTime(1900), // Batas bawah tanggal
                      lastDate: DateTime.now(), // Batas atas tanggal
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Colors.blue, // Warna utama
                            buttonTheme: const ButtonThemeData(
                                textTheme: ButtonTextTheme.primary),
                            colorScheme:
                                const ColorScheme.light(primary: Colors.blue)
                                    .copyWith(secondary: Colors.blue),
                          ),
                          child: child!,
                        );
                      },
                    );

                    // Jika pengguna memilih tanggal, perbarui nilai pada controller
                    if (pickedDate != null) {
                      String formattedDate = DateFormat('dd MMMM yyyy')
                          .format(pickedDate); // Format tanggal
                      birthDayController.text =
                          formattedDate; // Masukkan ke dalam controller
                    }
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: EntryField(
                      keyboardType: TextInputType.text,
                      title: 'Tanggal Lahir',
                      hint: 'Pilih Tanggal',
                      controller: birthDayController,
                      icon: CupertinoIcons.calendar,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Apa jenis kelamin Anda',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'male',
                          groupValue: gender, // Ganti sesuai state
                          onChanged: (String? value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                        const Text(
                          'Laki-laki',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'female',
                          groupValue: gender, // Ganti sesuai state
                          onChanged: (String? value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                        const Text(
                          'Perempuan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
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
                    String? avatar;
                    if (foto != null) {
                      String link = await auth.uplpadImage(foto);
                      avatar = link;
                    }

                    var response = await auth.register(
                        emailController.text,
                        firstNameController.text,
                        lastNameController.text,
                        widget.password,
                        gender ?? 'male',
                        birthDayController.text,
                        avatar ??
                            'https://devapi.blueraycargo.id/static/images/no-image.jpg');
                    if (response.contains('successfully')) {
                      showSuksesDialog(context, () async {
                        Get.offAll(() => const LoginScreen());
                      }, response);
                    } else {
                      showFailedDialog(context, response);
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
          title: 'MASUK',
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
