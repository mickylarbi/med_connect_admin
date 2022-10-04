import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/firebase_services/storage_service.dart';
import 'package:med_connect_admin/models/doctor/doctor.dart';
import 'package:med_connect_admin/models/doctor/experience.dart';
import 'package:med_connect_admin/models/review.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/appointment_details_screen.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_home_page/doctor_profile/reviews_list_screen.dart';
import 'package:med_connect_admin/screens/onboarding/doctor/edit_experience_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_textformfield.dart';
import 'package:med_connect_admin/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect_admin/screens/shared/header_text.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';
import 'package:med_connect_admin/utils/functions.dart';

class EditDoctorProfileScreen extends StatefulWidget {
  final Doctor doctor;
  const EditDoctorProfileScreen({Key? key, required this.doctor})
      : super(key: key);

  @override
  State<EditDoctorProfileScreen> createState() =>
      _EditDoctorProfileScreenState();
}

class _EditDoctorProfileScreenState extends State<EditDoctorProfileScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController mainSpecialtyController = TextEditingController();

  ValueNotifier<List<String>> otherSpecialtiesNotifier =
      ValueNotifier<List<String>>([]);
  TextEditingController otherSpecialtiesController = TextEditingController();

  ValueNotifier<List<Experience>> experiencesNotifier =
      ValueNotifier<List<Experience>>([]);

  ValueNotifier<List<String>> servicesNotifier =
      ValueNotifier<List<String>>([]);
  TextEditingController servicesController = TextEditingController();

  TextEditingController currentLocationController = TextEditingController();
  ValueNotifier<DateTime?> currentLocationStartDateNotifier =
      ValueNotifier<DateTime?>(null);

  FirestoreService db = FirestoreService();
  AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();

    firstNameController.text = widget.doctor.firstName!;
    surnameController.text = widget.doctor.surname!;
    bioController.text = widget.doctor.bio ?? '';
    phoneController.text = widget.doctor.phone!;
    mainSpecialtyController.text = widget.doctor.mainSpecialty!;

    otherSpecialtiesNotifier.value = [...widget.doctor.otherSpecialties!];
    experiencesNotifier.value = [...widget.doctor.experiences!];
    servicesNotifier.value = [...widget.doctor.services!];

    if (widget.doctor.currentLocation != null) {
      currentLocationController.text = widget.doctor.currentLocation!.location!;

      if (widget.doctor.currentLocation!.dateTimeRange != null) {
        currentLocationStartDateNotifier.value =
            widget.doctor.currentLocation!.dateTimeRange!.start;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 88, bottom: 120),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            future: db.instance
                                .collection('doctor_reviews')
                                .where('doctorId', isEqualTo: widget.doctor.id)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {}

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.data == null ||
                                    !snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return const SizedBox();
                                }

                                List<Review> reviewsList = snapshot.data!.docs
                                    .map(
                                      (e) => Review.fromFirestore(e.data()),
                                    )
                                    .toList();

                                double totalRating = 0;
                                for (Review element in reviewsList) {
                                  totalRating += element.rating!;
                                }
                                totalRating /= reviewsList.length;

                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const HeaderText(text: 'Reviews'),
                                        TextButton(
                                          style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 14))),
                                          onPressed: () {
                                            navigate(
                                                context,
                                                ReviewListScreen(
                                                    reviews: reviewsList));
                                          },
                                          child: const Text('See all'),
                                        ),
                                      ],
                                    ),
                                    ReviewCard(
                                      review: reviewsList
                                          .where((element) =>
                                              element.comment != null &&
                                              element.comment!.isNotEmpty)
                                          .toList()[0],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        const Text('Total rating'),
                                        const Spacer(),
                                        const Icon(Icons.star,
                                            color: Colors.yellow),
                                        HeaderText(
                                            text:
                                                totalRating.toStringAsFixed(1)),
                                      ],
                                    )
                                  ],
                                );
                              }

                              return const SizedBox();
                            }),
                        const SizedBox(height: 30),
                        const ChangeProfileImageWidget(),
                        const SizedBox(height: 30),
                        const Text(
                          'Personal info',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          hintText: 'First name',
                          controller: firstNameController,
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          hintText: 'Last name',
                          textCapitalization: TextCapitalization.words,
                          controller: surnameController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          hintText: 'Bio',
                          controller: bioController,
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          hintText: 'Phone',
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          prefix: const Text('+233'),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                            onPressed: null,
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.grey.withOpacity(.1),
                                foregroundColor: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                fixedSize: const Size(double.maxFinite, 48)),
                            child: Text(
                              widget.doctor.licenseId!,
                              style: const TextStyle(color: Colors.blueGrey),
                            )),
                        const Divider(height: 70),
                        const Text(
                          'Specialties',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          hintText: 'Main specialty',
                          controller: mainSpecialtyController,
                        ),
                        const SizedBox(height: 30),
                        const Text('Other specialties'),
                        ValueListenableBuilder<List<String>?>(
                          valueListenable: otherSpecialtiesNotifier,
                          builder: (BuildContext context, List<String>? value,
                              Widget? child) {
                            return value == null
                                ? const SizedBox()
                                : ListView.separated(
                                    shrinkWrap: true,
                                    primary: false,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: value.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const SizedBox(height: 10);
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Material(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(14),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 36, vertical: 14),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(value[index]),
                                              GestureDetector(
                                                  onTap: () {
                                                    List<String> temp = value;
                                                    temp.removeAt(index);
                                                    otherSpecialtiesNotifier
                                                        .value = [...temp];
                                                  },
                                                  child:
                                                      const Icon(Icons.clear))
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
                                controller: otherSpecialtiesController,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) {
                                  onOtherSpecialtiesFieldSubmitted();
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
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
                        const Divider(height: 70),
                        const Text(
                          'Experience',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<List<Experience>>(
                          valueListenable: experiencesNotifier,
                          builder: (BuildContext context,
                              List<Experience> value, Widget? child) {
                            return ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: value.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 10);
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return Material(
                                  color: Colors.blueGrey[50],
                                  borderRadius: BorderRadius.circular(14),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(14),
                                    onTap: () async {
                                      EditObject? result = await navigate(
                                          context,
                                          EditExperienceScreen(
                                              experience: value[index]));

                                      if (result != null) {
                                        List<Experience> temp = value;

                                        if (result.action == EditAction.edit) {
                                          temp[index] = result.object;
                                        } else if (result.action ==
                                            EditAction.delete) {
                                          temp.removeAt(index);
                                        }
                                        experiencesNotifier.value = [...temp];
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 36, vertical: 14),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            value[index].toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
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
                              EditObject? result = await navigate(
                                  context, const EditExperienceScreen());

                              if (result != null &&
                                  result.action == EditAction.edit) {
                                List<Experience> temp =
                                    experiencesNotifier.value;
                                temp.add(result.object);
                                experiencesNotifier.value = [...temp];
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 36, vertical: 14),
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
                        const Divider(height: 70),
                        const Text(
                          'Services',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        ValueListenableBuilder(
                          valueListenable: servicesNotifier,
                          builder: (BuildContext context, List<String> value,
                              Widget? child) {
                            return ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: value.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(value[index]),
                                        IconButton(
                                          onPressed: () {
                                            List<String> temp = value;
                                            temp.removeAt(index);
                                            servicesNotifier.value = [...temp];
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
                                controller: servicesController,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (value) {
                                  onServicesFieldSubmitted();
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                    child: Text(
                                      'Add',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),
                        const Divider(height: 70),
                        CustomTextFormField(
                          hintText: 'Institution / Location',
                          controller: currentLocationController,
                        ),
                        const SizedBox(height: 20),
                        ValueListenableBuilder<DateTime?>(
                            valueListenable: currentLocationStartDateNotifier,
                            builder: (context, value, child) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        currentLocationStartDateNotifier.value =
                                            result;
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
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    value == null
                                        ? '-'
                                        : DateFormat.yMMMMd().format(value),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                  child: SizedBox(
                    height: 50,
                    child: CustomFlatButton(
                      child: const Text('Save changes'),
                      onPressed: () {
                        Doctor newDoctor = Doctor(
                          firstName: firstNameController.text.trim(),
                          surname: surnameController.text.trim(),
                          bio: bioController.text.trim(),
                          phone: phoneController.text.trim(),
                          mainSpecialty: mainSpecialtyController.text.trim(),
                          otherSpecialties: otherSpecialtiesNotifier.value,
                          experiences: experiencesNotifier.value,
                          services: servicesNotifier.value,
                          currentLocation: Experience(
                              location: currentLocationController.text.trim(),
                              dateTimeRange:
                                  currentLocationStartDateNotifier.value == null
                                      ? null
                                      : DateTimeRange(
                                          start:
                                              currentLocationStartDateNotifier
                                                  .value!,
                                          end: widget.doctor.currentLocation!
                                              .dateTimeRange!.end)),
                        );

                        if (newDoctor == widget.doctor) {
                        } else if (newDoctor.firstName!.trim().isEmpty ||
                            newDoctor.surname!.trim().isEmpty) {
                          showAlertDialog(context,
                              message: 'Name fields cannot be empty');
                        } else if (newDoctor.phone!.trim().isEmpty) {
                          showAlertDialog(context,
                              message: 'Please enter a phone number');
                        } else if (newDoctor.phone!.trim().length < 10) {
                          showAlertDialog(context,
                              message: 'Please enter a valid phone number');
                        } else if (newDoctor.mainSpecialty!.trim().isEmpty) {
                          showAlertDialog(context,
                              message: 'Main specialty field cannot be empty');
                        } else if (newDoctor.services!.isEmpty) {
                          showAlertDialog(context,
                              message: 'Services field cannot be empty');
                        } else {
                          showConfirmationDialog(
                            context,
                            message: 'Update profile info',
                            confirmFunction: () {
                              showLoadingDialog(context);
                              db
                                  .updateAdmin(newDoctor)
                                  .timeout(const Duration(seconds: 30))
                                  .then((value) {
                                Navigator.pop(context);
                                Navigator.pop(context,
                                    EditObject(action: EditAction.edit));
                              }).onError((error, stackTrace) {
                                Navigator.pop(context);
                                showAlertDialog(context,
                                    message:
                                        'Couldn\'t update profile info. Try again');
                              });
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              CustomAppBar(
                title: 'Edit Profile',
                leading: Icons.arrow_back,
                actions: [
                  SolidIconButton(
                    color: Colors.red,
                    iconData: Icons.logout,
                    onPressed: () {
                      showConfirmationDialog(
                        context,
                        message: 'Sign out?',
                        confirmFunction: () {
                          auth.signOut(context);
                        },
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onOtherSpecialtiesFieldSubmitted() {
    if (!otherSpecialtiesNotifier.value
        .contains(otherSpecialtiesController.text.trim())) {
      List<String> temp = otherSpecialtiesNotifier.value;
      temp.add(otherSpecialtiesController.text.trim());
      otherSpecialtiesNotifier.value = [...temp];
      otherSpecialtiesController.clear();
    }
  }

  void onServicesFieldSubmitted() {
    if (!servicesNotifier.value.contains(servicesController.text.trim())) {
      List<String> temp = servicesNotifier.value;
      temp.add(servicesController.text.trim());
      servicesNotifier.value = [...temp];
      servicesController.clear();
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    surnameController.dispose();
    bioController.dispose();
    phoneController.dispose();
    mainSpecialtyController.dispose();

    otherSpecialtiesNotifier.dispose();
    otherSpecialtiesController.dispose();

    experiencesNotifier.dispose();

    servicesNotifier.dispose();
    servicesController.dispose();

    currentLocationStartDateNotifier.dispose();

    super.dispose();
  }
}

class ChangeProfileImageWidget extends StatefulWidget {
  const ChangeProfileImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeProfileImageWidget> createState() =>
      _ChangeProfileImageWidgetState();
}

class _ChangeProfileImageWidgetState extends State<ChangeProfileImageWidget> {
  AuthService auth = AuthService();

  StorageService storage = StorageService();

  ValueNotifier<XFile?> pictureNotifier = ValueNotifier<XFile?>(null);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: FutureBuilder<String>(
        future: storage.profileImageDownloadUrl(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return Stack(
            alignment: Alignment.center,
            children: [
              if (snapshot.connectionState == ConnectionState.done)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: snapshot.data!,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator.adaptive(
                                value: downloadProgress.progress)),
                    errorWidget: (context, _, __) {
                      return const Center(
                        child: Icon(Icons.person),
                      );
                    },
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              if (snapshot.connectionState == ConnectionState.done)
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Material(
                    color: Colors.black.withOpacity(.3),
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () {
                        if (snapshot.data != null) {
                          final ImagePicker picker = ImagePicker();

                          showCustomBottomSheet(context, [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Take a photo'),
                              onTap: () async {
                                picker
                                    .pickImage(source: ImageSource.camera)
                                    .then((value) {
                                  Navigator.pop(context);
                                  if (value != null) {
                                    showLoadingDialog(context);
                                    storage
                                        .uploadProfileImage(value)
                                        .timeout(ktimeout)
                                        .then((value) {
                                      Navigator.pop(context);
                                      setState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Profile image changed!')));
                                    }).onError((error, stackTrace) {
                                      Navigator.pop(context);
                                      showAlertDialog(context,
                                          message: 'Couldn\'t upload image');
                                    });
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
                                    showLoadingDialog(context);
                                    storage
                                        .uploadProfileImage(value)
                                        .timeout(ktimeout)
                                        .then((value) {
                                      Navigator.pop(context);
                                      setState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Profile image changed!')));
                                    }).onError((error, stackTrace) {
                                      Navigator.pop(context);
                                      showAlertDialog(context,
                                          message: 'Couldn\'t upload image');
                                    });
                                  }
                                }).onError((error, stackTrace) {
                                  showAlertDialog(context);
                                });
                              },
                            ),
                          ]);
                        } else {
                          setState(() {});
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null)
                const Center(
                  child: Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                  ),
                ),

              ///

              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    pictureNotifier.dispose();
    super.dispose();
  }
}
