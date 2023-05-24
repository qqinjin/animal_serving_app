import 'package:cloud_firestore/cloud_firestore.dart';
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

class _AddPetState extends State<AddPet> {
  TextEditingController petController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<AddPetService>(
      builder: (context, addpet_service, child) {
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
              /// 입력창
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    /// 텍스트 입력창
                    Expanded(
                      child: TextField(
                        controller: petController,
                        decoration: InputDecoration(
                          hintText: "하고 싶은 일을 입력해주세요.",
                        ),
                      ),
                    ),

                    /// 추가 버튼
                    ElevatedButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        // create bucket
                        if (petController.text.isNotEmpty) {
                          addpet_service.create(petController.text, user.uid);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Divider(height: 1),

              /// 버킷 리스트
              Expanded(
                child: FutureBuilder<QuerySnapshot>(
                    future: addpet_service.read(user.uid),
                    builder: (context, snapshot) {
                      //print(snapshot.hasData);
                      // ignore: unused_local_variable
                      final documents = snapshot.data?.docs ?? [];
                      if (documents.isEmpty) {
                        return const Center(child: Text("버킷 리스트를 작성해주세요."));
                      }
                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final doc = documents[index];
                          String job = doc.get('job');
                          bool isDone = doc.get('isDone');
                          return ListTile(
                            title: Text(
                              job,
                              style: TextStyle(
                                fontSize: 24,
                                //color: isDone ? Colors.grey : Colors.black,
                                decoration: isDone
                                    // ignore: dead_code
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            // 삭제 아이콘 버튼
                            trailing: IconButton(
                              icon: Icon(CupertinoIcons.delete),
                              onPressed: () {
                                // 삭제 버튼 클릭시

                                addpet_service.delete(doc.id); //만든 delete함수 호출
                              },
                            ),
                            onTap: () {
                              // 아이템 클릭하여 isDone 업데이트

                              addpet_service.update(doc.id, !isDone);
                            },
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
