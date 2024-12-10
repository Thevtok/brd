import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final double font;
  final Color color;
  final Color splashColor; // Tambahkan parameter untuk warna splash
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.title,
    required this.height,
    required this.width,
    required this.font,
    required this.color,
    required this.splashColor, // Inisialisasi warna splash
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          splashColor: splashColor,
          borderRadius: BorderRadius.circular(10),
          child: 
          Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
              
             
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ,
        ),
      ),
    );
  }
}
