
import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/models/pharmacy/drug.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drugs_list_page.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/edit_drug_details_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect_admin/utils/functions.dart';

class DrugDetailsScreen extends StatelessWidget {
  final Drug drug;
  final bool showButton;
  DrugDetailsScreen({Key? key, required this.drug, this.showButton = false})
      : super(key: key);

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            StatefulBuilder(builder: (context, setState) {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      Center(
                        child: DrugImageWidget(
                          drugId: drug.id!,
                          height: 200,
                          width: 200,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'GH¢ ${drug.price!.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 14),
                      Text(drug.brandName!),
                      const SizedBox(height: 14),
                      Text(drug.genericName!),
                      const SizedBox(height: 14),
                      Text(drug.group!),
                      const SizedBox(height: 14),
                      Text(drug.otherDetails!),
                    ],
                  ),
                ),
              );
            }),
            CustomAppBar(
              actions: [
                if (drug.pharmacyId == auth.uid)
                  OutlineIconButton(
                      iconData: Icons.edit,
                      onPressed: () {
                        navigate(context, EditDrugDetailsScreen(drug: drug));
                      })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
