// ignore_for_file: use_build_context_synchronously

import 'package:brd/view/auth/dialog.dart';
import 'package:brd/view/auth/password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  const OTPScreen({super.key, required this.email});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  

  List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final auth = Get.put(AuthController());
  void _checkOtpComplete() async {
    String otp = otpControllers.map((e) => e.text).join();
    if (otp.length == 6) {
      showProcessingDialog();

      var respon = await auth.regisVerif(widget.email, otp);
      if (respon.contains('valid')) {
        showSuksesDialog(context, () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Get.to(()=>  PasswordScreen(
            email:widget.email ,
          ));
        }, respon);
      } else {
        showFailedDialog(context, respon);
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        'Verifikasi Kontak',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey, // Warna default teks
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  'Masukan kode verifikasi yang telah kami kirim ke ',
                            ),
                            TextSpan(
                              text: widget.email, // Email dari widget
                              style: const TextStyle(
                                color: Colors.blue, // Warna biru untuk email
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 40,
                            child: TextField(
                              controller: otpControllers[index],
                              keyboardType: TextInputType.text,
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              decoration: const InputDecoration(
                                counterText: "",
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.length == 1 && index < 5) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.length == 1 && index == 5) {
                                  _checkOtpComplete();
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Spacer(),
                      Text(
                        'Tidak menerima kode verifikasi?',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () async {
                          showProcessingDialog();

                          var respon = await auth.resendCode(
                            widget.email,
                          );
                          if (respon.contains('successful')) {
                            showSuksesDialog(context, () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }, respon);
                          } else {
                            showFailedDialog(context, respon);
                          }
                        },
                        child: const Text(
                          'Kirim Ulang',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
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
