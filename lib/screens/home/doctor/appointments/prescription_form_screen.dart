import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/doctor/prescription.dart';
import 'package:med_connect_admin/models/pharmacy/drug.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drug_details_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drugs_list_page.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drugs_search_delegate.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_textformfield.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';
import 'package:med_connect_admin/utils/functions.dart';

class PrescriptionFormScreen extends StatefulWidget {
  const PrescriptionFormScreen(
      {super.key, required this.drug, required this.appointmentId});

  final Drug drug;
  final String appointmentId;

  @override
  State<PrescriptionFormScreen> createState() => _PrescriptionFormScreenState();
}

class _PrescriptionFormScreenState extends State<PrescriptionFormScreen> {
  ValueNotifier<Map<Drug, int>> cart = ValueNotifier<Map<Drug, int>>({});
  String otherDetails = '';

  FirestoreService db = FirestoreService();

  @override
  void initState() {
    super.initState();
    addToCart(widget.drug);

    cart.addListener(() {
      if (cart.value.isEmpty) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 100),
            children: [
              ValueListenableBuilder<Map<Drug, int>>(
                valueListenable: cart,
                builder: (context, value, child) {
                  return ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.length,
                    itemBuilder: (context, index) => Slidable(
                      endActionPane: ActionPane(
                        extentRatio: .2,
                        motion: const ScrollMotion(),
                        children: [
                          IconButton(
                            onPressed: () {
                              showConfirmationDialog(
                                context,
                                message: 'Remove from cart?',
                                confirmFunction: () {
                                  deleteFromCart(
                                      cart.value.keys.toList()[index]);

                                  if (cart.value.isEmpty) {
                                    Navigator.pop(context);
                                  }
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                      child: checkoutCard(
                          context, cart.value.entries.toList()[index]),
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 14),
                  );
                },
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: CustomTextFormField(
                  hintText: 'Other details',
                  onChanged: (value) {
                    otherDetails = value;
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      onPressed: () {
                        showLoadingDialog(context);
                        db.drugsCollection
                            .get()
                            .timeout(ktimeout)
                            .then((value) async {
                          List<Drug> drugsList = value.docs
                              .map((e) => Drug.fromFirestore(e.data(), e.id))
                              .toList();

                          List<String> groups = [];

                          for (Drug element in drugsList) {
                            if (!groups.contains(element.group)) {
                              groups.add(element.group!);
                            }
                          }

                          Navigator.pop(context);
                          var result = await showSearch(
                              context: context,
                              delegate: DrugSearchDelegate(drugsList, groups,
                                  isFromDoctor: true));

                          if (result != null) {
                            if (cart.value.keys.contains(result)) {
                              showAlertDialog(context,
                                  message: 'Drug has already been added');
                            } else {
                              addToCart(result);
                            }
                          }
                        }).onError((error, stackTrace) {});
                      },
                      elevation: 0,
                      child: const Icon(Icons.add),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 48,
                    child: CustomFlatButton(
                      onPressed: () {
                        showConfirmationDialog(
                          context,
                          message:
                              'Add prescription?\nThis cannot be later changed',
                          confirmFunction: () {
                            showLoadingDialog(context);
                            db.instance
                                .collection('prescriptions')
                                .doc(widget.appointmentId)
                                .set(Prescription(
                                  cart: cart.value.map(
                                      (key, value) => MapEntry(key.id!, value)),
                                  otherDetails: otherDetails,
                                  isUsed: false,
                                ).toMap())
                                .timeout(ktimeout)
                                .then((value) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              Navigator.pop(context);
                              showAlertDialog(context);
                            });
                          },
                        );
                      },
                      child: const Text('Issue prescription'),
                    ),
                  )
                ],
              ),
            ),
          ),
          CustomAppBar(
            onPressedLeading: () {
              showConfirmationDialog(context, message: 'Discard?',
                  confirmFunction: () {
                Navigator.pop(context);
              });
            },
            title: 'Fill prescription',
            actions: [
              ValueListenableBuilder<Map<Drug, int>>(
                valueListenable: cart,
                builder: (context, value, child) {
                  return value.isEmpty
                      ? const SizedBox()
                      : TextButton.icon(
                          onPressed: () {
                            showConfirmationDialog(
                              context,
                              message: 'Discard prescription?',
                              confirmFunction: () {
                                cart.value = {};
                                Navigator.pop(context);
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.remove_shopping_cart_rounded,
                            color: Colors.red,
                          ),
                          label: const Text(
                            'Discard',
                            style: TextStyle(color: Colors.red),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(.2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        );
                },
              ),
            ],
          ),
        ],
      )),
    );
  }

  addToCart(Drug drug) {
    Map<Drug, int> temp = cart.value;
    if (cart.value.keys.contains(drug)) {
      int qty = temp[drug] ?? 0;
      temp[drug] = qty + 1;
    } else {
      temp[drug] = 1;
    }
    cart.value = {...temp};
  }

  removeFromCart(Drug drug) {
    Map<Drug, int> temp = cart.value;
    if (cart.value.keys.contains(drug)) {
      int qty = temp[drug] ?? 0;

      if (qty == 0 || qty == 1) {
        temp.remove(drug);
      } else {
        temp[drug] = qty - 1;
      }
    }
    cart.value = {...temp};
  }

  deleteFromCart(Drug drug) {
    if (cart.value.keys.contains(drug)) {
      Map<Drug, int> temp = cart.value;

      temp.remove(drug);
      cart.value = {...temp};
    }
  }

  GestureDetector checkoutCard(
      BuildContext context, MapEntry<Drug, int> entry) {
    return GestureDetector(
      onTap: () {
        navigate(context, DrugDetailsScreen(drug: entry.key));
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 36),
        decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(.2),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            DrugImageWidget(
              drugId: entry.key.id!,
              height: 100,
              width: 100,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key.genericName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    entry.key.brandName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'GH¢ ${entry.key.price!.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: cart.value[entry.key] == 1
                            ? null
                            : () {
                                removeFromCart(entry.key);
                              },
                        icon: const Icon(Icons.remove_circle),
                      ),
                      Text(cart.value[entry.key].toString()),
                      IconButton(
                        onPressed:
                            cart.value[entry.key]! >= entry.key.quantityInStock!
                                ? null
                                : () {
                                    addToCart(entry.key);
                                  },
                        icon: const Icon(Icons.add_circle),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    cart.dispose();

    super.dispose();
  }
}
