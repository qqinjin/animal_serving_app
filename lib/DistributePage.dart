import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'bucket_service.dart';
import 'loginpage.dart';

class DistributePage extends StatefulWidget {
  @override
  final String petName;

  DistributePage({required this.petName});

  _DistributePage createState() => _DistributePage(petName: petName);
}

class _DistributePage extends State<DistributePage> {
  DateTime? _selectedDay;
  String? selectedDay;
  String? recordDate;
  List<String> feedingRecords = []; // 변경: 여러 배식 기록을 저장하기 위한 리스트
  final String petName;

  _DistributePage({required this.petName});

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final user = context.read<AuthService>().currentUser();
    final uid = user?.uid;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('pet')
        .where('uid', isEqualTo: uid)
        .where('petname', isEqualTo: petName)
        .get();

    final recordDoc = querySnapshot.docs.first.id;

    final recordSnapshot = await FirebaseFirestore.instance
        .collection('pet')
        .doc(recordDoc)
        .collection('record')
        .get();

    feedingRecords.clear(); // 변경: 이전 기록을 초기화

    recordSnapshot.docs.forEach((doc) {
      final remainingFoodData = doc.data()['남은배식량'] as Map<String, dynamic>;
      final remainingFoodDate = (remainingFoodData['date'] as Timestamp)
          .toDate()
          .add(Duration(hours: 9));
      final remainingFoodWeight = remainingFoodData['weight'] as String;

      final feedingAmountData = doc.data()['배식량'] as Map<String, dynamic>;
      final feedingAmountDate = (feedingAmountData['date'] as Timestamp)
          .toDate()
          .add(Duration(hours: 9));
      final feedingAmountWeight = feedingAmountData['weight'] as String;

      final recordDate = feedingAmountDate.toString().split(' ')[0];
      this.recordDate = recordDate;

      if (selectedDay == recordDate) {
        final record =
            '남은 배식량: $remainingFoodWeight\n배식한 날짜: $feedingAmountDate, 배식량: $feedingAmountWeight';
        feedingRecords.add(record); // 변경: 배식 기록을 리스트에 추가
      }
    });

    setState(() {});
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay =
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      this.selectedDay = _selectedDay.toString().split(' ')[0];
    });

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 186, 181, 244),
        elevation: 0,
        title: Text('${petName}의 배식'),
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
                  calendarFormat: CalendarFormat.week,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  focusedDay: _selectedDay ?? DateTime.now(),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  firstDay: DateTime.utc(DateTime.now().year - 1),
                  lastDay: DateTime.utc(DateTime.now().year + 1),
                  calendarStyle: CalendarStyle(),
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _selectedDay != null &&
                                isSameDay(_selectedDay!, date)
                            ? Color.fromARGB(255, 186, 181, 244)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    todayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  onDaySelected: _onDaySelected,
                ),
                SizedBox(height: 40.0),
                Column(
                  children: [
                    for (int i = 0; i < feedingRecords.length; i++) ...[
                      Divider(
                        thickness: 1.0,
                        color: Colors.grey[400],
                        indent: 16.0,
                        endIndent: 16.0,
                      ),
                      Text(feedingRecords[i]),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
