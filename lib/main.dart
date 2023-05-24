// //import 'package:firebase_auth/firebase_auth.dart';

// //import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// //import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'auth_service.dart';
// import 'bucket_service.dart';
// import 'addpet_service.dart';
// // ignore: unused_import
// import 'loginpage.dart';
// //import 'startpage.dart';

// import 'addpetpage.dart';
// import 'bucketlistpage.dart';

// // void main() {
// //   runApp(const MyApp());
// // }
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => AuthService()),
//         ChangeNotifierProvider(create: (context) => BucketService()),
//         //ChangeNotifierProvider(create: (context) => StartPage()),
//         ChangeNotifierProvider(create: (context) => AddPetService()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class DefaultFirebaseOptions {
//   static var currentPlatform;
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // ignore: unused_local_variable
//     final user = context.read<AuthService>().currentUser();
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: user == null ? LoginPage() : HomePage(),
//     );
//   }
// }

// /// 로그인 페이지
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   late AuthService authService;
//   //get authService => null;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthService>(
//       // ignore: avoid_types_as_parameter_names
//       builder: (context, authService, child) {
//         final user = authService.currentUser();

//         return Scaffold(
//           appBar: AppBar(title: Text("로그인")),
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 /// 현재 유저 로그인 상태
//                 Center(
//                   child: Text(
//                     //"로그인해 주세요 🙂",
//                     user == null ? "로그인해 주세요 🙂" : "${user.email}님 안녕하세요 👋",
//                     style: TextStyle(
//                       fontSize: 24,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 32),

//                 /// 이메일
//                 TextField(
//                   controller: emailController,
//                   decoration: InputDecoration(hintText: "이메일"),
//                 ),

//                 /// 비밀번호
//                 TextField(
//                   controller: passwordController,
//                   obscureText: false, // 비밀번호 안보이게
//                   decoration: InputDecoration(hintText: "비밀번호"),
//                 ),
//                 SizedBox(height: 32),

//                 /// 로그인 버튼
//                 ElevatedButton(
//                   child: Text("로그인", style: TextStyle(fontSize: 21)),
//                   onPressed: () {
//                     // 로그인
//                     authService.signIn(
//                       email: emailController.text,
//                       password: passwordController.text,
//                       onSuccess: () {
//                         // 로그인 성공
//                         ScaffoldMessenger.of(context)
//                             .showSnackBar(const SnackBar(
//                           content: Text("로그인 성공"),
//                         ));

//                         // HomePage로 이동
//                         Navigator.pushReplacement(
//                           context,
//                           //MaterialPageRoute(builder: (context) => HomePage()),
//                           MaterialPageRoute(builder: (context) => StartPage()),
//                         );
//                       },
//                       onError: (err) {
//                         // 에러 발생
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text(err),
//                         ));

//                         // HomePage로 이동
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => StartPage()),
//                         );
//                       },
//                     );
//                   },
//                 ),

