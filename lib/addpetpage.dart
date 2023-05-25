//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addpet_service.dart';
import 'auth_service.dart';
import 'loginpage.dart';
//import 'main.dart';

class AddPet extends StatefulWidget {
  const AddPet({Key? key}) : super(key: key);

  @override
  State<AddPet> createState() => _AddPetState();
}
//final AddPetService addPetService = Provider.of<AddPetService>(context, listen: false);

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
        // ignore: unused_local_variable
        final authService = context.read<AuthService>();
        // ignore: unused_local_variable
        final user = authService.currentUser()!;

        return Scaffold(
          appBar: AppBar(
            title: Text("반려동물추가요"),
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
                              decoration: InputDecoration(
                                hintText: '종',
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
                              decoration: InputDecoration(
                                hintText: '이름',
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
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '나이',
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
                              decoration: InputDecoration(
                                hintText: '성별',
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
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '무게',
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
                  children: [
                    // Expanded(
                    //   child: TextField(
                    //     controller: petController,
                    //     decoration: InputDecoration(
                    //       hintText: "하고 싶은 일을 입력해주세요.",
                    //     ),
                    //   ),
                    // ),
                    ElevatedButton(
                      child: Icon(Icons.add),
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
                              user.uid);
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
