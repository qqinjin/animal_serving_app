import 'package:flutter/material.dart';

class StreamingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 186, 181, 244),
        title: Text('실시간 모니터링'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            child: Text(
              '2023.05.29 : 오후 3:43:05',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey[400],
            indent: 3.0,
            endIndent: 3.0,
          ),
          
        ],
      ),
    );
  }
}
