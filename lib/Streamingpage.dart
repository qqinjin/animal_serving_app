import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:intl/intl.dart';

class StreamingPage extends StatefulWidget {
  @override
  _StreamingPageState createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  final url = 'http://192.168.178.31:8081/';

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
    );
  }
}
