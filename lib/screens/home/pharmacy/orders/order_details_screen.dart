import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/patient/patient.dart';
import 'package:med_connect_admin/models/pharmacy/drug.dart';
import 'package:med_connect_admin/models/pharmacy/order.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/patient_profile_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drug_details_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drugs_list_page.dart';
import 'package:med_connect_admin/screens/home/pharmacy/orders/orders_list_page.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';
import 'package:med_connect_admin/utils/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;
  OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  FirestoreService db = FirestoreService();
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              children: [
                const SizedBox(height: 100),
                const Text(
                  'Date ordered:',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  '${DateFormat.yMMMMd().format(order.dateTime!)} at ${DateFormat.jm().format(order.dateTime!)}',
                ),
                const SizedBox(height: 20),
                ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    MapEntry<String, int> entry = order.cart!.entries
                        .map((e) =>
                            MapEntry<String, int>(e.key, e.value.toInt()))
                        .toList()[index];

                    return StatefulBuilder(builder: (context, setState) {
                      return FutureBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        future: db.drugDocument(entry.key).get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: () {
                                      setState(() {});
                                    }));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Drug drug = Drug.fromFirestore(
                                snapshot.data!.data()!, snapshot.data!.id);

                            return GestureDetector(
                              onTap: () {
                                navigate(
                                    context, DrugDetailsScreen(drug: drug));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                    color: (drug.pharmacyId == auth.uid
                                            ? Colors.blueGrey
                                            : Colors.grey)
                                        .withOpacity(.2),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    DrugImageWidget(
                                      drugId: drug.id!,
                                      height: 70,
                                      width: 70,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            drug.brandName!,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            drug.genericName!,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            drug.group!,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'GH¢ ${drug.price!.toStringAsFixed(2)}',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                'Qty: ${entry.value.toString()}',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        },
                      );
                    });
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemCount: order.cart!.length,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Price'),
                    Text(
                      'GH¢ ${order.totalPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                const Text(
                  'Delivery location:',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(order.locationString!),
                const SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                      fixedSize: Size(kScreenWidth(context) - 72, 48),
                      backgroundColor: Colors.pink.withOpacity(.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                  onPressed: () async {
                    Uri mapUri = Uri.https('www.google.com', '/maps/search/', {
                      'api': '1',
                      'query':
                          '${order.locationGeo!.latitude.toString()},${order.locationGeo!.longitude.toString()}'
                    });

                    try {
                      if (await canLaunchUrl(mapUri)) {
                        await launchUrl(mapUri);
                      } else {
                        showAlertDialog(context);
                      }
                    } catch (e) {
                      showAlertDialog(context);
                    }
                  },
                  child: const Text(
                    'View on map',
                    style: TextStyle(color: Colors.pink),
                  ),
                ),
                const SizedBox(height: 50),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: db.orderDocument(order.id!).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const SizedBox();
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }

                      Order currentOrder = Order.fromFirestore(
                          snapshot.data!.data()!, snapshot.data!.id);

                      return currentOrder.status != OrderStatus.pending
                          ? const SizedBox()
                          : TextButton(
                              style: TextButton.styleFrom(
                                  fixedSize:
                                      Size(kScreenWidth(context) - 72, 48),
                                  backgroundColor:
                                      Colors.orange.withOpacity(.3),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14))),
                              onPressed: () async {
                                showConfirmationDialog(
                                  context,
                                  message: 'Set delivery status to enroute?',
                                  confirmFunction: () {
                                    db.orderDocument(order.id!).update(
                                        {'status': OrderStatus.enroute.index});
                                  },
                                );
                              },
                              child: const Text(
                                'Enroute',
                                style: TextStyle(color: Colors.orange),
                              ),
                            );
                    }),
                const SizedBox(height: 50),
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: db.patientDocument(order.patientId!).get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {}
                    if (snapshot.connectionState == ConnectionState.done) {
                      Patient patient = Patient.fromFirestore(
                          snapshot.data!.data()!, snapshot.data!.id);
                      return Center(
                        child: Column(
                          children: [
                            ProfileImageWidget(
                              height: 100,
                              width: 100,
                              patientId: order.patientId,
                            ),
                            const SizedBox(height: 20),
                            Text(patient.name),
                            TextButton(
                              onPressed: () {
                                showCustomBottomSheet(
                                  context,
                                  [
                                    ListTile(
                                      onTap: () async {
                                        Navigator.pop(context);

                                        Uri phoneUri = Uri(
                                            scheme: 'tel',
                                            path: patient.phone!);

                                        try {
                                          if (await canLaunchUrl(phoneUri)) {
                                            await launchUrl(phoneUri);
                                          } else {
                                            showAlertDialog(context);
                                          }
                                        } catch (e) {
                                          showAlertDialog(context);
                                        }
                                      },
                                      leading: const Icon(Icons.call),
                                      title: const Text('Call patient'),
                                    ),
                                    ListTile(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        Uri smsUri = Uri(
                                          scheme: 'sms',
                                          path: patient.phone!,
                                          queryParameters: <String, String>{
                                            'body': Uri.encodeComponent(
                                              'From MedConnect App\n',
                                            ),
                                          },
                                        );

                                        try {
                                          if (await canLaunchUrl(smsUri)) {
                                            await launchUrl(smsUri);
                                          } else {
                                            showAlertDialog(context);
                                          }
                                        } catch (e) {
                                          showAlertDialog(context);
                                        }
                                      },
                                      leading: const Icon(Icons.sms),
                                      title: const Text('Send an SMS'),
                                    ),
                                    ListTile(
                                      leading: const FaIcon(
                                          FontAwesomeIcons.whatsapp),
                                      title: const Text('WhatsApp'),
                                      onTap: () async {
                                        final Uri whatsAppUri = Uri.parse(
                                            'https://wa.me/+233${patient.phone}?text=From MedConnect');

                                        if (await canLaunchUrl(whatsAppUri)) {
                                          launchUrl(whatsAppUri);
                                        } else {
                                          showAlertDialog(context);
                                        }

                                      },
                                    ),
                                  ],
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Colors.blueGrey.withOpacity(.2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                              ),
                              child: const Text('Contact'),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                )
              ],
            ),
            CustomAppBar(
              title: order.id!,
              actions: [
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: db.orderDocument(order.id!).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const SizedBox();
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator.adaptive();
                      }

                      Order currentOrder = Order.fromFirestore(
                          snapshot.data!.data()!, snapshot.data!.id);

                      return GestureDetector(
                        onTap: () {
                          showAlertDialog(context,
                              message: orderStatusMessage(currentOrder.status!),
                              icon: Icons.info_rounded,
                              iconColor: Colors.blue);
                        },
                        child: CircleAvatar(
                          backgroundColor:
                              orderStatusColor(currentOrder.status!),
                          radius: 14,
                          child: Icon(
                            orderStatusIconData(currentOrder.status!),
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
