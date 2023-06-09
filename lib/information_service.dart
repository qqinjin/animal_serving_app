import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'bucket_service.dart';
import 'information.dart';
import 'loginpage.dart';
import 'pet_state_detail.dart';

/// 홈페이지
class InformationService extends StatefulWidget {
  const InformationService({Key? key}) : super(key: key);

  @override
  State<InformationService> createState() => _InformationServiceState();
}

class _InformationServiceState extends State<InformationService> {
  TextEditingController jobController = TextEditingController();
  List<String> petNames = [];
  String? selectedPetName;

  @override
  void initState() {
    super.initState();
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
          petNames.add(doc.get('petname') as String);
        });
      });

      if (petNames.isNotEmpty) {
        setState(() {
          selectedPetName = petNames.first;
        });
      }
    });
  }

  void updateSelectedPet(String petName) {
    setState(() {
      selectedPetName = petName;
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
              "정보 페이지",
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
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: Text(
                  '사용자 UID: ${user?.uid}',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey[400],
                indent: 3.0,
                endIndent: 3.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                // child: Text(
                //   '동물 이름: $petName',
                //   style: TextStyle(fontSize: 18.0),
                // ),
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey[400],
                indent: 3.0,
                endIndent: 3.0,
              ),
              SizedBox(height: 16.0),
              Text(
                '등록된 반려동물',
                style: TextStyle(fontSize: 18.0),
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey[400],
                indent: 16.0,
                endIndent: 16.0,
              ),
              SizedBox(height: 8.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (String petName in petNames)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            updateSelectedPet(petName);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: selectedPetName == petName
                                ? Color.fromARGB(255, 186, 181, 244)
                                : Colors.grey[300],
                          ),
                          child: Text(petName),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              if (selectedPetName != null)
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('pet')
                      .where('petname', isEqualTo: selectedPetName)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final doc = snapshot.data!.docs.first;
                    final petage = doc.get('petage') as String;
                    final petsex = doc.get('petsex') as String;
                    final uid = doc.get('uid') as String;
                    final petvalue = doc.get('petvalue') as String;
                    final petweight = doc.get('petweight') as String;

                    return Expanded(
                      child: InformationPage(
                        petName: selectedPetName!,
                        petage: petage,
                        petsex: petsex,
                        uid: uid,
                        petvalue: petvalue,
                        petweight: petweight,
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
