import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/firebase_services/storage_service.dart';
import 'package:med_connect_admin/models/pharmacy/drug.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_textformfield.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';
import 'package:med_connect_admin/utils/functions.dart';

class EditDrugDetailsScreen extends StatefulWidget {
  final Drug? drug;
  const EditDrugDetailsScreen({Key? key, this.drug}) : super(key: key);

  @override
  State<EditDrugDetailsScreen> createState() => _EditDrugDetailsScreenState();
}

class _EditDrugDetailsScreenState extends State<EditDrugDetailsScreen> {
  TextEditingController groupController = TextEditingController();
  TextEditingController genericNameController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController otherDetailsController = TextEditingController();
  TextEditingController quantityInStockController =
      TextEditingController(text: '0');

  ValueNotifier<XFile?> pictureNotifier = ValueNotifier<XFile?>(null);

  FirestoreService db = FirestoreService();
  StorageService storage = StorageService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget.drug != null) {
      groupController.text = widget.drug!.group!;
      genericNameController.text = widget.drug!.genericName!;
      brandNameController.text = widget.drug!.brandName!;
      priceController.text = widget.drug!.price!.toStringAsFixed(2);
      quantityInStockController.text = widget.drug!.quantityInStock!.toString();
      otherDetailsController.text = widget.drug!.otherDetails!;
    }
  }
