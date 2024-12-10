import 'package:brd/view/auth/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class ProcessingDialog extends StatelessWidget {
  const ProcessingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
       backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      content: Lottie.asset('assets/lottie/loading.json',width: 100,height: 100),
    );
  }
}

class SuksesDialogWidget extends StatelessWidget {
  final String text;
  final VoidCallback ontap;
  final String title;

  const SuksesDialogWidget(
      {super.key,
      required this.text,
      required this.ontap,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Selamat",
        ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            text,
            
          ),
        ],
      ),
      actions: <Widget>[
        InkWell(
          onTap: () {
            ontap();
          },
          child: CustomButton(
            splashColor: Colors.blue,
            title: title,
            width: 80,
            height: 40,
            font: 14,
            color: Colors.blue[900]!,
          ),
        ),
      ],
    );
  }
}

class AlertDialogWidget extends StatelessWidget {
  final String message;
  final VoidCallback ontap;

  const AlertDialogWidget({super.key, required this.message, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Gagal",
        
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            message,
           
          ),
        ],
      ),
      actions: <Widget>[
        InkWell(
          onTap: () {
            ontap();
           
          },
          child:  CustomButton(
              splashColor:Colors.blue,
            title: 'TUTUP',
            width: 80,
            height: 40,
            font: 14,
              color: Colors.blue[900]!,
          ),
        ),
      ],
    );
  }
}