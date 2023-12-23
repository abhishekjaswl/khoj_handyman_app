import 'package:avatars/avatars.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/uploadimage_service.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/currentuser_provider.dart';
import '../../../widgets/cstm_datepicker.dart';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({super.key});

  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

enum IconLabel {
  plumbing('Plumbing', Icons.plumbing),
  electrical('Electrical', Icons.electrical_services),
  cleaning('Cleaning Services', Icons.cleaning_services),
  carpentry('Carpentry', Icons.carpenter),
  painting('Painting', Icons.format_paint),
  landscaping('Landscaping', Icons.landscape);

  const IconLabel(this.label, this.icon);
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
  Gender genderView = Gender.male;
  IconLabel? selectedIcon;

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
                  padding: const EdgeInsets.all(8.0),
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
                                    EdgeInsets.all(6)),
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
                              selected: <Gender>{genderView},
                              onSelectionChanged: (Set<Gender> newSelection) {
                                setState(() {
                                  genderView = newSelection.first;
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
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        child: DropdownMenu<IconLabel>(
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
                          onSelected: (IconLabel? icon) {
                            setState(() {
                              selectedIcon = icon;
                            });
                          },
                          dropdownMenuEntries: IconLabel.values
                              .map<DropdownMenuEntry<IconLabel>>(
                            (IconLabel icon) {
                              return DropdownMenuEntry<IconLabel>(
                                value: icon,
                                label: icon.label,
                                leadingIcon: Icon(icon.icon),
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
                          await uploadImageService.showImageSourceDialog(
                            context: context,
                            purpose: 'Citizenship',
                          );
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
                                  child: Provider.of<CurrentUser>(context)
                                          .user
                                          .citizenshipUrl!
                                          .isEmpty
                                      ? DottedBorder(
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
                                        )
                                      : Avatar(
                                          shape: AvatarShape.circle(5),
                                          sources: [
                                            NetworkSource(
                                                Provider.of<CurrentUser>(
                                                        context)
                                                    .user
                                                    .citizenshipUrl!)
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
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
                                  child: Provider.of<CurrentUser>(context)
                                          .user
                                          .citizenshipUrl!
                                          .isEmpty
                                      ? DottedBorder(
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
                                        )
                                      : Avatar(
                                          shape: AvatarShape.circle(5),
                                          sources: [
                                            NetworkSource(
                                                Provider.of<CurrentUser>(
                                                        context)
                                                    .user
                                                    .citizenshipUrl!)
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
