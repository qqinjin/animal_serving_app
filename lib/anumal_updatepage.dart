import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Streamingpage.dart';
import 'main.dart';
import 'information_service.dart';

class PetEditPage extends StatefulWidget {
  final String petName;

  PetEditPage({required this.petName});

  @override
  _PetEditPageState createState() => _PetEditPageState(petName: petName);
}

class _PetEditPageState extends State<PetEditPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  String? petName;
  List<String> petNames = [];
  List<String> petSexs = [];
  List<String> petAges = [];
  List<String> petWeights = [];
  int _selectedIndex = 0;

  _PetEditPageState({required this.petName});

  @override
  void initState() {
    super.initState();
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    FirebaseFirestore.instance
        .collection('pet')
        .where('petname', isEqualTo: petName)
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        var document = querySnapshot.docs.first;
        setState(() {
          _nameController.text = document['petname'];
          _weightController.text = document['petweight'];
        });
      }
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      switch (index) {
        case 0:
          Navigator.push(
            context,
            //MaterialPageRoute(builder: (_) => StreamingPage()),
            MaterialPageRoute(builder: (_) => MyApp()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            //MaterialPageRoute(builder: (_) => InformationService()),
            MaterialPageRoute(builder: (_) => StreamingPage()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StreamingPage()),
          );
          break;
        case 3:
          Navigator.push(
            context,
            //MaterialPageRoute(builder: (_) => MyApp()),
            MaterialPageRoute(builder: (_) => InformationService()),
          );

          break;
      }
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; // 화면 크기 가져오기
    double width_margin = size.width * 0.05; // 마진주기
    double boxWidthFraction = 0.95; // 반려동물 박스 화면 80%
    double boxHeight = size.height * 0.28;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '정보 수정',
          style: TextStyle(
            color: const Color.fromARGB(255, 133, 130, 130),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        iconTheme: IconThemeData(
          color: const Color.fromARGB(255, 133, 130, 130), // 원하는 아이콘 컬러로 변경하세요
        ),
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
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                smallBox('Gender', petSexs[index], '',
                                    smallBoxSize_w, smallBoxSize_h, '80FF9900'),
                                // 성별 표시,
                                SizedBox(width: 9),
                                smallBox('Ages', petAges[index], 'Years',
                                    smallBoxSize_w, smallBoxSize_h, '8099CCFF'),
                                // 나이 표시
                                SizedBox(width: 9),
                                smallBox('Weight', petWeights[index], 'Kg',
                                    smallBoxSize_w, smallBoxSize_h, '8000FFCC'),
                                // 무게 표시
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
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 23.0, 16.0, 16.0), // 여백 조정
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // 가로 상단 정렬
              children: [
                SizedBox(height: 16.0),
                TextField(
                  controller: _nameController,
                  cursorColor: Colors.deepPurple,
                  decoration: InputDecoration(
                    labelText: '이름',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 189, 189, 204)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.deepPurple), // 커서를 올렸을 때의 밑줄 색상
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                TextField(
                  controller: _weightController,
                  cursorColor: Colors.deepPurple,
                  decoration: InputDecoration(
                    labelText: '몸무게',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 189, 189, 204)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.deepPurple), // 커서를 올렸을 때의 밑줄 색상
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    _updatePetInfo();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 186, 181, 244), // 수정 버튼의 배경색 변경
                  ),
                  child: Text('수정'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        // 상하좌우 마진 설정
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: 60,
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.camera_alt),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: '',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
              backgroundColor: Color.fromARGB(255, 186, 181, 244),
              elevation: 0.0,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          ),
        ),
      ),
    );
  }

  void _updatePetInfo() {
    String name = _nameController.text;
    String weight = _weightController.text;

    // 입력값이 비어있는 경우 수정하지 않고 팝업 창 표시
    if (name.isEmpty || weight.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('수정 실패'),
            content: Text('이름과 몸무게를 입력해주세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }

    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    FirebaseFirestore.instance
        .collection('pet')
        .where('petname', isEqualTo: petName)
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        var document = querySnapshot.docs.first;
        String documentId = document.id;

        FirebaseFirestore.instance.collection('pet').doc(documentId).update({
          'petname': name,
          'petweight': weight,
        }).then((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('수정 완료'),
                content: Text('반려동물 정보가 수정되었습니다.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(); // PetEditPage 이전 페이지로 이동
                    },
                    child: Text('확인'),
                  ),
                ],
              );
            },
          );
        }).catchError((error) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('수정 실패'),
                content: Text('반려동물 정보 수정 중 오류가 발생했습니다.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('확인'),
                  ),
                ],
              );
            },
          );
        });
      }
    });
  }
}
