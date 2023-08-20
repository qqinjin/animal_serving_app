import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:intl/intl.dart';
import 'Streamingpage.dart';
import 'main.dart';
import 'information_service.dart';
import 'animal_serving.dart';

class StreamingPage extends StatefulWidget {
  @override
  _StreamingPageState createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  final url = 'http://172.18.60.31:8081/';
  int _selectedIndex = 1;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String formattedTime = DateFormat('hh:mm:ss').format(DateTime.now());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _getTime() {
    final String updatedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String updatedTime = DateFormat('hh:mm:ss').format(DateTime.now());
    setState(() {
      formattedDate = updatedDate;
      formattedTime = updatedTime;
    });
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      switch (index) {
        case 0:
          Navigator.push(
            context,
            //MaterialPageRoute(builder: (_) => StreamingPage()),
            MaterialPageRoute(builder: (_) => MyApp()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            //MaterialPageRoute(builder: (_) => InformationService()),
            MaterialPageRoute(builder: (_) => StreamingPage()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StreamingPage()),
          );
          break;
        case 3:
          Navigator.push(
            context,
            //MaterialPageRoute(builder: (_) => MyApp()),
            MaterialPageRoute(builder: (_) => InformationService()),
          );

          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streaming'),
        backgroundColor: Color.fromARGB(255, 186, 181, 244),
      ),
      body: Container(
        color: Color.fromARGB(255, 240, 240, 240),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Date',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(

              formattedDate,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Current Time',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(

              formattedTime,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: double.infinity,
                height: 300,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Mjpeg(
                    isLive: true,
                    stream: url,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        // 상하좌우 마진 설정
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
            height: 60,
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.camera_alt),
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
              selectedItemColor: Colors.amber[800],
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
              backgroundColor: Color.fromARGB(255, 186, 181, 244),
              elevation: 0.0,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          ),
        ),
      ),
    );
  }
}
