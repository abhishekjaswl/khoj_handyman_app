// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/uploadimage_service.dart';

import '../../../../core/services/user_service.dart';
import '../../../widgets/cstm_datepicker.dart';
import '../../../widgets/cstm_snackbar.dart';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({super.key});

  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

enum Jobs {
  plumbing('Plumbing', Icons.plumbing),
  electrical('Electrical', Icons.electrical_services),
  cleaning('Cleaning Services', Icons.cleaning_services),
  carpentry('Carpentry', Icons.carpenter),
  painting('Painting', Icons.format_paint),
  landscaping('Landscaping', Icons.landscape);

  const Jobs(this.label, this.icon);
  final String label;
  final IconData icon;
}

enum Gender {
  male('Male', Icons.male),
  female('Female', Icons.female),
  other('Other', Icons.family_restroom);

  const Gender(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _UploadDocumentsState extends State<UploadDocuments> {
  final UploadImageService uploadImageService = UploadImageService();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController dropdownController = TextEditingController();
  final UserService userService = UserService();
  Gender selectedGender = Gender.male;
  Jobs? jobView;
  String? selectedJob;
  File? selectedCitizenship;
  File? selectedPaymentQR;

  void uploadKYC() async {
    if (selectedCitizenship != null && _dobController.text.isNotEmpty) {
      await userService.uploadKYC(
        context: context,
        dob: _dobController.text.trim(),
        citizenship: selectedCitizenship!,
        gender: selectedGender.label,
        job: selectedJob,
        paymentQr: selectedPaymentQR,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        CstmSnackBar(
          text: 'Please fill up all the details!',
          type: 'error',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personal Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: CstmDatePicker(
                          controller: _dobController,
                          onDateSelected: (formattedDate) {
                            setState(() {
                              _dobController.text = formattedDate;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Card(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(10))),
                              margin: EdgeInsets.zero,
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Text('Gender:'),
                              ),
                            ),
                            SegmentedButton<Gender>(
                              style: ButtonStyle(
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.all(5.5)),
                                shape: const MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(10)))),
                                overlayColor: MaterialStatePropertyAll(
                                    Theme.of(context).colorScheme.tertiary),
                                foregroundColor: MaterialStatePropertyAll(
                                    Theme.of(context).colorScheme.tertiary),
                              ),
                              segments: Gender.values
                                  .map<ButtonSegment<Gender>>((Gender gender) {
                                return ButtonSegment<Gender>(
                                  value: gender,
                                  label: Text(
                                    gender.label,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  icon: Icon(gender.icon),
                                );
                              }).toList(),
                              selected: <Gender>{selectedGender},
                              onSelectionChanged: (Set<Gender> newSelection) {
                                setState(() {
                                  selectedGender = newSelection.first;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Job',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: DropdownMenu<Jobs>(
                          textStyle: const TextStyle(fontSize: 17),
                          controller: dropdownController,
                          width: MediaQuery.of(context).size.width / 1.1,
                          label:
                              const Text('Select a service you can provide.'),
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            contentPadding: const EdgeInsets.all(13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onSelected: (Jobs? job) {
                            setState(() {
                              jobView = job;
                              selectedJob = job!.label;
                            });
                            print(selectedJob);
                          },
                          dropdownMenuEntries:
                              Jobs.values.map<DropdownMenuEntry<Jobs>>(
                            (Jobs job) {
                              return DropdownMenuEntry<Jobs>(
                                value: job,
                                label: job.label,
                                leadingIcon: Icon(job.icon),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Documents',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          File? selectedImage = await uploadImageService
                              .showImageSourceDialog(context: context);
                          if (selectedImage != null) {
                            setState(() {
                              selectedCitizenship = selectedImage;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              CstmSnackBar(
                                text: 'Cancelled by user!',
                                type: 'error',
                              ),
                            );
                          }
                        },
                        child: Card(
                          color: Theme.of(context).colorScheme.secondary,
                          margin: const EdgeInsets.only(top: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Upload your citizenship:'),
                                SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: selectedCitizenship != null
                                      ? Image.file(selectedCitizenship!)
                                      : DottedBorder(
                                          borderType: BorderType.RRect,
                                          strokeCap: StrokeCap.square,
                                          radius: const Radius.circular(5),
                                          dashPattern: const [2, 0, 5],
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          child: const Center(
                                            child: Icon(
                                              Icons
                                                  .add_photo_alternate_outlined,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          File? selectedImage = await uploadImageService
                              .showImageSourceDialog(context: context);
                          if (selectedImage != null) {
                            setState(() {
                              selectedPaymentQR = selectedImage;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              CstmSnackBar(
                                text: 'Cancelled by user!',
                                type: 'error',
                              ),
                            );
                          }
                        },
                        child: Card(
                          color: Theme.of(context).colorScheme.secondary,
                          margin: const EdgeInsets.only(top: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Upload your payment QR code:'),
                                SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: selectedPaymentQR != null
                                      ? Image.file(selectedPaymentQR!)
                                      : DottedBorder(
                                          borderType: BorderType.RRect,
                                          strokeCap: StrokeCap.square,
                                          radius: const Radius.circular(5),
                                          dashPattern: const [2, 0, 5],
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          child: const Center(
                                            child: Icon(
                                              Icons
                                                  .add_photo_alternate_outlined,
                                              size: 20,
                                            ),
                                          ),
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          uploadKYC();
        },
        label: const Text('Submit KYC'),
        icon: const Icon(
          Icons.drive_folder_upload,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }
}
