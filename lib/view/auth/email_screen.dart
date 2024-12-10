// ignore_for_file: use_build_context_synchronously

import 'package:brd/view/auth/custom_button.dart';
import 'package:brd/view/auth/dialog.dart';
import 'package:brd/view/auth/entry_field.dart';
import 'package:brd/view/auth/otp_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final auth = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue.shade900,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Positioned(
              top: 40, // Atur posisi sesuai kebutuhan
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.white), // Ikon warna putih
                onPressed: () {
                  Navigator.pop(context); // Navigasi kembali
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  height: MediaQuery.of(context).size.height * 0.55,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),

                      const Text(
                        'Pendaftaran',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Silahkan isi data dengan benar\nuntuk membuat akun Blueray Cargo',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 15),
                      EmailField(
                        keyboardType: TextInputType.text,
                        title: 'Email',
                        hint: 'Email',
                        controller: emailController,
                        icon: CupertinoIcons.mail_solid,
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                        splashColor: Colors.blue,
                        title: 'Daftar Sekarang',
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

                          var respon = await auth.regisMini(
                            emailController.text,
                          );
                          if (respon.contains('successful')) {
                            showSuksesDialog(context, () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                             

                              Get.to(
                                  () => OTPScreen(email: emailController.text));
                            }, respon);
                          } else {
                            showFailedDialog(context, respon);
                          }
                        },
                      ),
                      // const SizedBox(
                      //   height: 30,
                      // ),
                      const Spacer(),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Dengan mendaftar, Anda menyetujui\n',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                              text: 'Syarat dan Ketentuan',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            const TextSpan(
                              text: ' dan ',
                            ),
                            TextSpan(
                              text: 'Kebijakan Privasi',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
}
