//import 'package:firebase_auth/firebase_auth.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'bucket_service.dart';
import 'addpet_service.dart';
// ignore: unused_import
import 'loginpage.dart';
//import 'startpage.dart';

import 'addpetpage.dart';
import 'bucketlistpage.dart';
import 'State_Checkpage.dart';

import 'animal_serving.dart';
import 'animal_serving_service.dart';
import 'Streamingpage.dart';
import "pet_state_detail.dart";

// void main() {
//   runApp(const MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => BucketService()),
        //ChangeNotifierProvider(create: (context) => StartPage()),
        ChangeNotifierProvider(create: (context) => AddPetService()),
        ChangeNotifierProvider(create: (context) => AnimalServingService()),
      ],
      child: const MyApp(),
    ),
  );
}

class DefaultFirebaseOptions {
  static var currentPlatform;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final user = context.read<AuthService>().currentUser();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user == null ? LoginPage() : StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override

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
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First page'),
        backgroundColor: Color.fromARGB(255, 186, 181, 244),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 186, 181, 244),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: Text('반려동물 추가'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddPet()),
                );
              },
            ),
            ListTile(
              title: Text('실시간 탐지'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StreamingPage()),
                );
              },
            ),
            ListTile(
              title: Text('배식 / 건강상태'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Statepage()),
                );
              },
            ),
            ListTile(
              title: Text('배식하기'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage2()),
                );
              },
            ),
            ListTile(
              title: Text('개인정보'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              },
            ),
          ],
        ),
      ),
      
      body: ListView.builder(
        itemCount: petNames.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PetDetailPage(petName: petNames[index]),
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
  }
}
