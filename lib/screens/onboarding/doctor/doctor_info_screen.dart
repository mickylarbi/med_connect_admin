import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/models/doctor/doctor.dart';
import 'package:med_connect_admin/models/doctor/experience.dart';
import 'package:med_connect_admin/screens/onboarding/doctor/edit_experience_screen.dart';
import 'package:med_connect_admin/screens/onboarding/doctor/doctor_summary_screen.dart';
import 'package:med_connect_admin/screens/onboarding/pharmacy/pharmacy_info.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_textformfield.dart';
import 'package:med_connect_admin/screens/shared/outline_icon_button.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';
import 'package:med_connect_admin/utils/functions.dart';
import 'package:time_range_picker/time_range_picker.dart';

class DoctorInfoScreen extends StatefulWidget {
  final Doctor? doctor;
  final XFile? picture;
  const DoctorInfoScreen({Key? key, this.doctor, this.picture})
      : super(key: key);

  @override
  State<DoctorInfoScreen> createState() => _DoctorInfoScreenState();
}

class _DoctorInfoScreenState extends State<DoctorInfoScreen> {
  final PageController _pageController = PageController();
  late final ValueNotifier<bool> canGoNext;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final FocusNode _surnameNode = FocusNode();

  final TextEditingController _currentLocationController =
      TextEditingController();
  final ValueNotifier<DateTime?> _currentLocationStartDateNotifier =
      ValueNotifier<DateTime?>(null);

  final ValueNotifier<List<Experience>> _experiencesNotifier =
      ValueNotifier<List<Experience>>([]);

  final TextEditingController _mainSpecialtyController =
      TextEditingController();

  final ValueNotifier<List<String>> _otherSpecialtiesNotifier =
      ValueNotifier<List<String>>([]);
  final TextEditingController _otherSpecialtiesController =
      TextEditingController();
  final FocusNode _otherSpecialtiesNode = FocusNode();

  final ValueNotifier<List<String>> _servicesNotifier =
      ValueNotifier<List<String>>([]);
  final TextEditingController _servicesController = TextEditingController();
  final FocusNode _servicesNode = FocusNode();

  final ValueNotifier<XFile?> pictureNotifier = ValueNotifier<XFile?>(null);

  List pagesList() => [
        namePage(),
        currentLocationPage(),
        experiencesPage(),
        mainSpecialtyPage(),
        otherSpecialtiesPage(),
        servicesPage(),
        photoPage(),
      ];

