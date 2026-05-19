import 'package:flutter/material.dart';

import '../account/account_page.dart';
import '../home/home_page.dart';
import '../lectures/lectures_page.dart';
import '../quizzes/quizzes_page.dart';

class AppShellPage extends StatefulWidget {
  const AppShellPage({super.key});

  @override
  State<AppShellPage> createState() => _AppShellPageState();
}

class _AppShellPageState extends State<AppShellPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages = const [
    HomePage(),
    LecturesPage(),
    QuizzesPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_copy_outlined),
            selectedIcon: Icon(Icons.folder_copy_rounded),
            label: 'المحاضرات',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz_rounded),
            label: 'الاختبارات',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'الحساب',
          ),
        ],
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
