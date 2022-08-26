import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/models/doctor_appointment.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_appointments/doctor_appointment_details_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/header_text.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/functions.dart';

class CalendarViewScreen extends StatefulWidget {
  final List<DoctorAppointment> appointmentList;
  const CalendarViewScreen({Key? key, required this.appointmentList})
      : super(key: key);

  @override
  State<CalendarViewScreen> createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends State<CalendarViewScreen> {
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(30);
  PageController pageController = PageController(initialPage: 30);
  late ScrollController scrollController;

  List<DateTime> dates = List.generate(
      61,
      (index) => DateTime.now()
          .subtract(const Duration(days: 30))
          .add(Duration(days: index)));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pageController.addListener(() {
      selectedIndex.value = pageController.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    scrollController =
        ScrollController(initialScrollOffset: 2464 - kScreenWidth(context) / 2);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 88),
                ValueListenableBuilder<int>(
                    valueListenable: selectedIndex,
                    builder: (context, value, child) {
                      return SizedBox(
                        height: 100,
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          scrollDirection: Axis.horizontal,
                          itemCount: dates.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                pageController.animateToPage(index,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeOutQuint);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                width: 80,
                                decoration: BoxDecoration(
                                  color: index == selectedIndex.value
                                      ? Colors.blueGrey.withOpacity(.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(DateFormat.E().format(dates[index])),
                                    Text(
                                      dates[index].day.toString(),
                                      style: const TextStyle(fontSize: 22),
                                    ),
                                    Text(DateFormat.MMM().format(dates[index])),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                Expanded(
                    child: PageView.builder(
                        controller: pageController,
                        itemCount: dates.length,
                        itemBuilder: (context, pageIndex) {
                          List<DoctorAppointment> dayAppointments = [];
                          for (DoctorAppointment appointment
                              in widget.appointmentList) {
                            if (appointment.dateTime!.year ==
                                    dates[pageIndex].year &&
                                appointment.dateTime!.month ==
                                    dates[pageIndex].month &&
                                appointment.dateTime!.day ==
                                    dates[pageIndex].day) {
                              dayAppointments.add(appointment);
                            }
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 36),
                            itemCount: dayAppointments.length,
                            itemBuilder: (BuildContext context, int listIndex) {
                              DoctorAppointment appointment =
                                  dayAppointments[listIndex];
                              return InkWell(
                                onTap: () {
                                  navigate(
                                      context,
                                      DoctorAppointmentDetailsScreen(
                                          appointment: appointment));
                                },
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 36),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 90,
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                DateFormat.d().format(
                                                    appointment.dateTime!),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24),
                                              ),
                                              Text(
                                                DateFormat.MMM().format(
                                                    appointment.dateTime!),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 30),
                                        Container(
                                          height: 130,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 30),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              HeaderText(
                                                  text: appointment.service!),
                                              Text(appointment.patientName!),
                                              Text(appointment.venueString!)
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            // Icon(
                                            //   Icons.chevron_right_rounded,
                                            //   color: Colors.grey.withOpacity(.5),
                                            //   size: 40,
                                            // ),

                                            const CircleAvatar(
                                              //placeholder for centering date
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: 10,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: Colors.blueGrey
                                                      .withOpacity(.15)),
                                              child: Text(
                                                DateFormat.jm().format(
                                                    appointment.dateTime!),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            if (appointment.isConfirmed !=
                                                    null &&
                                                appointment.isConfirmed!)
                                              const CircleAvatar(
                                                backgroundColor: Colors.green,
                                                radius: 10,
                                                child: Icon(
                                                  Icons.done,
                                                  size: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                          ],
                                        )
                                      ],
                                    )),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(
                              height: 30,
                            ),
                          );
                        })),
              ],
            ),
            const CustomAppBar(title: 'Calendar view')
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
