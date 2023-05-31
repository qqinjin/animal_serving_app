import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import

class DistributePage extends StatefulWidget {
  final String petName;

  DistributePage({required this.petName});

  _DistributePage createState() => _DistributePage(petName: petName);
}

class _DistributePage extends State<DistributePage> {
  DateTime? _selectedDay;
  final String petName;

  _DistributePage({required this.petName});

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay =
          DateTime(focusedDay.year, focusedDay.month, focusedDay.day);
    });
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
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('pet')
                      .doc(petName)
                      .collection('record')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    Map<DateTime, String> records = {};
                    for (var doc in snapshot.data!.docs) {
                      final recordData = doc.data() as Map<String, dynamic>;
                      final recordDate =
                          (recordData['date'] as Timestamp).toDate();
                      final recordValue = recordData['value'].toString();

                      // 날짜만 비교하기 위해 시간을 제거합니다.
                      final dateOnly = DateTime(
                          recordDate.year, recordDate.month, recordDate.day);

                      if (isSameDay(_selectedDay, dateOnly)) {
                        // 날짜가 선택된 날짜와 일치하면 기록을 맵에 추가합니다.
                        records[dateOnly] = recordValue;
                      }
                    }

                    return Text(records[_selectedDay ?? DateTime.now()] ??
                        '배식 기록이 없습니다.');
                  },
                ),
                TableCalendar(
                  calendarFormat: CalendarFormat.week,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  focusedDay: DateTime.now(),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
