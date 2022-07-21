import 'package:flutter/material.dart';

class TabView extends StatefulWidget {
  const TabView({Key? key}) : super(key: key);

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
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
             
            ]),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
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
                // BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                // BottomNavigationBarItem(
                //     icon: Icon(Icons.calendar_month), label: ''),
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
