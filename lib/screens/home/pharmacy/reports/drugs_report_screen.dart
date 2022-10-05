import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/models/pharmacy/drug.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drug_details_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drugs_list_page.dart';
import 'package:med_connect_admin/screens/home/pharmacy/reports/reports_page.dart';
import 'package:med_connect_admin/utils/functions.dart';

class DrugsReportWidget extends StatelessWidget {
  const DrugsReportWidget({Key? key, required this.drugsList})
      : super(key: key);
  final List<Drug> drugsList;
  @override
  Widget build(BuildContext context) {
    drugsList.sort(
      (a, b) => a.quantityInStock!.compareTo(b.quantityInStock!),
    );

    Drug mostStocked = drugsList.reversed.toList()[0];

    Map<String, List<Drug>> categories = {};

    for (Drug element in drugsList) {
      if (categories[element.group] == null) {
        categories[element.group!] = [element];
      } else {
        categories[element.group!]!.add(element);
      }
    }

    List<MapEntry<String, List<Drug>>> categoryEntries =
        categories.entries.toList();

    List<String> groups = categoryEntries.map((e) => e.key).toList();

    categoryEntries.sort(
      (a, b) => a.value.length.compareTo(b.value.length),
    );

    return drugsList.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              Text(
                'Total number of drugs',
                style: labelTextStyle,
              ),
              Text(drugsList.length.toString(), style: boldDigitStyle),
              const SizedBox(height: 30),
              Row(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Most stocked medication',
                          style: labelTextStyle,
                        ),
                        Row(
                          children: [
                            Text(
                              'Quantity: ',
                              style: labelTextStyle,
                            ),
                            Text(
                              mostStocked.quantityInStock.toString(),
                              style: boldDigitStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        navigate(context, DrugDetailsScreen(drug: mostStocked));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.blueGrey.withOpacity(.1),
                        ),
                        child: Column(
                          children: [
                            DrugImageWidget(
                              drugId: mostStocked.id!,
                              height: 100,
                              width: 100,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Brand name',
                              style: labelTextStyle,
                            ),
                            Text(mostStocked.brandName!),
                            const SizedBox(height: 10),
                            Text(
                              'Generic name',
                              style: labelTextStyle,
                            ),
                            Text(mostStocked.genericName!),
                            const SizedBox(height: 10),
                            Text(
                              'Class',
                              style: labelTextStyle,
                            ),
                            Text(mostStocked.group!),
                            const SizedBox(height: 10),
                            Text(
                              'Price',
                              style: labelTextStyle,
                            ),
                            Text(
                                'GH¢ ${mostStocked.price!.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('Over-the-counter medication'),
                ],
              ),
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('Prescription medication'),
                ],
              ),
              const SizedBox(height: 10),
              Container(),
              const SizedBox(height: 20),
              Text(
                'Drug classes in stock',
                style: labelTextStyle,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(
                        border: Border.all(color: Colors.blueGrey)),
                    gridData: FlGridData(
                        drawVerticalLine: false, horizontalInterval: 1),
                    titlesData: FlTitlesData(
                      leftTitles:
                          AxisTitles(axisNameWidget: const Text('Quantity')),
                      rightTitles: AxisTitles(),
                      topTitles: AxisTitles(),
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                        ),
                        sideTitles: SideTitles(
                            getTitlesWidget: (value, meta) => SideTitleWidget(
                                  axisSide: AxisSide.bottom,
                                  space: 10,
                                  angle: -.3,
                                  child: Text(groups[value.toInt()]),
                                ),
                            showTitles: true),
                      ),
                    ),
                    barGroups: [
                      ...categories.entries
                          .map((e) => BarChartGroupData(
                                  x: groups.indexOf(e.key),
                                  barRods: [
                                    BarChartRodData(
                                        toY: e.value
                                            .where((element) =>
                                                element.isOverTheCounter!)
                                            .length
                                            .toDouble(),
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(5)),
                                        width: 14),
                                    BarChartRodData(
                                        toY: e.value
                                            .where((element) =>
                                                !element.isOverTheCounter!)
                                            .length
                                            .toDouble(),
                                        color: Colors.pink,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(5)),
                                        width: 14)
                                  ]))
                          .toList()
                    ],
                    barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                          BarTooltipItem(
                              rodIndex == 0
                                  ? categories.entries
                                      .toList()[groupIndex]
                                      .value
                                      .where((element) =>
                                          element.isOverTheCounter!)
                                      .length
                                      .toString()
                                  : categories.entries
                                      .toList()[groupIndex]
                                      .value
                                      .where((element) =>
                                          !element.isOverTheCounter!)
                                      .length
                                      .toString(),
                              const TextStyle(color: Colors.white)),
                    )),
                    maxY: categoryEntries.reversed
                        .toList()[0]
                        .value
                        .length
                        .toDouble(),
                    minY: 0,
                    alignment: BarChartAlignment.spaceEvenly,
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 150),
                  swapAnimationCurve: Curves.linear,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Over-the-counter vs Prescription medication',
                style: labelTextStyle,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(sections: [
                    PieChartSectionData(
                      value: (drugsList
                                  .where((element) => element.isOverTheCounter!)
                                  .length /
                              drugsList.length) *
                          360,
                      title: drugsList
                          .where((element) => element.isOverTheCounter!)
                          .length
                          .toString(),
                      titleStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                        value: (drugsList
                                    .where(
                                        (element) => !element.isOverTheCounter!)
                                    .length /
                                drugsList.length) *
                            360,
                        title: drugsList
                            .where((element) => !element.isOverTheCounter!)
                            .length
                            .toString(),
                        titleStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        color: Colors.pink),
                  ]),
                  swapAnimationDuration: const Duration(milliseconds: 150),
                  swapAnimationCurve: Curves.linear,
                ),
              ),
              const SizedBox(height: 50),
            ],
          );
  }
}
