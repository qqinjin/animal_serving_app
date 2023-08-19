import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'loginpage.dart';
import 'main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  late AuthService authService;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser();

        return Scaffold(
          
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                SizedBox(height: 20),
                Text(
                  "Create Account,",
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Text(
                  "Sign up to get started!",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color.fromARGB(255, 163, 163, 163),
                  ),
                ),
                // ID(이메일)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    SizedBox(height: 50),
                    Text('id',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.normal)),
                    SizedBox(height: 2),
                    TextField(
                      controller: emailController,
                      cursorColor: Color.fromARGB(255, 137, 137, 137),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0
                        ),
                        hintText: "email",
                        hintStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 189, 189, 204)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 195, 195, 195)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 195, 195, 195)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 137, 137, 137)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 비밀번호
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('password',
                        style: TextStyle(
                            fontSize: 13, 
                            fontWeight: FontWeight.normal
                        )
                    ),
                    SizedBox(height: 2),
                    TextField(
                      controller: passwordController,
                      cursorColor: Color.fromARGB(255, 137, 137, 137),
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, 
                          horizontal: 10.0
                        ),
                        hintText: "password",
                        hintStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 189, 189, 204)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 195, 195, 195)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 195, 195, 195)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 137, 137, 137)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // 이름
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('name',
                        style: TextStyle(
                            fontSize: 13, 
                            fontWeight: FontWeight.normal
                        )
                    ),
                    SizedBox(height: 2),
                    TextField(
                      controller: nameController,
                      cursorColor: Color.fromARGB(255, 137, 137, 137),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, 
                            horizontal: 10.0
                          ),
                        hintText: "name",
                        hintStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 211, 211, 212)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 195, 195, 195)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 195, 195, 195)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 137, 137, 137)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 전화 번호
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('phonenumber',
                        style: TextStyle(
                            fontSize: 13, 
                            fontWeight: FontWeight.normal
                        )
                    ),
                    SizedBox(height: 2),
                    TextField(
                      controller: phoneNumberController,
                      cursorColor: Color.fromARGB(255, 137, 137, 137),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, 
                            horizontal: 10.0
                        ),
                        hintText: "phonenumber",
                        hintStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 189, 189, 204)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 195, 195, 195)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 195, 195, 195)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 137, 137, 137)),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32),

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
                    child: Text("Sign Up"),
                    onPressed: () {
                      authService.signUp(
                        email: emailController.text,
                        password: passwordController.text,
                        onSuccess: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("회원가입 성공"),
                          ));

                          // Firestore에 사용자 정보 저장
                          // Firestore에 사용자 정보 저장
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            FirebaseFirestore.instance.collection('user').add({
                              'uid': user.uid, // 사용자의 UID도 저장 (나중에 문서를 찾기 쉽게 하기 위함)
                              'email': user.email,
                              'name': nameController.text,
                              'phoneNumber': phoneNumberController.text,
                            });
                          }


                          context.read<AuthService>().signOut();

                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (route) => false
                          );
                        },
                        onError: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(error),
                          ));
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
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 11.0,
                        color: Color.fromARGB(255, 129, 129, 129),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 5), // 텍스트 사이의 간격을 주기 위한 SizedBox
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (route) => false
                        );
                      },
                      child: Text(
                        "Login",
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
              ],
            ),
          ),
        );
      },
    );
  }
}
