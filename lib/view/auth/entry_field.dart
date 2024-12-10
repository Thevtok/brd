// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EntryField extends StatefulWidget {
  final String title;
  final String hint;
  bool? bintang;
  final TextEditingController controller;
  final IconData icon;
  final FormFieldValidator<String>?
      validator; // Parameter opsional untuk validator
  final TextInputType keyboardType;

  EntryField({
    super.key,
    this.bintang,
    required this.title,
    required this.controller,
    required this.hint,
    required this.icon,
    this.validator,
    required this.keyboardType,
  });

  @override
  State<EntryField> createState() => _EntryFieldState();
}

class _EntryFieldState extends State<EntryField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.bintang == true
              ? RichText(
                  text: TextSpan(
                    text: widget.title,
                    style: const TextStyle(color: Colors.black),
                    children: const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  widget.title,
                ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Warna background abu-abu
              borderRadius:
                  BorderRadius.circular(8), // Membuat sudut melengkung
              // border: Border.all(color: Colors.grey), // Border abu-abu
            ),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: widget.controller,
              validator: widget.validator ??
                  (value) {
                    if (value!.isEmpty) {
                      return '${widget.title} harus diisi';
                    }
                    return null;
                  },
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                hintText: widget.hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),

                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(widget.icon, color: Colors.black.withOpacity(0.5)),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      height: 20,
                      width: 1,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                border: InputBorder.none, // Menghilangkan border default
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class EmailField extends StatefulWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;

  const EmailField({
    super.key,
    required this.title,
    required this.controller,
    required this.hint,
    required this.icon,
    this.validator,
    required this.keyboardType,
  });

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Warna background abu-abu
              borderRadius:
                  BorderRadius.circular(8), // Membuat sudut melengkung
            ),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: widget.controller,
              validator: widget.validator ??
                  (value) {
                    if (value == null || value.isEmpty) {
                      return '${widget.title} harus diisi';
                    }
                    // Regex untuk validasi email
                    final emailRegex =
                        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Masukkan email dengan format valid';
                    }
                    return null;
                  },
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                hintText: widget.hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(widget.icon, color: Colors.black.withOpacity(0.5)),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      height: 20,
                      width: 1,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}


class PasswordField extends StatefulWidget {
  final String title;
  final String hint;
  final TextEditingController controller;

  const PasswordField({
    super.key,
    required this.title,
    required this.controller,
    required this.hint,
  });

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Warna background abu-abu
              borderRadius:
                  BorderRadius.circular(8), // Membuat sudut melengkung
            ),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: widget.controller,
              obscureText: _obscureText,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password harus diisi';
                }
                if (value.length < 8) {
                  return 'Password minimal 8 karakter';
                }
                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  return 'Password harus mengandung setidaknya 1 huruf besar';
                }
                if (!RegExp(r'[0-9]').hasMatch(value)) {
                  return 'Password harus mengandung setidaknya 1 angka';
                }
                if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                  return 'Password harus mengandung setidaknya 1 simbol';
                }
                return null;
              },
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                hintText: widget.hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.lock, color: Colors.black.withOpacity(0.5)),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      height: 20,
                      width: 1,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}


// ignore: must_be_immutable
class AlamatField extends StatefulWidget {
  final String title;
  final String hint;
  bool? bintang;
  final TextEditingController controller;
  final IconData icon;
  final FormFieldValidator<String>?
      validator; // Parameter opsional untuk validator
  final TextInputType keyboardType;

  AlamatField({
    super.key,
    this.bintang,
    required this.title,
    required this.controller,
    required this.hint,
    required this.icon,
    this.validator,
    required this.keyboardType,
  });

  @override
  State<AlamatField> createState() => _AlamatFieldState();
}

class _AlamatFieldState extends State<AlamatField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.bintang == true
              ? RichText(
                  text: TextSpan(
                    text: widget.title,
                    style: const TextStyle(color: Colors.black),
                    children: const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  widget.title,
                ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Warna background abu-abu
              borderRadius:
                  BorderRadius.circular(8), // Membuat sudut melengkung
              // border: Border.all(color: Colors.grey), // Border abu-abu
            ),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: widget.controller,
              validator: widget.validator ??
                  (value) {
                    if (value!.isEmpty) {
                      return '${widget.title} harus diisi';
                    }
                    return null;
                  },
                  maxLines: 5,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                hintText: widget.hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),

             
                border: InputBorder.none, // Menghilangkan border default
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