  @override
  void initState() {
    super.initState();

    canGoNext = ValueNotifier<bool>(!(widget.doctor == null));

    if (widget.doctor != null) {
      _firstNameController.text = widget.doctor!.firstName!;
      _surnameController.text = widget.doctor!.surname!;

      if (widget.doctor!.currentLocation != null) {
        _currentLocationController.text =
            widget.doctor!.currentLocation!.location!;
        _currentLocationStartDateNotifier.value =
            widget.doctor!.currentLocation!.dateTimeRange!.start;
      }

      _experiencesNotifier.value = widget.doctor!.experiences!;

      _mainSpecialtyController.text = widget.doctor!.mainSpecialty!;

      _otherSpecialtiesNotifier.value = widget.doctor!.otherSpecialties!;

      _servicesNotifier.value = widget.doctor!.services!;

      pictureNotifier.value = widget.picture;
    }//TODO: add phone number

    _pageController.addListener(() {
      // print(_pageController.page);

      if ((_pageController.page == 0 &&
              (_firstNameController.text.trim().isEmpty ||
                  _surnameController.text.trim().isEmpty)) ||
          (_pageController.page == 1 &&
              _currentLocationController.text.trim().isEmpty) ||
          (_pageController.page == 3 &&
              _mainSpecialtyController.text.trim().isEmpty) ||
          (_pageController.page == 5 && _servicesNotifier.value.isEmpty) ||
          (_pageController.page == 6 && pictureNotifier.value == null)) {
        canGoNext.value = false;
      } else {
        canGoNext.value = true;
      }
    });

    ///name page listeners

    _firstNameController.addListener(() {
      if (_firstNameController.text.trim().isEmpty ||
          _surnameController.text.trim().isEmpty) {
        canGoNext.value = false;
      } else {
        canGoNext.value = true;
      }
    });
    _surnameController.addListener(() {
      if (_firstNameController.text.trim().isEmpty ||
          _surnameController.text.trim().isEmpty) {
        canGoNext.value = false;
      } else {
        canGoNext.value = true;
      }
    });

    //current location page listeners

    _currentLocationController.addListener(() {
      if (_currentLocationController.text.trim().isEmpty) {
        canGoNext.value = false;
      } else {
        canGoNext.value = true;
      }
    });
    // _currentLocationStartDateNotifier.addListener(() {
    //   if (_currentLocationController.text.trim().isEmpty ) {
    //     canGoNext.value = false;
    //   } else {
    //     canGoNext.value = true;
    //   }
    // });

    ///experience page listeners

    // _experiencesNotifier.addListener(() {
    //   if (_experiencesNotifier.value.isEmpty) {
    //     canGoNext.value = false;
    //   } else {
    //     canGoNext.value = true;
    //   }
    // });

    ///main specialty page listeners

    _mainSpecialtyController.addListener(() {
      if (_mainSpecialtyController.text.trim().isEmpty) {
        canGoNext.value = false;
      } else {
        canGoNext.value = true;
      }
    });

    ///other specialties page listeners

    // _otherSpecialtiesNotifier.addListener(() {
    //   if (_otherSpecialtiesNotifier.value.isEmpty) {
    //     canGoNext.value = false;
    //   } else {
    //     canGoNext.value = true;
    //   }
    // });

    ///services page listeners

    _servicesNotifier.addListener(() {
      if (_servicesNotifier.value.isEmpty) {
        canGoNext.value = false;
      } else {
        canGoNext.value = true;
      }
    });

    // profile picture page listener

    pictureNotifier.addListener(() {
      if (pictureNotifier.value == null) {
        canGoNext.value = false;
      } else {
        canGoNext.value = true;
      }
    });

    //TODO: add listeners for all relevant pages
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 88, bottom: 120),
                child: Center(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: pagesList().map((e) => _bluePrint(e)).toList(),
                  ),
                ),
              ),
              if (widget.doctor == null)
                const CustomAppBar(
                  leading: Icons.arrow_back,
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 52 + 72,
                  child: Padding(
                      padding: const EdgeInsets.all(36), child: nextButton()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _bluePrint(List<Widget> children) {
    //TODO: alternate pictures
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 36),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/undraw_doctors_hwty.png',
          ),
          fit: BoxFit.fitWidth,
          opacity: .1,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  List<Widget> namePage() => [
        const Text(
          'Let\'s begin with your name',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 30),
        CustomTextFormField(
          hintText: 'First Name',
          controller: _firstNameController,
          onFieldSubmitted: (value) {
            _surnameNode.requestFocus();
          },
        ),
        const SizedBox(height: 20),
        CustomTextFormField(
          hintText: 'Surname',
          controller: _surnameController,
          focusNode: _surnameNode,
          onFieldSubmitted: (value) {
            _pageController.nextPage(
                duration: const Duration(seconds: 1),
                curve: Curves.easeOutQuint);
          },
        ),
      ];

  List<Widget> currentLocationPage() => [
        const Text(
          'Where you do currently work at?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 30),
        CustomTextFormField(
          hintText: 'Institution / Location',
          controller: _currentLocationController,
        ),
        const SizedBox(height: 20),
        ValueListenableBuilder<DateTime?>(
            valueListenable: _currentLocationStartDateNotifier,
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      var result = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now());

                      if (result != null) {
                        _currentLocationStartDateNotifier.value = result;
                      }
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.calendar_month_outlined),
                        SizedBox(width: 10),
                        Text(
                          'Choose start date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    value == null ? '-' : DateFormat.yMMMMd().format(value),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              _currentLocationStartDateNotifier.value = null;
            },
            child: const Text(
              'Clear date',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ),
        const SizedBox(height: 50),
      ];

  List<Widget> experiencesPage() => [
        const Text(
          'Where else have you worked at?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 30),
        ValueListenableBuilder<List<Experience>>(
          valueListenable: _experiencesNotifier,
          builder:
              (BuildContext context, List<Experience> value, Widget? child) {
            return ListView.separated(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (BuildContext context, int index) {
                return Material(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () async {
                      EditObject? result = await navigate(context,
                          EditExperienceScreen(experience: value[index]));

                      if (result != null) {
                        List<Experience> temp = value;

                        if (result.action == EditAction.edit) {
                          temp[index] = result.object;
                        } else if (result.action == EditAction.delete) {
                          temp.removeAt(index);
                        }
                        _experiencesNotifier.value = [...temp];
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            value[index].toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.edit)
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
        Material(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () async {
              EditObject? result =
                  await navigate(context, const EditExperienceScreen());

              if (result != null && result.action == EditAction.edit) {
                List<Experience> temp = _experiencesNotifier.value;
                temp.add(result.object);
                _experiencesNotifier.value = [...temp];
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add),
                  SizedBox(width: 5),
                  Text(
                    'Add experience',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 50),
      ];

  List<Widget> mainSpecialtyPage() => [
        const Text(
          'What do you do best?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 30),
        CustomTextFormField(
          hintText: 'Main specialty',
          controller: _mainSpecialtyController,
          onFieldSubmitted: (value) {
            _pageController.nextPage(
                duration: const Duration(seconds: 1),
                curve: Curves.easeOutQuint);
          },
        )
      ];

  List<Widget> otherSpecialtiesPage() => [
        const Text(
          'What else are you good at?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 30),
        ValueListenableBuilder(
          valueListenable: _otherSpecialtiesNotifier,
          builder: (BuildContext context, List<String> value, Widget? child) {
            return ListView.separated(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (BuildContext context, int index) {
                return Material(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(value[index]),
                        IconButton(
                          onPressed: () {
                            List<String> temp = value;
                            temp.removeAt(index);
                            _otherSpecialtiesNotifier.value = [...temp];
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                hintText: 'Enter specialty',
                controller: _otherSpecialtiesController,
                textInputAction: TextInputAction.done,
                focusNode: _otherSpecialtiesNode,
                onFieldSubmitted: (value) {
                  onOtherSpecialtiesFieldSubmitted();
                  _otherSpecialtiesNode.requestFocus();
                },
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    onOtherSpecialtiesFieldSubmitted();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )),
            ),
          ],
        ),
        const SizedBox(height: 50),
      ];

  List<Widget> servicesPage() => [
        const Text(
          'What services do you provide?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 30),
        ValueListenableBuilder(
          valueListenable: _servicesNotifier,
          builder: (BuildContext context, List<String> value, Widget? child) {
            return ListView.separated(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (BuildContext context, int index) {
                return Material(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(value[index]),
                        IconButton(
                          onPressed: () {
                            List<String> temp = value;
                            temp.removeAt(index);
                            _servicesNotifier.value = [...temp];
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                hintText: 'Enter service',
                controller: _servicesController,
                textInputAction: TextInputAction.done,
                focusNode: _servicesNode,
                onFieldSubmitted: (value) {
                  onServicesFieldSubmitted();
                  FocusScope.of(context).requestFocus(_servicesNode);
                },
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    onServicesFieldSubmitted();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )),
            ),
          ],
        ),
        const SizedBox(height: 50),
      ];

  photoPage() {
    return [
      ValueListenableBuilder<XFile?>(
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
                      borderRadius: BorderRadius.circular(20),
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
                      backgroundColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      value == null ? 'Choose photo' : 'Change photo',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          })
    ];
  }

  Widget nextButton() {
    return ValueListenableBuilder(
        valueListenable: canGoNext,
        builder: (context, bool value, child) {
          return CustomFlatButton(
            onPressed: value
                ? () {
                    if (_pageController.page == pagesList().length - 1) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => DoctorSummaryScreen(
                              picture: pictureNotifier.value!,
                              doctor: Doctor(
                                firstName: _firstNameController.text.trim(),
                                surname: _surnameController.text.trim(),
                                currentLocation: Experience(
                                  location:
                                      _currentLocationController.text.trim(),
                                  dateTimeRange:
                                      _currentLocationStartDateNotifier.value ==
                                              null
                                          ? null
                                          : DateTimeRange(
                                              start:
                                                  _currentLocationStartDateNotifier
                                                      .value!,
                                              end: DateTime(2100),
                                            ),
                                ),
                                experiences: _experiencesNotifier.value,
                                mainSpecialty:
                                    _mainSpecialtyController.text.trim(),
                                otherSpecialties:
                                    _otherSpecialtiesNotifier.value,
                                services: _servicesNotifier.value,
                              ),
                            ),
                          ),
                          (route) => false);
                    } else {
                      _pageController.nextPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOutQuint);
                    }
                  }
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text('Next'),
                SizedBox(width: 10),
                Icon(Icons.arrow_right_alt_rounded, size: 20),
              ],
            ),
          );
        });
  }

  onOtherSpecialtiesFieldSubmitted() {
    if (!_otherSpecialtiesNotifier.value
            .contains(_otherSpecialtiesController.text.trim()) &&
        _otherSpecialtiesController.text.trim().isNotEmpty) {
      List<String> temp = _otherSpecialtiesNotifier.value;
      temp.add(_otherSpecialtiesController.text.trim());
      _otherSpecialtiesNotifier.value = [...temp];
      _otherSpecialtiesController.clear();
    }
  }

  onServicesFieldSubmitted() {
    if (!_servicesNotifier.value.contains(_servicesController.text.trim()) &&
        _servicesController.text.trim().isNotEmpty) {
      List<String> temp = _servicesNotifier.value;
      temp.add(_servicesController.text.trim());
      _servicesNotifier.value = [...temp];
      _servicesController.clear();
    }
  }

  //TODO: profile image

  @override
  void dispose() {
    _pageController.dispose();
    canGoNext.dispose();

    _firstNameController.dispose();
    _surnameController.dispose();

    _currentLocationController.dispose();
    _currentLocationStartDateNotifier.dispose();

    _experiencesNotifier.dispose();

    _mainSpecialtyController.dispose();

    _otherSpecialtiesNotifier.dispose();
    _otherSpecialtiesController.dispose();
    _otherSpecialtiesNode.dispose();

    _servicesNotifier.dispose();
    _servicesController.dispose();
    _servicesNode.dispose();

    pictureNotifier.dispose();
    super.dispose();
  }
}
