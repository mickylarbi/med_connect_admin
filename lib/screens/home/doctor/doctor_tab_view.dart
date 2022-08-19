import 'package:flutter/material.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_appointments/appointment_list_page.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_home_page/home_page.dart';

class DoctorTabView extends StatefulWidget {
  const DoctorTabView({Key? key}) : super(key: key);

  @override
  State<DoctorTabView> createState() => _DoctorTabViewState();
}

class _DoctorTabViewState extends State<DoctorTabView> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              DoctorHomePage(),
              DoctorAppointmentsListPage(),
            ]),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
          //TODO: create custom
          valueListenable: _currentIndex,
          builder: (context, value, child) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex.value,
              onTap: (index) {
                if (index != _currentIndex.value) {
                  _currentIndex.value = index;
                  _pageController.jumpToPage(_currentIndex.value);
                }
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month), label: ''),
                // BottomNavigationBarItem(
                //     icon: Icon(Icons.person_search), label: ''),
                // BottomNavigationBarItem(
                //     icon: Icon(Icons.chat_bubble_rounded), label: ''),
                // BottomNavigationBarItem(
                //     icon: Icon(Icons.person_add_alt), label: ''),
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndex.dispose();

    super.dispose();
  }
}
