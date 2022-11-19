import 'package:flutter/material.dart';
import 'app_pages/main_monitoring.dart';
import 'app_pages/climate_control.dart';
import 'app_pages/iluminacao.dart';
import 'app_pages/despertador.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 5, 54),
      bottomNavigationBar: Theme(data: Theme.of(context).copyWith(
        dividerColor: Color.fromARGB(255, 3, 3, 39),
        canvasColor: Color.fromARGB(255, 3, 3, 39),
      ), child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
          elevation: 6,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: "home outlined"),
            BottomNavigationBarItem(
                icon: Icon(Icons.thermostat),
                label: "thermostat"),
            BottomNavigationBarItem(
                icon: Icon(Icons.lightbulb_outline),
                label: "lightbulb outline"),
            BottomNavigationBarItem(
                icon: Icon(Icons.access_alarm), label: "bed outlined"),
          ],
          iconSize: 20,
          selectedIconTheme: const IconThemeData(size: 30),
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.blue,
          onTap: onTapItem,
          
        ),),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeMonitoring(),
          ClimateControl(),
          iluminacao(),
          Despertador(),
        ],
        sizing: StackFit.expand,
      ),
    );
  }
}
