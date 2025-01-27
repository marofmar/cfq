import 'package:cfq/presentation/screens/my_page.dart';
import 'package:cfq/presentation/screens/ranking_page.dart';
import 'package:cfq/presentation/screens/wod_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    WodPage(),
    RankingPage(),
    MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'WOD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Page',
          ),
        ],
      ),
    );
  }
}
