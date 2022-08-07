import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/models/doctor.dart';
import 'package:med_connect_admin/models/experience.dart';
import 'package:med_connect_admin/screens/onboarding/edit_available_hours_screen.dart';
import 'package:med_connect_admin/screens/onboarding/edit_experience_screen.dart';
import 'package:med_connect_admin/screens/onboarding/summary_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_textformfield.dart';
import 'package:med_connect_admin/screens/shared/outline_icon_button.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/functions.dart';
import 'package:time_range_picker/time_range_picker.dart';

class DoctorInfoScreen extends StatefulWidget {
  final Doctor? doctor;
  const DoctorInfoScreen({Key? key, this.doctor}) : super(key: key);

  @override
  State<DoctorInfoScreen> createState() => _DoctorInfoScreenState();
}

class _DoctorInfoScreenState extends State<DoctorInfoScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<bool> canGoNext = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isDone = ValueNotifier<bool>(false);

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

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

  final ValueNotifier<List<String>> _servicesNotifier =
      ValueNotifier<List<String>>([]);
  final TextEditingController _servicesController = TextEditingController();

  final ValueNotifier<List<DateTimeRange>> _availableHoursNotifier =
      ValueNotifier<List<DateTimeRange>>([]);

  List pagesList() => [
        namePage(),
        currentLocationPage(),
        experiencesPage(),
        mainSpecialtyPage(),
        otherSpecialtiesPage(),
        servicesPage(),
        // availableHoursPage(),
        // summaryPage(),
      ];

  @override
  void initState() {
    super.initState();

    if (widget.doctor != null) {
      _firstNameController.text = widget.doctor!.firstName!;
      _surnameController.text = widget.doctor!.surname!;

      _currentLocationController.text =
          widget.doctor!.currentLocation!.location!;
      _currentLocationStartDateNotifier.value =
          widget.doctor!.currentLocation!.dateTimeRange!.start;

      _experiencesNotifier.value = widget.doctor!.experiences!;

      _mainSpecialtyController.text = widget.doctor!.mainSpecialty!;

      _otherSpecialtiesNotifier.value = widget.doctor!.otherSpecialties!;

      _servicesNotifier.value = widget.doctor!.services!;

      _availableHoursNotifier.value = widget.doctor!.availablehours!;
    }

    _pageController.addListener(() {
      if (_pageController.page == pagesList().length - 1) {
        isDone.value == true;
      } else if ((_pageController.page == 0 &&
              (_firstNameController.text.trim().isEmpty ||
                  _surnameController.text.trim().isEmpty)) ||
          (_pageController.page == 1 &&
              (_currentLocationController.text.trim().isEmpty ||
                  _currentLocationStartDateNotifier.value == null)) ||
          (_pageController.page == 2 && _experiencesNotifier.value.isEmpty) ||
          (_pageController.page == 3 &&
              _mainSpecialtyController.text.trim().isEmpty) ||
          (_pageController.page == 4 &&
              _otherSpecialtiesNotifier.value.isEmpty) ||
          (_pageController.page == 5 && _servicesNotifier.value.isEmpty)) {
        canGoNext.value = false;
        isDone.value = false;
      } else {
        isDone.value = false;
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

    ///current location page listeners

    _currentLocationController.addListener(() {
      if (_currentLocationController.text.trim().isEmpty ||
          _currentLocationStartDateNotifier.value == null) {
        canGoNext.value = false;
      } else {
        canGoNext.value = true;
      }
    });
    _currentLocationStartDateNotifier.addListener(() {
      if (_currentLocationController.text.trim().isEmpty ||
          _currentLocationStartDateNotifier.value == null) {
        canGoNext.value = false;
      } else {
        canGoNext.value = true;
      }
    });

    ///experience page listeners

    _experiencesNotifier.addListener(() {
      if (_experiencesNotifier.value.isEmpty) {
        canGoNext.value = false;
      } else {
        canGoNext.value = true;
      }
    });

    ///main specialty page listeners

    _mainSpecialtyController.addListener(() {
      if (_mainSpecialtyController.text.trim().isEmpty) {
        canGoNext.value = false;
      } else {
        canGoNext.value = true;
      }
    });

    ///other specialties page listeners

    _otherSpecialtiesNotifier.addListener(() {
      if (_otherSpecialtiesNotifier.value.isEmpty) {
        canGoNext.value = false;
      } else {
        canGoNext.value = true;
      }
    });

    ///services page listeners

    _servicesNotifier.addListener(() {
      if (_servicesNotifier.value.isEmpty) {
        canGoNext.value = false;
      } else {
        canGoNext.value = true;
      }
    });

    ///working hours page listeners

    _availableHoursNotifier.addListener(() {
      if (_availableHoursNotifier.value.isEmpty) {
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
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: pagesList().map((e) => _bluePrint(e)).toList(),
                ),
              ),
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

  Center _bluePrint(List<Widget> children) {
    //TODO: alternate pictures
    return Center(
      child: SingleChildScrollView(
        // controller: controller,
        padding: const EdgeInsets.fromLTRB(36, 88, 36, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image.asset(
                'assets/images/undraw_doctors_hwty.png',
                width: kScreenWidth(context) - 72,
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(height: 30),
            ...children
          ],
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
        ),
        const SizedBox(height: 14),
        CustomTextFormField(
          hintText: 'Surname',
          controller: _surnameController,
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
        const SizedBox(height: 50),
        skipButton()
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
        skipButton()
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
        CustomTextFormField(
          hintText: 'Enter specialty',
          controller: _otherSpecialtiesController,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) {
            if (!_otherSpecialtiesNotifier.value.contains(value)) {
              _otherSpecialtiesController.clear();
              List<String> temp = _otherSpecialtiesNotifier.value;
              temp.add(value.trim());
              _otherSpecialtiesNotifier.value = [...temp];
            }
          },
        ),
        const SizedBox(height: 50),
        skipButton()
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
        CustomTextFormField(
          hintText: 'Enter service',
          controller: _servicesController,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) {
            if (!_servicesNotifier.value.contains(value)) {
              _servicesController.clear();
              List<String> temp = _servicesNotifier.value;
              temp.add(value.trim());
              _servicesNotifier.value = [...temp];
            }
          },
        ),
        const SizedBox(height: 50),
        skipButton()
      ];

  List<Widget> availableHoursPage() => [
        const Text(
          'What times work for you?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 30),
        ValueListenableBuilder(
          valueListenable: _availableHoursNotifier,
          builder:
              (BuildContext context, List<DateTimeRange> value, Widget? child) {
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
                        Text(
                            '${value[index].start.hour}:${value[index].start.minute} - ${value[index].end.hour}:${value[index].end.minute}'),
                        IconButton(
                          onPressed: () {
                            List<DateTimeRange> temp = value;
                            temp.removeAt(index);
                            _availableHoursNotifier.value = [...temp];
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
        Material(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () async {
              var result = await showTimeRangePicker(context: context);

              print(result.toString());

              // if (result != null && result.action == EditAction.edit) {
              //   List<DateTimeRange> temp = _availableHoursNotifier.value;
              //   temp.add(result.object);
              //   _availableHoursNotifier.value = [...temp];
              // }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Edit available hours',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.add),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 50),
        skipButton()
      ];

  List<Widget> summaryPage() => [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Summary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            OutlineIconButton(
                iconData: Icons.edit,
                onPressed: () {
                  _pageController.jumpToPage(0);
                })
          ],
        ),
        const SizedBox(height: 30),
        const Text('Name:'),
        Text(
          '${_firstNameController.text.trim()} ${_surnameController.text.trim()}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text('Current location:'),
        if (_currentLocationStartDateNotifier.value != null)
          Text(
            '${_currentLocationController.text.trim()} (since ${DateFormat.yMMMMd().format(_currentLocationStartDateNotifier.value!)})',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 20),
        const Text('Experience:'),
        if (_experiencesNotifier.value.isEmpty) const Text('-'),
        if (_experiencesNotifier.value.isNotEmpty)
          Column(
              children: _experiencesNotifier.value
                  .map((e) => Text(e.toString()))
                  .toList()),
        const SizedBox(height: 20),
        const Text('Main Specialty:'),
        Text(
          '${_mainSpecialtyController.text.trim()}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text('Other specialties:'),
        if (_otherSpecialtiesNotifier.value.isEmpty) const Text('-'),
        if (_otherSpecialtiesNotifier.value.isNotEmpty)
          Column(
              children:
                  _otherSpecialtiesNotifier.value.map((e) => Text(e)).toList()),
        const SizedBox(height: 20),
        const Text('Services provided:'),
        if (_servicesNotifier.value.isEmpty) const Text('-'),
        if (_servicesNotifier.value.isNotEmpty)
          Column(
              children: _servicesNotifier.value.map((e) => Text(e)).toList()),
      ];

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
                              builder: (context) => SummaryScreen(
                                    doctor: Doctor(
                                        firstName:
                                            _firstNameController.text.trim(),
                                        surname: _surnameController.text.trim(),
                                        currentLocation: Experience(
                                          location: _currentLocationController
                                              .text
                                              .trim(),
                                          dateTimeRange: DateTimeRange(
                                            start:
                                                _currentLocationStartDateNotifier
                                                        .value ??
                                                    DateTime.now(),
                                            end: DateTime.now(),
                                          ),
                                        ),
                                        experiences: _experiencesNotifier.value,
                                        mainSpecialty: _mainSpecialtyController
                                            .text
                                            .trim(),
                                        otherSpecialties:
                                            _otherSpecialtiesNotifier.value,
                                        services: _servicesNotifier.value),
                                  )),
                          (route) => false);
                    } else {
                      _pageController.nextPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOutQuint);
                    }
                  }
                : null,
            child: ValueListenableBuilder<bool>(
                valueListenable: isDone,
                builder: (context, value, child) {
                  return value
                      ? const Text('Done')
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text('Next'),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_right_alt_rounded, size: 20),
                          ],
                        );
                }),
          );
        });
  }

  //TODO: profile image

  Widget skipButton() {
    return ValueListenableBuilder<bool>(
        valueListenable: canGoNext,
        builder: (context, value, child) {
          return value
              ? const SizedBox()
              : Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      _pageController.nextPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOutQuint);
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                );
        });
  }

  @override
  void dispose() {
    _pageController.dispose();
    canGoNext.dispose();
    isDone.dispose();

    _firstNameController.dispose();
    _surnameController.dispose();

    _currentLocationController.dispose();
    _currentLocationStartDateNotifier.dispose();

    _experiencesNotifier.dispose();

    _mainSpecialtyController.dispose();

    _otherSpecialtiesNotifier.dispose();
    _otherSpecialtiesController.dispose();

    _servicesNotifier.dispose();

    _availableHoursNotifier.dispose();
    super.dispose();
  }
}
