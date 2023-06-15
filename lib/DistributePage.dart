import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart'; // add this import for date formatting
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
  String? selecteday;
  String? RecordDate;
  Map<DateTime, String> feedingDate = {};
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

    recordSnapshot.docs.forEach((Doc) {
      final remainingFoodData = Doc.data()['남은배식량'] as Map<String, dynamic>;
      final remainingFoodDate = (remainingFoodData['date'] as Timestamp)
          .toDate()
          .add(Duration(hours: 9));
      final remainingFoodWeight = remainingFoodData['weight'] as String;

      final feedingAmountData = Doc.data()['배식량'] as Map<String, dynamic>;
      final feedingAmountDate = (feedingAmountData['date'] as Timestamp)
          .toDate()
          .add(Duration(hours: 9));
      final feedingAmountWeight = feedingAmountData['weight'] as String;

      final recordDate = DateFormat('yyyy-MM-dd')
          .format(feedingAmountDate); // Use the DateFormat class here
      RecordDate = recordDate;

      if (selecteday == RecordDate) {
        feedingDate[_selectedDay!.toLocal()] = ' 남은 배식량: $remainingFoodWeight g\n' +
            ' 배식한 날짜: ${DateFormat('yyyy-MM-dd HH:mm').format(feedingAmountDate)}\n' + // Here as well
            ' 배식량: $feedingAmountWeight g';
      }
    });

    setState(() {});
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay =
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      selecteday = _selectedDay.toString().split(' ')[0];
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    feedingDate[_selectedDay] ?? '배식기록이 없습니다.',
                    style: TextStyle(fontSize: 16.0),
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
