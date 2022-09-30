import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:med_connect_admin/models/pharmacy/drug.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drugs_list_page.dart';

class DrugSearchDelegate extends SearchDelegate {
  List<Drug> drugsList;
  List<String> groups;
  bool isFromDoctor;
  DrugSearchDelegate(this.drugsList, this.groups, {this.isFromDoctor = false});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        primaryColor: Colors.blueGrey,
        primarySwatch: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.blueGrey),
        textTheme: GoogleFonts.openSansTextTheme(
          const TextTheme(
            bodyText2: TextStyle(color: Colors.blueGrey, letterSpacing: .2),
          ),
        ),
        appBarTheme: AppBarTheme(
          iconTheme: const IconThemeData(color: Colors.blueGrey),
          elevation: 0,
          backgroundColor: Colors.grey[50],
        ));
  }

  @override
  String? get searchFieldLabel => 'Search by brand or generic name';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Opacity(
        opacity: query.isEmpty ? 0 : 1,
        child: IconButton(
          onPressed: () {
            query = '';
          },
          icon: CircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 10,
            child: const Center(
              child: Icon(
                Icons.clear,
                size: 14,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  // @override
  // PreferredSizeWidget? buildBottom(BuildContext context) {
  //   return PreferredSize(
  //     child: ListView.separated(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: 20,
  //       itemBuilder: (context, index) => Card(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //         elevation: 0,
  //       ),
  //       separatorBuilder: (context, index) => Container(),
  //     ),
  //     preferredSize: Size(kScreenWidth(context), 100),
  //   );
  // }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return body;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return body;
  }

  Widget get body {
    List<Drug> searchHits = [];
    List<Drug> temp = drugsList
        .where((element) =>
            element.brandName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    temp.sort((a, b) => a.brandName!.compareTo(b.brandName!));
    searchHits.addAll(temp);

    temp = drugsList
        .where((element) =>
            element.genericName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    temp.sort((a, b) => a.genericName!.compareTo(b.genericName!));
    searchHits.addAll(temp.where((element) => !drugsList.contains(element)));

    temp = drugsList
        .where((element) =>
            element.group!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    temp.sort((a, b) => a.group!.compareTo(b.group!));
    searchHits.addAll(temp.where((element) => !drugsList.contains(element)));

    Map<String, List<Drug>> categories = {};

    for (Drug element in searchHits) {
      if (categories[element.group] == null) {
        categories[element.group!] = [element];
      } else {
        categories[element.group!]!.add(element);
      }
    }

    groups = categories.keys.toList()..sort();

    groups.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return ListView.separated(
      padding: const EdgeInsets.all(36),
      itemCount: groups.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 50);
      },
      itemBuilder: (BuildContext context, int index) {
        List<Drug> categoryList = categories[groups[index]]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              groups[index],
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: .8,
              ),
              itemCount: categoryList.length,
              itemBuilder: (BuildContext context, int categoryIndex) {
                return DrugCard(
                  drug: categoryList[categoryIndex],
                  isFromDoctor: isFromDoctor,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
