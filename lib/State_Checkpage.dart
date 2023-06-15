import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'addpet_service.dart';
import 'auth_service.dart';
import 'bucket_service.dart';
import 'loginpage.dart';
//import 'main.dart';

import 'pet_state_detail.dart';

/// 홈페이지
class Statepage extends StatefulWidget {
  const Statepage({Key? key}) : super(key: key);

  @override
  State<Statepage> createState() => _StatePageState();
}

class _StatePageState extends State<Statepage> {
  List<String> petNames = [];
  String? petName;

  @override
  void initState() {
    super.initState();
    // 기본값 설정 (Firestore에서 첫 번째 데이터를 가져오거나, 고정된 값 설정)
    petName = '';
    _getPetNamesFromFirestore();
  }

  Future<void> _getPetNamesFromFirestore() async {

    final user = context.read<AuthService>().currentUser();
    final uid = user?.uid;

    FirebaseFirestore.instance
        .collection('pet')
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          petNames.add(doc.get('petname'));
          petName = petNames.first;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BucketService>(
      builder: (context, bucketService, child) {
        final authService = context.read<AuthService>();
        final user = authService.currentUser()!;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 186, 181, 244),
            elevation: 0,
            title: Text(
              "반려동물의 상태확인",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              TextButton(
                child: Text(
                  "로그아웃",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                onPressed: () {
                  // 로그아웃
                  context.read<AuthService>().signOut();

                  // 로그인 페이지로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: petNames.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 3.0, 
                    horizontal: 3.0
                ),
                child: GestureDetector(
                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetailPage(petName: petNames[index]),
                      ),
                    );
                  },
                
                child: Container(
                  height: 100, // 카드 높이 설정
                  child: Card(
                    color: Colors.white, // 카드 배경색 설정
                    elevation: 2, // 카드 그림자 설정
                    child: ListTile(
                      title: Text(
                        '이름 : ${petNames[index]}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 65, 65, 65), // 텍스트 색상
                        ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
