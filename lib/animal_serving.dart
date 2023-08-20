import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import 'auth_service.dart';
import 'bucket_service.dart';
import 'loginpage.dart';
import 'addpetpage.dart';
import 'animal_serving_service.dart';
import 'DistributePage.dart';
import 'Streamingpage.dart';
import 'main.dart';
import 'information_service.dart';
import 'anumal_updatepage.dart';
import 'bottomNavigationBar.dart';

class HomePage2 extends StatefulWidget {
  final String petName;

  const HomePage2({Key? key, required this.petName})
      : super(key: key); // 추가된 명명된 매개변수

  @override
  State<HomePage2> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  TextEditingController jobController = TextEditingController();
  String? petName;
  List<String> petNames = [];
  List<String> petSexs = [];
  List<String> petAges = [];
  List<String> petWeights = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    petName = '';
    _getPetNamesFromFirestore();
  }


  Future<void> _getPetNamesFromFirestore() async {
    final user = context.read<AuthService>().currentUser();
    final uid = user?.uid;

    FirebaseFirestore.instance
        .collection('pet')
        .where('uid', isEqualTo: uid)
        .where('petname', isEqualTo: widget.petName) // Add this line
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          petNames.add(doc.get('petname'));
          petSexs.add(doc.get('petsex'));
          petAges.add(doc.get('petage'));
          petWeights.add(doc.get('petweight'));
          petName = petNames.first;
        });
      });
    });
  }

  Widget smallBox(String text1, String text2, String suffix, double w_size,
      double h_size, String hexColor) {
    Color bgColor = Color(int.parse('0x' + hexColor));
    return Container(
      width: w_size,
      height: h_size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // "Gender"를 왼쪽에 정렬
          mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
          children: [
            Text(
              text1,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4), // 위아래 텍스트 사이의 공간을 띄움
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // 성별 정보와 suffix를 중앙에 위치
              children: [
                Text(
                  text2,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4), // 텍스트 사이의 공간을 띄움
                Text(
                  suffix,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showCompletionDialog(String petName, String jobAmount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('$petName에게 ${jobAmount}g 배식하였습니다.'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentPetName = widget.petName;
    var size = MediaQuery.of(context).size; // 화면 크기 가져오기
    double width_margin = size.width * 0.05; // 마진주기
    double boxWidthFraction = 0.95; // 반려동물 박스 화면 80%
    double boxHeight = size.height * 0.28;
    return Consumer<AnimalServingService>(
      builder: (context, animalServingService, child) {
        final authService = context.read<AuthService>();
        final user = authService.currentUser()!;

        return Scaffold(
          appBar: AppBar(
            title: Text('Details Pet'),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 186, 181, 244),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.read<AuthService>().signOut();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(height: 8),
              Container(
                height: size.height * 0.28,
                child: PageView.builder(
                  controller: PageController(
                    viewportFraction: boxWidthFraction,
                    keepPage: false,
                  ),
                  itemCount: petNames.length,
                  itemBuilder: (context, index) {
                    double iconHeight = boxHeight * 0.55;
                    double smallBoxSize_w = boxHeight * 0.44; // 반려동물 3박스 사이즈
                    double smallBoxSize_h = boxHeight * 0.27;

                    return Padding(
                      padding: EdgeInsets.only(
                        left: (index == 0) ? width_margin / 2 : 0.0,
                        right: width_margin / 2,
                      ),
                      child: GestureDetector(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.pets,
                                      size: iconHeight,
                                      color: Color.fromARGB(255, 245, 179, 176),
                                    ),
                                    SizedBox(width: 16),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        '${petNames[index]}',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    // Spacer를 사용하여 남은 공간을 모두 차지하게 만듭니다.
                                    IconButton(
                                      // 문서 모양의 아이콘 버튼을 추가합니다.
                                      icon: Icon(Icons.description),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PetEditPage(
                                                  petName: petNames[index])),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    smallBox(
                                        'Gender',
                                        petSexs[index],
                                        '',
                                        smallBoxSize_w,
                                        smallBoxSize_h,
                                        '80FF9900'), // 성별 표시,
                                    SizedBox(width: 9),
                                    smallBox(
                                        'Ages',
                                        petAges[index],
                                        'Years',
                                        smallBoxSize_w,
                                        smallBoxSize_h,
                                        '8099CCFF'), // 나이 표시
                                    SizedBox(width: 9),
                                    smallBox(
                                        'Weight',
                                        petWeights[index],
                                        'Kg',
                                        smallBoxSize_w,
                                        smallBoxSize_h,
                                        '8000FFCC'), // 무게 표시
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                // 좌우 마진을 화면 너비의 5%로 설정
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('배식',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            // '배식' 텍스트
                            SizedBox(width: 5),
                            // 아이콘과 텍스트 사이의 간격
                            Icon(Icons.rice_bowl, color: Colors.deepPurple),
                            // 밥 아이콘
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: jobController,
                                cursorColor: Colors.deepPurple,
                                // Set cursor color
                                decoration: InputDecoration(
                                  hintText: "배식 g 입력",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .deepPurple), // Set underline color
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 186, 181, 244),
                              ),
                              child: Icon(Icons.send), // 밥 아이콘
                              onPressed: () {
                                if (jobController.text.isNotEmpty &&
                                    petName != null) {
                                  final jobAmount = jobController.text;
                                  animalServingService.create(
                                      jobAmount, petName!);
                                  showCompletionDialog(petName!, jobAmount);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListView(
                    children: [
                      // 선 그래프
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(show: false),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                  color: const Color(0xff37434d),
                                  width: 1,
                                ),
                              ),
                              minX: 0,
                              maxX: 7,
                              minY: 0,
                              maxY: 6,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 3),
                                    FlSpot(1, 1),
                                    FlSpot(2, 2),
                                    FlSpot(3, 1.5),
                                    FlSpot(4, 2.8),
                                    FlSpot(5, 2.2),
                                    FlSpot(6, 3),
                                  ],
                                  isCurved: true,
                                  dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 파이 차트
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: 40,
                                  color: Colors.red,
                                  title: '40%',
                                ),
                                PieChartSectionData(
                                  value: 30,
                                  color: Colors.green,
                                  title: '30%',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _selectedIndex,
            parentContext: context,
          ),
        );
      },
    );
  }
}
