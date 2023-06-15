import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'bucket_service.dart';
import 'loginpage.dart';
import 'addpetpage.dart';
import 'animal_serving_service.dart';
import 'DistributePage.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  TextEditingController jobController = TextEditingController();
  String? dropdownValue;
  List<String> petNames = [];

  @override
  void initState() {
    super.initState();
    dropdownValue = '';
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
          dropdownValue = petNames.first;
        });
      });
    });
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
    return Consumer<AnimalServingService>(
      builder: (context, animalServingService, child) {
        final authService = context.read<AuthService>();
        final user = authService.currentUser()!;

        return Scaffold(
          appBar: AppBar(
            title: Text("배식하기"),
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
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
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
              Divider(height: 3),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: jobController,
                        cursorColor: Colors.deepPurple, // Set cursor color
                        decoration: InputDecoration(
                          hintText: "배식 g 입력",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.deepPurple), // Set underline color
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 186, 181, 244),
                      ),
                      child: Text('주기'),
                      onPressed: () {
                        if (jobController.text.isNotEmpty &&
                            dropdownValue != null) {
                          final jobAmount = jobController.text;
                          animalServingService.create(
                              jobAmount, dropdownValue!);
                          showCompletionDialog(dropdownValue!, jobAmount);
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 186, 181, 244),
                    ),
                    child: Text('배식상황 확인'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DistributePage(petName: dropdownValue!),
                        ),
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