//TODO: over the counter things
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                children: [
                  const SizedBox(height: 100),
                  if (widget.drug != null) changePhotoWidget(),
                  if (widget.drug != null) const SizedBox(height: 50),
                  CustomTextFormField(
                    hintText: 'Class',
                    controller: groupController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    hintText: 'Generic name',
                    controller: genericNameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    hintText: 'Brand name',
                    controller: brandNameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    hintText: 'Price',
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    suffix: const Text('Ghana Cedis'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Quantity in stock',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          )),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          if (int.tryParse(
                                      quantityInStockController.text.trim()) !=
                                  null &&
                              int.tryParse(
                                      quantityInStockController.text.trim())! >
                                  0) {
                            quantityInStockController.text = (int.tryParse(
                                        quantityInStockController.text
                                            .trim())! -
                                    1)
                                .toString();
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Flexible(
                        child: TextField(
                          controller: quantityInStockController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (int.tryParse(
                                  quantityInStockController.text.trim()) !=
                              null) {
                            quantityInStockController.text = (int.tryParse(
                                        quantityInStockController.text
                                            .trim())! +
                                    1)
                                .toString();
                          }
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    hintText: 'More details',
                    controller: otherDetailsController,
                    minLines: 5,
                    maxLines: 10,
                  ),
                  if (widget.drug == null) addPhotoWidget(),
                  const SizedBox(height: 50),
                  CustomFlatButton(
                    child:
                        Text(widget.drug != null ? 'Save changes' : 'Add drug'),
                    onPressed: () {
                      Drug newDrug = Drug(
                        id: widget.drug == null ? null : widget.drug!.id,
                        group: groupController.text.trim(),
                        genericName: genericNameController.text.trim(),
                        brandName: brandNameController.text.trim(),
                        price: double.tryParse(priceController.text.trim()),
                        quantityInStock:
                            int.tryParse(quantityInStockController.text.trim()),
                        otherDetails: otherDetailsController.text.trim(),
                      );

                      if (newDrug == widget.drug) {
                      } else if (newDrug.group!.isEmpty) {
                        showAlertDialog(context,
                            message: 'Please enter a class');
                      } else if (newDrug.genericName!.isEmpty) {
                        showAlertDialog(context,
                            message: 'Generic name field cannot be empty');
                      } else if (newDrug.brandName!.isEmpty) {
                        showAlertDialog(context,
                            message: 'Brand name field cannot be empty');
                      } else if (newDrug.price == null) {
                        showAlertDialog(context,
                            message: 'Enter a valid price');
                      } else if (newDrug.quantityInStock == null) {
                        showAlertDialog(context,
                            message: 'Enter a valid quantity');
                      } else if (newDrug.otherDetails!.isEmpty) {
                        showAlertDialog(context,
                            message: 'Details field cannot be empty');
                      } else if (widget.drug == null &&
                          pictureNotifier.value == null) {
                        showAlertDialog(context,
                            message: 'Please add a picture');
                      } else {
                        showConfirmationDialog(
                          context,
                          message: widget.drug == null
                              ? 'Add drug to inventory?'
                              : 'Update drug info?',
                          confirmFunction: () {
                            showLoadingDialog(context);

                            if (widget.drug != null) {
                              db
                                  .updateDrug(newDrug)
                                  .timeout(ktimeout)
                                  .then((value) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }).onError((error, stackTrace) {
                                Navigator.pop(context);
                                showAlertDialog(context,
                                    message: 'Error updating drug info');
                              });
                            } else {
                              db
                                  .addDrug(newDrug)
                                  .timeout(ktimeout)
                                  .then((drugReference) {
                                storage
                                    .uploadDrugImage(
                                        picture: pictureNotifier.value!,
                                        id: drugReference.id)
                                    .timeout(const Duration(minutes: 2))
                                    .then((value) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }).onError((error, stackTrace) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);

                                  showLoadingDialog(context);
                                  drugReference
                                      .get()
                                      .timeout(ktimeout)
                                      .then((value) {
                                    Navigator.pop(context);
                                    navigate(
                                        context,
                                        EditDrugDetailsScreen(
                                          drug: Drug.fromFirestore(
                                              value.data()!, value.id),
                                        ));
                                    showAlertDialog(context,
                                        message:
                                            'Error uploading image. Please try again');
                                  }).onError((error, stackTrace) {
                                    Navigator.pop(context);
                                    showAlertDialog(context,
                                        message:
                                            'Error uploading image. Please try again');
                                  });
                                });
                              }).onError((error, stackTrace) {
                                Navigator.pop(context);
                                showAlertDialog(context,
                                    message: 'Error adding drug to inventory');
                              });
                            }
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
              CustomAppBar(
                title: 'Drug details',
                actions: [
                  if (widget.drug != null)
                    OutlineIconButton(
                      iconData: Icons.delete,
                      onPressed: () {
                        showConfirmationDialog(
                          context,
                          message: 'Delete drug from inventory',
                          confirmFunction: () {
                            showLoadingDialog(context);
                            db
                                .deleteDrug(widget.drug!.id!)
                                .timeout(ktimeout)
                                .then((value) {
                              storage.deleteDrugImage(id: widget.drug!.id!);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              Navigator.pop(context);
                              showAlertDialog(context,
                                  message:
                                      'Error occured while deleting drug from inventory');
                            });
                          },
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  changePhotoWidget() {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder<String>(
        future: storage.drugImageDownloadUrl(id: widget.drug!.id!),
        builder: (BuildContext context, snapshot) {
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: snapshot.hasError ||
                        snapshot.connectionState != ConnectionState.done
                    ? GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: Container(
                          height: 250,
                          width: 250,
                          color: Colors.grey[200],
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: snapshot.data!,
                        height: 250,
                        width: 250,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator.adaptive(
                              value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.person)),
                      ),
              ),
              const SizedBox(height: 20),
              if (!(snapshot.hasError ||
                  snapshot.connectionState != ConnectionState.done))
                Center(
                  child: TextButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();

                      final ImagePicker picker = ImagePicker();

                      showCustomBottomSheet(
                        context,
                        [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Take a photo'),
                            onTap: () {
                              picker
                                  .pickImage(source: ImageSource.camera)
                                  .then((pickedImage) {
                                Navigator.pop(
                                    context); //TODO: if it still doesn't work, cast the function then do am direct
                                if (pickedImage != null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      alignment: Alignment.center,
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            child: Image.file(
                                              File(pickedImage.path),
                                              fit: BoxFit.cover,
                                              height: 100,
                                              width: 100,
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.grey[200]),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                          ),
                                          child: const Text(
                                            'CANCEL',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: .5),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);

                                            showLoadingDialog(context);
                                            storage
                                                .uploadDrugImage(
                                                    picture: pickedImage,
                                                    id: widget.drug!.id!)
                                                .timeout(
                                                    const Duration(minutes: 2))
                                                .then((p0) {
                                              log('upload done');
                                              Navigator.pop(
                                                  _scaffoldKey.currentContext!);

                                              ScaffoldMessenger.of(_scaffoldKey
                                                      .currentContext!)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Photo updated!')));

                                              setState(() {});
                                            }).onError((error, stackTrace) {
                                              Navigator.pop(context);
                                              showAlertDialog(context,
                                                  message:
                                                      'Error updating image');
                                            });
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Theme.of(context)
                                                        .primaryColor),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                          ),
                                          child: const Text(
                                            'UPLOAD PHOTO',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: .5),
                                          ),
                                        ),
                                      ],
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      actionsPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14),
                                    ),
                                  );
                                }
                              }).onError((error, stackTrace) {
                                showAlertDialog(context);
                              });
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo),
                            title: const Text('Choose from gallery'),
                            onTap: () {
                              picker
                                  .pickImage(source: ImageSource.gallery)
                                  .then((pickedImage) {
                                Navigator.pop(context);
                                if (pickedImage != null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      alignment: Alignment.center,
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            child: Image.file(
                                              File(pickedImage.path),
                                              fit: BoxFit.cover,
                                              height: 100,
                                              width: 100,
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.grey[200]),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                          ),
                                          child: const Text(
                                            'CANCEL',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: .5),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);

                                            showLoadingDialog(context);
                                            storage
                                                .uploadDrugImage(
                                                    picture: pickedImage,
                                                    id: widget.drug!.id!)
                                                .timeout(
                                                    const Duration(minutes: 2))
                                                .then((p0) {
                                              log('upload done');
                                              Navigator.pop(context);
                                              setState(() {});
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Photo updated!')));
                                            }).onError((error, stackTrace) {
                                              Navigator.pop(context);
                                              showAlertDialog(context,
                                                  message:
                                                      'Error updating image');
                                            });
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Theme.of(context)
                                                        .primaryColor),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                          ),
                                          child: const Text(
                                            'UPLOAD PHOTO',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: .5),
                                          ),
                                        ),
                                      ],
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      actionsPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14),
                                    ),
                                  );
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
                    child: const Text(
                      'Change photo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          );
        },
      );
    });
  }

  addPhotoWidget() {
    return ValueListenableBuilder<XFile?>(
        valueListenable: pictureNotifier,
        builder: (context, value, child) {
          final ImagePicker picker = ImagePicker();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    FocusManager.instance.primaryFocus?.unfocus();
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
        });
  }

  @override
  void dispose() {
    groupController.dispose();
    genericNameController.dispose();
    brandNameController.dispose();
    otherDetailsController.dispose();

    pictureNotifier.dispose();

    super.dispose();
  }
}
