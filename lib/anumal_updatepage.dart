import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PetEditPage extends StatefulWidget {
  final String petName;

  PetEditPage({required this.petName});

  @override
  _PetEditPageState createState() => _PetEditPageState(petName: petName);
}

class _PetEditPageState extends State<PetEditPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  final String petName;

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
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 23.0, 16.0, 16.0), // 여백 조정
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 가로 상단 정렬
          children: [
            Icon(
              Icons.account_circle,
              size: 130.0,
              color: Color.fromARGB(255, 154, 154, 154),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              cursorColor: Colors.deepPurple,
              decoration: InputDecoration(
                labelText: '이름',
                hintStyle: TextStyle(color: Color.fromARGB(255, 189, 189, 204)),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.deepPurple), // 커서를 올렸을 때의 밑줄 색상
                ),
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _weightController,
              cursorColor: Colors.deepPurple,
              decoration: InputDecoration(
                labelText: '몸무게',
                hintStyle: TextStyle(color: Color.fromARGB(255, 189, 189, 204)),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.deepPurple), // 커서를 올렸을 때의 밑줄 색상
                ),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _updatePetInfo();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 186, 181, 244), // 수정 버튼의 배경색 변경
              ),
              child: Text('수정'),
            ),
          ],
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
