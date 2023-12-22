import 'package:avatars/avatars.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/uploadimage_service.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/currentuser_provider.dart';

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

class _UploadDocumentsState extends State<UploadDocuments> {
  final UploadImageService uploadImageService = UploadImageService();

  final TextEditingController dropdownController = TextEditingController();

  IconLabel? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: DropdownMenu<IconLabel>(
                textStyle: const TextStyle(fontSize: 17),
                controller: dropdownController,
                width: MediaQuery.of(context).size.width / 1.05,
                label: const Text('What service can you provide?'),
                inputDecorationTheme: InputDecorationTheme(
                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onSelected: (IconLabel? icon) {
                  setState(() {
                    selectedIcon = icon;
                  });
                },
                dropdownMenuEntries:
                    IconLabel.values.map<DropdownMenuEntry<IconLabel>>(
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
                                            Icons.add_photo_alternate_outlined,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    : Avatar(
                                        shape: AvatarShape.rectangle(60, 60),
                                        sources: [
                                          NetworkSource(
                                              Provider.of<CurrentUser>(context)
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
                                            Icons.add_photo_alternate_outlined,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    : Avatar(
                                        shape: AvatarShape.rectangle(60, 60),
                                        sources: [
                                          NetworkSource(
                                              Provider.of<CurrentUser>(context)
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
    );
  }
}
