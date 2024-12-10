// ignore_for_file: use_build_context_synchronously

import 'package:brd/view/auth/custom_button.dart';
import 'package:brd/view/auth/dialog.dart';
import 'package:brd/view/auth/email_screen.dart';
import 'package:brd/view/auth/entry_field.dart';
import 'package:brd/view/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passController = TextEditingController();

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
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                padding: const EdgeInsets.all(25),
                height: MediaQuery.of(context).size.height * 0.66,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/ct.png',
                        ),
                        fit: BoxFit.fill)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      'assets/images/brc.png', // Ganti dengan path ilustrasi Anda
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 5),
                    EmailField(
                      keyboardType: TextInputType.text,
                      title: 'Email',
                      hint: '',
                      controller: emailController,
                      icon: CupertinoIcons.mail_solid,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    PasswordField(
                        title: 'Password',
                        controller: passController,
                        hint: ''),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Spacer(),
                          Text(
                            "Lupa password?",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomButton(
                      splashColor: Colors.blue,
                      title: 'Masuk',
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

                        String respon = await auth.login(
                          emailController.text,
                          passController.text,
                        );
                        if (respon.contains('Berhasil')) {
                          showSuksesDialog(context, () {
                            emailController.clear();
                            passController.clear();
                           
                            Get.offAll(() => const HomeScreen());
                          }, 'Anda berhasil masuk');
                        } else {
                          showFailedDialog(context, respon);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Belumm memiliki akun?',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const EmailScreen());
                      },
                      child: const Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.55, bottom: 20),
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/cb.png'),
                          fit: BoxFit.fill)),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 70,
                        ),
                        Text("Masuk dengan touch ID",
                            style: TextStyle(color: Colors.grey.shade700)),
                        const SizedBox(height: 5),
                        const Icon(Icons.fingerprint,
                            size: 50, color: Colors.blue),
                        const SizedBox(height: 5),
                        const Text("atau masuk dengan"),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // Warna border
                                  width: 1.5, // Ketebalan border
                                ),
                                borderRadius: BorderRadius.circular(
                                    10), // Sudut border melengkung
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/google.png',
                                  width: 30,
                                  height: 30, // Ukuran gambar
                                ),
                              ),
                            ),
                            const SizedBox(width: 20), // Jarak antar container
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // Warna border
                                  width: 1.5, // Ketebalan border
                                ),
                                borderRadius: BorderRadius.circular(
                                    10), // Sudut border melengkung
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/apple.png',
                                  width: 30,
                                  height: 30, // Ukuran gambar
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Dengan masuk, Anda menyetujui\n',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Syarat dan Ketentuan',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
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
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
