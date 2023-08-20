import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'loginpage.dart';
import 'bottomNavigationBar.dart';

class SettingPage extends StatefulWidget{

  const SettingPage({Key? key}) : super(key: key);
  
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2), // 아래쪽으로 오프셋
                blurRadius: 4.0,
              ),
            ],
          ),
          child: AppBar(
            title: Text(
              "Setting",
              style: TextStyle(fontSize: 17.0),
            ),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            elevation: 0,
            actions: [
              TextButton(
                child: Icon(
                  Icons.logout,
                  color: const Color.fromARGB(255, 53, 53, 53),
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
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(30.0),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex, 
        parentContext: context,
      ),
    );
  }
}