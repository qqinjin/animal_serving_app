import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // date_symbol_data_local import
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class StreamingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    
    initializeDateFormatting('ko_KR', null); // 한국 시간대(KST) 설정
    DateTime currentDateTime = tz.TZDateTime.now(tz.local);
    String formattedDate =
        DateFormat('yyyy.MM.dd  HH:mm').format(currentDateTime.toLocal());

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
              formattedDate,
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
