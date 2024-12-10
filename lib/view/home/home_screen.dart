// ignore_for_file: use_build_context_synchronously

import 'package:brd/utils/storage.dart';
import 'package:brd/view/auth/custom_button.dart';
import 'package:brd/view/auth/login_screen.dart';
import 'package:brd/view/home/add_address_screen.dart';
import 'package:brd/view/home/address_card.dart';
import 'package:brd/view/home/update_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/address_controller.dart';
import '../../model/address.dart';
import '../auth/dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(AddressController());

  @override
  void initState() {
    super.initState();
    controller.scrollController.addListener(() {
      if (controller.scrollController.position.pixels >=
              controller.scrollController.position.maxScrollExtent &&
          !controller.isLoading.value) {
        controller.loadNextPage();
      }
    });
    controller.fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Image.network('src',width: 25,height: 25,),
        title: Text(
          'Daftar Alamat',
          style: TextStyle(
              color: Colors.blue.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const AddAddressScreen());
              },
              icon: Icon(
                Icons.add,
                color: Colors.blue.shade900,
              ))
        ],
      ),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Obx(() {
              if (controller.isLoading.value && controller.addresses.isEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return AddressItem(
                      address: Address(),
                      isLoading: true,
                      onEdit: () {},
                      onDelete: () {},
                      onSetPrimary: () {},
                    );
                  },
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.addresses.length + 1,
                itemBuilder: (context, index) {
                  if (index < controller.addresses.length) {
                    final address = controller.addresses[index];
                    return AddressItem(
                      address: address,
                      isLoading: false,
                      onEdit: () {
                      Get.to(()=> UpdateAddressScreen(address: address));
                      },
                      onDelete: () {
                        _showConfirmationDialogFinal(context, () async {
                          showProcessingDialog();
                          var response = await controller
                              .deleteAddress(address.addressId ?? 0);
                          if (response.contains('Berhasil')) {
                            showSuksesDialog(context, () async {
                            setState(() {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                 controller.fetchAddresses();
                              });
                            }, response);
                          } else {
                            showFailedDialog(context, response);
                          }
                        }, 'Apa Anda yakin ingin menghapus alamat ini?');
                      },
                      onSetPrimary: () {
                        _showConfirmationDialogFinal(context, () async {
                          showProcessingDialog();
                          var response = await controller
                              .primaryAddress(address.addressId ?? 0);
                          if (response.contains('Success')) {
                            showSuksesDialog(context, () async {
                              setState(() {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                 controller.fetchAddresses();
                              });
                            }, response);
                          } else {
                            showFailedDialog(context, response);
                          }
                        }, 'Apa Anda yakin ingin menjadikan alamat ini sebagai alamat utama?');
                      },
                    );
                  }

                  // Show loading indicator at the bottom
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            }),
            const SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () async {
                    showProcessingDialog();

                    await deleteToken();

                    Get.offAll(() => const LoginScreen());
                  },
                  child: CustomButton(
                    splashColor: Colors.blue,
                    title: 'Logout',
                    height: 50,
                    width: 200,
                    font: 20,
                    color: Colors.blue[900]!,
                  ),
                )),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
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
            Navigator.of(context).pop();
          },
        );
      },
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

  Future _showConfirmationDialogFinal(
      BuildContext context, VoidCallback ontap, String msg) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Konfirmasi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'TIDAK',
              ),
            ),
            InkWell(
              onTap: () {
                ontap();
              },
              child: const Text(
                'YA',
              ),
            ),
          ],
        );
      },
    );
  }
}
