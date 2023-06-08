import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'addpet_service.dart';
import 'auth_service.dart';
//import 'bucket_service.dart';
import 'main.dart';

/// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late AuthService authService;
  //get authService => null;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      // ignore: avoid_types_as_parameter_names
      builder: (context, authService, child) {
        final user = authService.currentUser();

        return Scaffold(
          appBar: AppBar(
            title: Text("로그인"),
            backgroundColor: Color.fromARGB(255, 186, 181, 244),
            ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// 현재 유저 로그인 상태
                Center(
                  child: Text(
                    //"로그인해 주세요 🙂",
                    user == null ? "로그인 해주세요" : "${user.email}님 안녕하세요 👋",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                /// 이메일
                TextField(
                  controller: emailController,
                  cursorColor: Colors.deepPurple, // 커서 색상
                  decoration: InputDecoration(
                    hintText: "이메일",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 189, 189, 204)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.deepPurple), // 커서를 올렸을 때의 밑줄 색상
                    ),
                  ),
                ),

                /// 비밀번호
                TextField(
                  controller: passwordController,
                  cursorColor: Colors.deepPurple, // 커서 색상
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: "비밀번호",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 189, 189, 204)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.deepPurple), // 커서를 올렸을 때의 밑줄 색상
                    ),
                  ),
                ),

                SizedBox(height: 32),

                /// 로그인 버튼
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 186, 181, 244), // 변경된 색상
                  ),
                  child: Text("로그인", style: TextStyle(fontSize: 21)),
                  onPressed: () {
                    // 로그인
                    authService.signIn(
                      email: emailController.text,
                      password: passwordController.text,
                      onSuccess: () {
                        // 로그인 성공
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("로그인 성공"),
                        ));

                        // HomePage로 이동
                        Navigator.pushReplacement(
                          context,
                          //MaterialPageRoute(builder: (context) => HomePage()),
                          MaterialPageRoute(builder: (context) => StartPage()),
                        );
                      },
                      onError: (err) {
                        // 에러 발생
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err),
                        ));

                        // HomePage로 이동
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => StartPage()),
                        );
                      },
                    );
                  },
                ),

                /// 회원가입 버튼
                ElevatedButton(
                   style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 186, 181, 244), // 변경된 색상
                  ),
                  child: Text("회원가입", style: TextStyle(fontSize: 21)),
                  onPressed: () {
                    // 회원가입
                    authService.signUp(
                      email: emailController.text,
                      password: passwordController.text,
                      onSuccess: () {
                        // 회원가입 성공
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("회원가입 성공"),
                        ));
                      },
                      onError: (err) {
                        // 에러 발생
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err),
                        ));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
