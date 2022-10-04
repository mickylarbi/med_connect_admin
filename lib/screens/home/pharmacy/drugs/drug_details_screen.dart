import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/models/pharmacy/drug.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drugs_list_page.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/edit_drug_details_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/functions.dart';

class DrugDetailsScreen extends StatelessWidget {
  final Drug drug;
  final bool showButton;
  final bool isFromDoctor;
  DrugDetailsScreen(
      {Key? key,
      required this.drug,
      this.showButton = false,
      this.isFromDoctor = false})
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Price',
                        style: labelTextStyle,
                      ),
                      Text(
                        'GH¢ ${drug.price!.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Brand name',
                        style: labelTextStyle,
                      ),
                      Text(drug.brandName!),
                      const SizedBox(height: 20),
                      Text(
                        'General name',
                        style: labelTextStyle,
                      ),
                      Text(drug.genericName!),
                      const SizedBox(height: 20),
                      Text(
                        'Class',
                        style: labelTextStyle,
                      ),
                      Text(drug.group!),
                      const SizedBox(height: 20),
                      Text(
                        'Other details',
                        style: labelTextStyle,
                      ),
                      Text(drug.otherDetails!),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            }),
            if (isFromDoctor)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    height: 48,
                    width: kScreenWidth(context) * .8,
                    child: CustomFlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, drug);
                      },
                      child: const Text('Add to prescription'),
                    ),
                  ),
                ),
              ),
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

TextStyle get labelTextStyle => const TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