//                 /// 회원가입 버튼
//                 ElevatedButton(
//                   child: Text("회원가입", style: TextStyle(fontSize: 21)),
//                   onPressed: () {
//                     // 회원가입
//                     authService.signUp(
//                       email: emailController.text,
//                       password: passwordController.text,
//                       onSuccess: () {
//                         // 회원가입 성공
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text("회원가입 성공"),
//                         ));
//                       },
//                       onError: (err) {
//                         // 에러 발생
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text(err),
//                         ));
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// /// 홈페이지
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   TextEditingController jobController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<BucketService>(
//       builder: (context, bucketService, child) {
//         // ignore: unused_local_variable
//         final authService = context.read<AuthService>();
//         // ignore: unused_local_variable
//         final user = authService.currentUser()!;

//         return Scaffold(
//           appBar: AppBar(
//             title: Text("버킷 리스트"),
//             actions: [
//               TextButton(
//                 child: Text(
//                   "로그아웃",
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//                 onPressed: () {
//                   // 로그아웃
//                   context.read<AuthService>().signOut();

//                   // 로그인 페이지로 이동
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginPage()),
//                   );
//                 },
//               ),
//             ],
//           ),
//           body: Column(
//             children: [
//               /// 입력창
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Row(
//                   children: [
//                     /// 텍스트 입력창
//                     Expanded(
//                       child: TextField(
//                         controller: jobController,
//                         decoration: InputDecoration(
//                           hintText: "하고 싶은 일을 입력해주세요.",
//                         ),
//                       ),
//                     ),

//                     /// 추가 버튼
//                     ElevatedButton(
//                       child: Icon(Icons.add),
//                       onPressed: () {
//                         // create bucket
//                         if (jobController.text.isNotEmpty) {
//                           bucketService.create(jobController.text, user.uid);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(height: 1),

//               /// 버킷 리스트
//               Expanded(
//                 child: FutureBuilder<QuerySnapshot>(
//                     future: bucketService.read(user.uid),
//                     builder: (context, snapshot) {
//                       //print(snapshot.hasData);
//                       // ignore: unused_local_variable
//                       final documents = snapshot.data?.docs ?? [];
//                       if (documents.isEmpty) {
//                         return const Center(child: Text("버킷 리스트를 작성해주세요."));
//                       }
//                       return ListView.builder(
//                         itemCount: documents.length,
//                         itemBuilder: (context, index) {
//                           final doc = documents[index];
//                           String job = doc.get('job');
//                           bool isDone = doc.get('isDone');
//                           return ListTile(
//                             title: Text(
//                               job,
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 //color: isDone ? Colors.grey : Colors.black,
//                                 decoration: isDone
//                                     // ignore: dead_code
//                                     ? TextDecoration.lineThrough
//                                     : TextDecoration.none,
//                               ),
//                             ),
//                             // 삭제 아이콘 버튼
//                             trailing: IconButton(
//                               icon: Icon(CupertinoIcons.delete),
//                               onPressed: () {
//                                 // 삭제 버튼 클릭시

//                                 bucketService.delete(doc.id); //만든 delete함수 호출
//                               },
//                             ),
//                             onTap: () {
//                               // 아이템 클릭하여 isDone 업데이트

//                               bucketService.update(doc.id, !isDone);
//                             },
//                           );
//                         },
//                       );
//                     }),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// //////
// class StartPage extends StatefulWidget {
//   const StartPage({Key? key}) : super(key: key);

//   @override
//   State<StartPage> createState() => _StartPageState();
// }

// class _StartPageState extends State<StartPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('First page'),
//       ),
//       body: Center(
//           child: Column(
//         children: [
//           ElevatedButton(
//               child: Text('반려동물 추가'),
//               onPressed: () {
//                 //Second page 불러오기
//                 //Second page는 스택 상에서 이미 존재하는 First page위에 올라감
//                 //화면 상에 보이던 First page를 Second page가 가림
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         //builder: (context) =>
//                         builder: (_) => AddPet()));
//                 // builder: 일종의 안전장치. 어떤 위젯이 MaterialPageRoute에 의해 생성되어야 하는지 정의
//                 // context: flutter에서 자동 할당. 사용할 필요 없으면 사용하지 않아도 됨. 위에서는 (_)처리함
//                 // builder: (BuildContext context){
//                 //   return SecondPage();
//                 // }  //하드코딩 방식
//                 //context: context가 가지고 있는 위젯트리의 위치 정보에 근거하여 현재 화면상에 보이는 페이지 위치를 확인하고 그 위에 새로운 페이지를 push
//               }),
//           ElevatedButton(
//               child: Text('실시간 탐지'),
//               onPressed: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (_) => HomePage()));
//               }),
//           ElevatedButton(
//               child: Text('배식 / 건강상태'),
//               onPressed: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (_) => HomePage()));
//               }),
//           ElevatedButton(
//               child: Text('배식하기'),
//               onPressed: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (_) => HomePage()));
//               }),
//           ElevatedButton(
//               child: Text('개인정보수정'),
//               onPressed: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (_) => HomePage()));
//               }),
//         ],
//       )),
//     );
//   }
// }
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

//////
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
              child: Text('반려동물 추가'),
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
                    context, MaterialPageRoute(builder: (_) => HomePage()));
              }),
          ElevatedButton(
              child: Text('배식 / 건강상태'),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => HomePage()));
              }),
          ElevatedButton(
              child: Text('배식하기'),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => HomePage()));
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
