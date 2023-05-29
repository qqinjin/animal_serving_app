import 'package:flutter/material.dart';

class HealthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 186, 181, 244),
        title: Text('건강 상태'),
      ),
      body: Center(
        child: Text(
          '반려동물의 건강 상태를 확인합니다.',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
