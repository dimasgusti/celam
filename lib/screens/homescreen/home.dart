import 'package:celam/screens/account/settingsPage.dart';
import 'package:celam/screens/balance/topup.dart';
import 'package:celam/screens/homescreen/dashboard.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentPages = 0;

  final List<Widget> _children = [
    Dashboard(),
    Topup(),
    SettingsPage(),
  ];

  void onTapped(int index){
    setState(() {
      _currentPages = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF255e36),
        title: Text(
          'CELAM',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'KemasyuranJawa',
            color: Colors.white
          ),
        ),
        
        centerTitle: true,
      ),
      body: _children[_currentPages],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: _currentPages,
        selectedItemColor: Color(0xFF255e36),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Deposit'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan'
          ),
        ],
        elevation: 10,
        backgroundColor: Color(0xFFf9f7f7),
      ),
    );
  }
}