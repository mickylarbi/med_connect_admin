import 'package:flutter/material.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/appointment_list_page.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_home_page/doctor_home_page.dart';
import 'package:med_connect_admin/screens/home/doctor/reports/reports_page.dart';

class DoctorTabView extends StatefulWidget {
  const DoctorTabView({
    Key? key,
  }) : super(key: key);

  @override
  State<DoctorTabView> createState() => _DoctorTabViewState();
}

class _DoctorTabViewState extends State<DoctorTabView> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              KeepAlivePage(child: DoctorHomePage()),
              KeepAlivePage(child: AppointmentsListPage()),
              KeepAlivePage(child: DoctorReportPage()),
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
                BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
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

class KeepAlivePage extends StatefulWidget {
  const KeepAlivePage({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    /// Dont't forget this
    super.build(context);

    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
