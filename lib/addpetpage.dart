//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addpet_service.dart';
import 'auth_service.dart';
import 'loginpage.dart';
import 'anumal_updatepage.dart';

//import 'main.dart';

class AddPet extends StatefulWidget {
  const AddPet({Key? key}) : super(key: key);

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  TextEditingController petController = TextEditingController();
  TextEditingController breedController = TextEditingController(); //종
  TextEditingController nameController = TextEditingController(); //이름
  TextEditingController ageController = TextEditingController(); // 나이
  TextEditingController genderController = TextEditingController(); //성별
  TextEditingController weightController = TextEditingController(); //체중

  @override
  Widget build(BuildContext context) {
    return Consumer<AddPetService>(
      builder: (context, addpetService, child) {
        final authService = context.read<AuthService>();
        final user = authService.currentUser()!;

        return Scaffold(
          appBar: AppBar(
            title: Text("반려동물추가"),
            backgroundColor: Color.fromARGB(255, 186, 181, 244),
            actions: [
              TextButton(
                child: Text(
                  "로그아웃",
                  style: TextStyle(
                    color: Colors.white,
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
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: breedController,
                              cursorColor: Colors.deepPurple,
                              decoration: InputDecoration(
                                hintText: '종',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .deepPurple), // 커서를 올렸을 때 진한 보라색으로 변경
                                ),
                              ),
                              onChanged: (value) {
                                // 값이 변경되면 컨트롤러의 값도 업데이트
                                breedController.text = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              cursorColor: Colors.deepPurple,
                              decoration: InputDecoration(
                                hintText: '이름',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .deepPurple), // 커서를 올렸을 때 진한 보라색으로 변경
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: ageController,
                              cursorColor: Colors.deepPurple,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '나이',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .deepPurple), // 커서를 올렸을 때 진한 보라색으로 변경
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: genderController,
                              cursorColor: Colors.deepPurple,
                              decoration: InputDecoration(
                                hintText: '성별',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .deepPurple), // 커서를 올렸을 때 진한 보라색으로 변경
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: weightController,
                              cursorColor: Colors.deepPurple,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '무게',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .deepPurple), // 커서를 올렸을 때 진한 보라색으로 변경
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 186, 181, 244),
                      ),
                      icon: Icon(Icons.add),
                      label: Text("추가"),
                      onPressed: () {
                        if (breedController.text.isNotEmpty &&
                            genderController.text.isNotEmpty &&
                            ageController.text.isNotEmpty &&
                            weightController.text.isNotEmpty &&
                            nameController.text.isNotEmpty) {
                          addpetService.create(
                            breedController.text,
                            nameController.text,
                            ageController.text,
                            weightController.text,
                            genderController.text,
                            user.uid,
                          );
                          breedController.clear();
                          genderController.clear();
                          ageController.clear();
                          weightController.clear();
                          nameController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
            ],
          ),
        );
      },
    );
  }
}
