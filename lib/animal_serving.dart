import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'bucket_service.dart';
import 'loginpage.dart';
import 'addpetpage.dart';
import 'animal_serving_service.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  TextEditingController jobController = TextEditingController();
  String? dropdownValue; // DropdownButton에서 선택한 값을 저장하는 변수
  List<String> petNames = []; // Firestore에서 가져온 petname을 저장하는 리스트

  @override
  void initState() {
    super.initState();
    // 기본값 설정 (Firestore에서 첫 번째 데이터를 가져오거나, 고정된 값 설정)
    dropdownValue = '';
    _getPetNamesFromFirestore();
  }

  Future<void> _getPetNamesFromFirestore() async {
    FirebaseFirestore.instance.collection('pet').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          petNames.add(doc.get('petname'));
          dropdownValue = petNames.first;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimalServingService>(
      builder: (context, animalServingService, child) {
        final authService = context.read<AuthService>();
        final user = authService.currentUser()!;

        return Scaffold(
          appBar: AppBar(
            title: Text("배식하기"),
            actions: [
              TextButton(
                child: Text(
                  "로그아웃",
                  style: TextStyle(
                    color: Colors.white,
                  ),
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
              // DropdownButton 추가
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10), // optional: to provide a bit of spacing
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurpleAccent), // 색상은 원하는대로 변경 가능
                    borderRadius: BorderRadius.circular(5), // optional: if you want rounded edges
                  ),
                  child: DropdownButtonHideUnderline( // underline 제거
                    child: DropdownButton<String>(
                      isExpanded: true, // dropdown button to occupy all available space
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: petNames
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              // ... (other widgets)
              // 입력창
              Divider(height: 3),

              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    // 텍스트 입력창
                    Expanded(
                      child: TextField(
                        controller: jobController,
                        decoration: InputDecoration(
                          hintText: "배식 g 입력",
                        ),
                      ),
                    ),

                    // 추가 버튼
                    ElevatedButton(
                      child: Text('주기'),
                      onPressed: () {
                        // create bucket
                        if (jobController.text.isNotEmpty && dropdownValue != null) {
                          animalServingService.create(jobController.text, dropdownValue!);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Divider(height: 3),

              Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: ElevatedButton(
                    child: Text('건강상태 확인'),
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) => AddPet()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
