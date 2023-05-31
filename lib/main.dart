//import 'package:firebase_auth/firebase_auth.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';
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
      home: user == null ? LoginPage() : HomePage(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First page'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              child: Text('반려동물 추가gg'),
              onPressed: () {
                //Second page 불러오기
                //Second page는 스택 상에서 이미 존재하는 First page위에 올라감
                //화면 상에 보이던 First page를 Second page가 가림
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        //builder: (context) =>
                        builder: (_) => AddPet()));
                // builder: 일종의 안전장치. 어떤 위젯이 MaterialPageRoute에 의해 생성되어야 하는지 정의
                // context: flutter에서 자동 할당. 사용할 필요 없으면 사용하지 않아도 됨. 위에서는 (_)처리함
                // builder: (BuildContext context){
                //   return SecondPage();
                // }  //하드코딩 방식
                //context: context가 가지고 있는 위젯트리의 위치 정보에 근거하여 현재 화면상에 보이는 페이지 위치를 확인하고 그 위에 새로운 페이지를 push
              }),
          ElevatedButton(
              child: Text('실시간 탐지'),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => StreamingPage()));
              }),
          ElevatedButton(
              child: Text('배식 / 건강상태'),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Statepage()));
              }),
          ElevatedButton(
              child: Text('배식하기'),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => HomePage2()));
              }),
          ElevatedButton(
              child: Text('개인정보수정'),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => HomePage()));
              }),
        ],
      )),
    );
  }
}
