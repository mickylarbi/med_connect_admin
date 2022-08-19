import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_textformfield.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class PharmacyInfoScreen extends StatefulWidget {
  const PharmacyInfoScreen({Key? key}) : super(key: key);

  @override
  State<PharmacyInfoScreen> createState() => _PharmacyInfoScreenState();
}

class _PharmacyInfoScreenState extends State<PharmacyInfoScreen> {
  PageController pageController = PageController();

  TextEditingController nameController = TextEditingController();
  ValueNotifier<XFile?> pictureNotifier = ValueNotifier<XFile?>(null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              PageView(
                controller: pageController,
                children: pageViewChildren(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 52 + 72,
                  child: Padding(
                    padding: const EdgeInsets.all(36),
                    child: CustomFlatButton(
                      onPressed: () {
                        // if()
                        pageController.nextPage(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeOutQuint);
                      },
                      child: const Text('Next'),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> pageViewChildren() => [
        namePage(),
        photoPage(),
      ];

  namePage() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageViewHeaderText('What\'s the name of your pharmacy?'),
            const SizedBox(height: 20),
            CustomTextFormField(
              hintText: 'Pharmacy name',
              controller: nameController,
            ),
          ],
        ),
      ),
    );
  }

  photoPage() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(36),
        child: ValueListenableBuilder<XFile?>(
            valueListenable: pictureNotifier,
            builder: (context, value, child) {
              final ImagePicker picker = ImagePicker();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageViewHeaderText('Add a picture'),
                  const SizedBox(height: 20),
                  if (value != null)
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          File(value.path),
                          height: 250,
                          width: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        showCustomBottomSheet(
                          context,
                          [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Take a photo'),
                              onTap: () async {
                                picker
                                    .pickImage(source: ImageSource.camera)
                                    .then((value) {
                                  Navigator.pop(context);
                                  if (value != null) {
                                    pictureNotifier.value = value;
                                  }
                                }).onError((error, stackTrace) {
                                  showAlertDialog(context);
                                });
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo),
                              title: const Text('Choose from gallery'),
                              onTap: () async {
                                picker
                                    .pickImage(source: ImageSource.gallery)
                                    .then((value) {
                                  Navigator.pop(context);
                                  if (value != null) {
                                    pictureNotifier.value = value;
                                  }
                                }).onError((error, stackTrace) {
                                  showAlertDialog(context);
                                });
                              },
                            ),
                          ],
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        backgroundColor: Colors.blueGrey.withOpacity(.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child:
                          Text(value == null ? 'Choose photo' : 'Change photo'),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}

class PageViewHeaderText extends StatelessWidget {
  final String text;
  const PageViewHeaderText(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }
}
