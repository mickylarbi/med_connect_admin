import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/pharmacy/order.dart';
import 'package:med_connect_admin/screens/home/pharmacy/orders/order_details_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/orders/orders_list_page.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/utils/functions.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderHistoryScreen({Key? key}) : super(key: key);

  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: db.myOrders.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Icon(Icons.error_rounded));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }

                  List<Order> ordersList = snapshot.data!.docs
                      .map((e) => Order.fromFirestore(e.data(), e.id))
                      .where((element) =>
                          element.status == OrderStatus.canceled ||
                          element.status == OrderStatus.delivered)
                      .toList();

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(36, 100, 36, 50),
                    itemCount: ordersList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        GestureDetector(
                      onTap: () {
                        navigate(
                            context,
                            OrderDetailsScreen(
                              order: ordersList[index],
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(.2),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ordersList[index].id!),
                                Text(
                                    '${DateFormat.yMMMMd().format(ordersList[index].dateTime!)} ${DateFormat.jm().format(ordersList[index].dateTime!)}'),
                              ],
                            ),
                            CircleAvatar(
                              backgroundColor:
                                  orderStatusColor(ordersList[index].status!),
                              radius: 14,
                              child: Icon(
                                orderStatusIconData(ordersList[index].status!),
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 20),
                  );
                }),
            const CustomAppBar(title: 'History')
          ],
        ),
      ),
    );
  }
}
