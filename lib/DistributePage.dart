import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:table_calendar/table_calendar.dart';

class DistributePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 186, 181, 244),
        elevation: 0,
        title: Text('배식 상황'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            child: Text(
              '최근 기록된 배식량 변화',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey[400],
            indent: 3.0,
            endIndent: 3.0,
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 16.0),
                TableCalendar(
                  // 캘린더를 여기서 원하는 대로 커스터마이징하세요
                  calendarFormat: CalendarFormat.week,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  focusedDay: DateTime.now(), // 현재 날짜로 설정
                  firstDay:
                      DateTime.utc(DateTime.now().year - 1), // 현재 날짜의 1년 전으로 설정
                  lastDay:
                      DateTime.utc(DateTime.now().year + 1), // 현재 날짜의 1년 후로 설정
                  calendarStyle: CalendarStyle(
                      // 캘린더 스타일을 여기서 커스터마이징하세요
                      ),
                  headerStyle: HeaderStyle(
                      // 헤더 스타일을 여기서 커스터마이징하세요
                      ),
                  calendarBuilders: CalendarBuilders(
                      // 필요한 경우 일자 빌더를 커스터마이징하세요
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
