import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication 추가
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'bucket_service.dart';
import 'addpet_service.dart';
import 'loginpage.dart';
import 'addpetpage.dart';
import 'bucketlistpage.dart';
import 'State_Checkpage.dart';
import 'animal_serving.dart';
import 'animal_serving_service.dart';
import 'Streamingpage.dart';
import 'pet_state_detail.dart';

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
  List<String> petNames = [];
  String? petName;

  @override
  void initState() {
    super.initState();
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
    User? currentUser = context.watch<AuthService>().currentUser();

    Widget buildUserAvatar() {
      return CircleAvatar(
        child: Icon(Icons.person),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      );
    }

    Widget buildUserHeader() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildUserAvatar(),
          SizedBox(height: 16.0),
          Text(
            currentUser?.email ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('첫 번째 페이지'),
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
              child: buildUserHeader(),
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                      height: 100,
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          leading: Icon(
                            Icons.pets,
                            size: 40,
                            color: Color.fromARGB(255, 245, 179, 176),
                          ),
                          title: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${petNames[index]}',
                              style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 65, 65, 65),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddPet()),
                );
              },
              icon: Icon(
                Icons.add,
                color: Color.fromARGB(255, 65, 65, 65),
              ),
              label: Text(
                '등록',
                style: TextStyle(
                  color: Color.fromARGB(255, 65, 65, 65),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
