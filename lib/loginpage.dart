import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'addpet_service.dart';
import 'auth_service.dart';
//import 'bucket_service.dart';
import 'main.dart';
import 'signupPage.dart';

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
          
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                SizedBox(height: 50),
                Text(
                  "Welcome,",
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Text(
                  "Sign in to continue!",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color.fromARGB(255, 163, 163, 163),
                  ),
                ),               /// 현재 유저 로그인
                SizedBox(height: 50),

                // 이메일 필드
                Text(
                  'id',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 2),
                TextField(
                  controller: emailController,
                  cursorColor: Color.fromARGB(255, 137, 137, 137),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: "email",
                    hintStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 189, 189, 204),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 195, 195, 195)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 195, 195, 195)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 137, 137, 137)),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              // 비밀번호 필드
                Text(
                  'password',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 2),
                TextField(
                  controller: passwordController,
                  cursorColor: Color.fromARGB(255, 137, 137, 137),
                  obscureText: true, // 비밀번호를 숨기기 위해 true로 설정
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: "password",
                    hintStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 189, 189, 204),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 195, 195, 195)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 195, 195, 195)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 137, 137, 137)),
                    ),
                  ),
                ),

                SizedBox(height: 32),

                /// 로그인 버튼
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(189, 255, 215, 238),  // 시작 색
                        Color.fromARGB(136, 220, 180, 250), // 끝 색
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Color.fromARGB(255, 154, 100, 255).withOpacity(0.5);
                          return null; 
                        }
                      ),
                      elevation: MaterialStateProperty.all(0),
                      side: MaterialStateProperty.all(BorderSide.none),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                    ),
                    child: Text("Login"),
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
                ),

                SizedBox(height: 60),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 11.0,
                        color: Color.fromARGB(255, 129, 129, 129),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 5), // 텍스트 사이의 간격을 주기 위한 SizedBox
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text(
                        "Sign UP",
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.transparent,
                        padding: EdgeInsets.zero, // 패딩 제거
                      ),
                    )
                  ],
                ),

                /// 회원가입 버튼
                
              ],
            ),
          ),
        );
      },
    );
  }
}
