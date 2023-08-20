import 'package:flutter/material.dart';
import 'settingpage.dart';
import 'auth_service.dart';
import 'Streamingpage.dart';
import 'loginpage.dart';
import 'main.dart';
import 'animal_serving.dart';
import 'information_service.dart';
import 'settingpage.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final BuildContext parentContext;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.parentContext,
  });

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MyApp()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StreamingPage()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SettingPage()),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => InformationService()),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(189, 255, 215, 238), // 시작 색
                Color.fromARGB(136, 220, 180, 250), // 끝 색
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.live_tv),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color.fromARGB(217, 173, 78, 180),
            unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
            onTap: _onItemTapped,
            backgroundColor:
                Colors.transparent, // Making the background transparent
            elevation: 0.0,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
  }
}
