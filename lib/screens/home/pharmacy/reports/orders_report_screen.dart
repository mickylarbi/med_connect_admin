import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/models/pharmacy/drug.dart';
import 'package:med_connect_admin/models/pharmacy/order.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drug_details_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drugs_list_page.dart';
import 'package:med_connect_admin/screens/home/pharmacy/reports/reports_page.dart';
import 'package:med_connect_admin/utils/functions.dart';

class OrdersReportWidget extends StatelessWidget {
  const OrdersReportWidget({
    Key? key,
    required this.ordersList,
    required this.drugsList,
  }) : super(key: key);

  final List<Order> ordersList;
  final List<Drug> drugsList;

  @override
  Widget build(BuildContext context) {
    //average orders per day
    int sum = 0;
    List<DateTime> dates = [];
    for (int i = 0; i < ordersList.length; i++) {
      if (!dates.contains(ordersList[i].dateTime!)) {
        ++sum;
      }
      dates.add(ordersList[i].dateTime!);
    }

    //
    double totalRevenue = 0;
    for (Order order in ordersList
        .where((element) => element.status == OrderStatus.delivered)) {
      for (MapEntry entry in order.cart!.entries) {
        if (drugsList.map((e) => e.id!).contains(entry.key)) {
          totalRevenue += drugsList
              .singleWhere((element) => element.id == entry.key)
              .price!;
        }
      }
    }

    //most purchased drug
    Map<String, int> drugQuantities = {};

    MapEntry<int, int> overTheCounterVsPrescription = const MapEntry(0, 0);
    for (Order order in ordersList
        .where((element) => element.status == OrderStatus.delivered)) {
      for (MapEntry entry in order.cart!.entries) {
        if (drugsList.map((e) => e.id!).contains(entry.key)) {
          int currentQuantity = drugQuantities[entry.key] ?? 0;
          drugQuantities[entry.key] = (currentQuantity + entry.value).toInt();

          if (drugsList
              .singleWhere((element) => element.id == entry.key)
              .isOverTheCounter!) {
            overTheCounterVsPrescription = MapEntry(
                overTheCounterVsPrescription.key + (entry.value as int),
                overTheCounterVsPrescription.value);
          } else {
            overTheCounterVsPrescription = MapEntry(
                overTheCounterVsPrescription.key,
                overTheCounterVsPrescription.value + (entry.value as int));
          }
        }
      }
    }
    MapEntry<String, int> maxEntry = const MapEntry('', 0);
    for (MapEntry<String, int> entry in drugQuantities.entries) {
      if (entry.value > maxEntry.value) {
        maxEntry = entry;
      }
    }
    Drug maxDrug =
        drugsList.singleWhere((element) => element.id == maxEntry.key);

    print(overTheCounterVsPrescription);
    //groups purchase quantities
    Map<String, int> groupsPurhaseQuantities = {};
    for (Order order in ordersList
        .where((element) => element.status == OrderStatus.delivered)) {
      for (MapEntry entry in order.cart!.entries) {
        if (drugsList.map((e) => e.id!).contains(entry.key)) {
          String currentGroup = drugsList
              .singleWhere((element) => element.id == entry.key)
              .group!;
          int currentQuantity = groupsPurhaseQuantities[currentGroup] ?? 0;
          groupsPurhaseQuantities[currentGroup] =
              (currentQuantity + entry.value).toInt();
        }
      }
    }
    MapEntry<String, int> maxGroup = const MapEntry('', 0);
    for (MapEntry<String, int> entry in groupsPurhaseQuantities.entries) {
      if (entry.value > maxGroup.value) {
        maxGroup = entry;
      }
    }

    return ordersList.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              Text(
                'Average orders per day',
                style: labelTextStyle,
              ),
              Text(
                (sum ~/ ordersList.length).toString(),
                style: boldDigitStyle,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Total revenue',
                        style: labelTextStyle,
                      ),
                      Text(
                        'GH¢ ${totalRevenue.toStringAsFixed(2)}',
                        style: boldDigitStyle,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        'Orders completed',
                        style: labelTextStyle,
                      ),
                      Text(
                        ordersList
                            .where((element) =>
                                element.status == OrderStatus.delivered)
                            .length
                            .toString(),
                        style: boldDigitStyle,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Most purchased medication',
                          style: labelTextStyle,
                        ),
                        Row(
                          children: [
                            Text(
                              'Quantity: ',
                              style: labelTextStyle,
                            ),
                            Text(
                              maxEntry.value.toString(),
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
                        navigate(context, DrugDetailsScreen(drug: maxDrug));
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
                              drugId: maxDrug.id!,
                              height: 100,
                              width: 100,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Brand name',
                              style: labelTextStyle,
                            ),
                            Text(maxDrug.brandName!),
                            const SizedBox(height: 10),
                            Text(
                              'Generic name',
                              style: labelTextStyle,
                            ),
                            Text(maxDrug.genericName!),
                            const SizedBox(height: 10),
                            Text(
                              'Class',
                              style: labelTextStyle,
                            ),
                            Text(maxDrug.group!),
                            const SizedBox(height: 10),
                            Text(
                              'Price',
                              style: labelTextStyle,
                            ),
                            Text('GH¢ ${maxDrug.price!.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Text(
                'Drug classes purchased',
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
                                  child: Text(groupsPurhaseQuantities.keys
                                      .toList()[value.toInt()]),
                                ),
                            showTitles: true),
                      ),
                    ),
                    barGroups: [
                      ...groupsPurhaseQuantities.entries
                          .map((e) => BarChartGroupData(
                                  x: groupsPurhaseQuantities.keys
                                      .toList()
                                      .indexOf(e.key),
                                  barRods: [
                                    BarChartRodData(
                                        toY: e.value.toDouble(),
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(5)),
                                        width: 14,
                                        color: Colors.green),
                                  ]))
                          .toList()
                    ],
                    barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                          BarTooltipItem(
                              groupsPurhaseQuantities.entries
                                  .toList()[groupIndex]
                                  .value
                                  .toString(),
                              const TextStyle(color: Colors.white)),
                    )),
                    maxY: maxGroup.value.toDouble(),
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
                      value: (overTheCounterVsPrescription.key) * 360,
                      title: overTheCounterVsPrescription.key.toString(),
                      titleStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                        value: (overTheCounterVsPrescription.value) * 360,
                        title: overTheCounterVsPrescription.value.toString(),
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
