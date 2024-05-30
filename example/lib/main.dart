import 'package:flutter/material.dart';
import 'package:time_boxing/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Time Boxing",
      home: MainView()
    );
  }
}
 
class MainView extends StatefulWidget {
  const MainView({super.key});
 
  @override
  State<MainView> createState() => _MainViewState();
}
 
class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;  
  final List<Widget> _widgetOptions = <Widget>[
    const HomeView(),
  ];
 
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex),),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_month),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped,
      ),
    );
  }
 
  @override
  void initState() {
    super.initState();
  }
 
  @override
  void dispose() {
    super.dispose();
  }
}