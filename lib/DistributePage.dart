import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  Map<DateTime, String> feedingDate = {};
  final String petName;

  _DistributePage({required this.petName});

  @override
  void initState() {
    super.initState();

    _selectedDay = DateTime.now();
    // 데이터 가져오기
    fetchData();
  }

  void fetchData() async {
    // 현재 로그인된 사용자의 uid 가져오기 (로그인 기능이 구현되어 있다고 가정)
    final user = context.read<AuthService>().currentUser();
    final uid = user?.uid;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('pet')
        .where('uid', isEqualTo: uid)
        .where('petname', isEqualTo: petName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final petDoc = querySnapshot.docs.first;

      final recordSnapshot = await FirebaseFirestore.instance
          .collection('pet')
          .doc(petDoc.id)
          .collection('record')
          .get();

      //test2 = remainingFoodDate;

      recordSnapshot.docs.forEach((recordDoc) {
        final remainingFoodData =
            recordDoc.data()['남은배식량'] as Map<String, dynamic>;
        final remainingFoodDate =
            (remainingFoodData['date'] as Timestamp).toDate();
        final remainingFoodWeight = remainingFoodData['weight'] as String;

        final feedingAmountData =
            recordDoc.data()['배식량'] as Map<String, dynamic>;
        final feedingAmountDate =
            (feedingAmountData['date'] as Timestamp).toDate();
        final feedingAmountWeight = feedingAmountData['weight'] as String;

        // selected date comparison
        final selectedDateWithoutTime = DateTime(
            _selectedDay!.year, _selectedDay!.month, _selectedDay!.day);

        final remainingFoodDateWithoutTime = DateTime(remainingFoodDate.year,
            remainingFoodDate.month, remainingFoodDate.day);

        if (selectedDateWithoutTime == remainingFoodDateWithoutTime) {
          feedingDate[_selectedDay!.toLocal()] =
              'Remaining Food - Date: $remainingFoodDate, Weight: $remainingFoodWeight\n' +
                  'Feeding Amount - Date: $feedingAmountDate, Weight: $feedingAmountWeight';
        }
      });

      setState(
          () {}); // Move setState() here to make sure UI updates happen after all the data has been fetched.
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay =
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    });

    // 데이터 다시 가져오기
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 186, 181, 244),
        elevation: 0,
        title: Text('${petName}의  배식'),
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
                Text(feedingDate[_selectedDay] ?? '${_selectedDay}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
