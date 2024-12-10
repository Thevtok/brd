import 'package:brd/view/auth/custom_button.dart';
import 'package:brd/view/auth/dialog.dart';
import 'package:brd/view/auth/entry_field.dart';
import 'package:brd/view/profile/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';

class PasswordScreen extends StatefulWidget {
  final String email;
  const PasswordScreen({super.key, required this.email});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(25),
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   
                    Image.asset(
                      'assets/images/ceklis.png', // Ganti dengan path ilustrasi Anda
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 80,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Verifikasi Kontak',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Email Anda berhasil terverifikasi. Sekarang\nAnda bisa login dengan email',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                      const SizedBox(height: 10),
                        const Text(
                      'Silahkan masukan password yang kamu inginkan',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
            
                    const SizedBox(height: 15),
                    PasswordField(
                        title: 'Password',
                        controller: passController,
                        hint: ''),
            
                    const SizedBox(
                      height: 30,
                    ),
                    CustomButton(
                      splashColor: Colors.blue,
                      title: 'Selanjutnya',
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
                        Navigator.of(context).pop();
                        Get.to(()=>  EditProfileScreen(
                          email:widget.email ,
                          password: passController.text,
                        ));
            
                        //   bool status = await auth.login(
                        //     emailController.text,
                        //     passController.text,
                        //   );
                        //   if (status == true) {
                        //     showSuksesDialog(context, () {
                        //       emailController.clear();
                        //       passController.clear();
                        //       saveAuthentication(true);
                        //       Get.offAll(() => const SplashScreen(
                        //             isLoggedIn: true,
                        //           ));
                        //     }, 'Anda berhasil masuk');
                        //   }
                        //    else {
            
                        //   showFailedDialog(context, 'Email atau password salah!');
                        // }
                      },
                    ),
                    // const SizedBox(
                    //   height: 30,
                    // ),
                
                  ],
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
