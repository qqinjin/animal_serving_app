import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addpet_service.dart';
import 'auth_service.dart';
import 'loginpage.dart';
import 'anumal_updatepage.dart';
import 'main.dart';

class AddPet extends StatefulWidget {
  const AddPet({Key? key}) : super(key: key);

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  TextEditingController petController = TextEditingController();
  TextEditingController breedController = TextEditingController(); //종
  TextEditingController nameController = TextEditingController(); //이름
  TextEditingController ageController = TextEditingController(); // 나이
  TextEditingController genderController = TextEditingController(); //성별
  TextEditingController weightController = TextEditingController(); //체중

  String? selectedBreed;
  String? selectedGender;
  List<String> breeds = ["dog", "cat", "etc."];
  List<String> genders = ["male", "female"];

  bool showBreedTextField = false;

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('반려동물 등록이 완료되었습니다'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 186, 181, 244),
              ),
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => StartPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void showInputRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('모두 입력해주세요.'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 186, 181, 244),
              ),
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
    return Consumer<AddPetService>(
      builder: (context, addpetService, child) {
        final authService = context.read<AuthService>();
        final user = authService.currentUser()!;

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
                  "Add a pet",
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          _buildCustomDropdown(
                            'species',
                            breeds,
                            selectedBreed,
                            (value) {
                              if (value == null) return;

                              setState(() {
                                selectedBreed = value;
                                breedController.text = value;

                                if (value == 'etc.') {
                                  showBreedTextField = true;
                                } else {
                                  showBreedTextField = false;
                                }
                              });
                            },
                          ),
                          if (showBreedTextField)
                            _buildCustomTextField('직접 입력해주세요', breedController),
                          _buildCustomTextField('name', nameController),
                          _buildCustomTextField('age', ageController),
                          _buildCustomDropdown(
                            'gender',
                            genders,
                            selectedGender,
                            (value) {
                              setState(() {
                                selectedGender = value!;
                                genderController.text = value;
                              });
                            },
                          ),
                          _buildCustomTextField('weight', weightController),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(189, 255, 215, 238), // 시작 색
                              Color.fromARGB(136, 220, 180, 250), // 끝 색
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(15)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Color.fromARGB(255, 154, 100, 255)
                                    .withOpacity(0.5);
                              return null;
                            }),
                            elevation: MaterialStateProperty.all(0),
                            side: MaterialStateProperty.all(BorderSide.none),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ),
                          child: Text("추가"),
                          onPressed: () {
                            if (selectedBreed != null &&
                                selectedGender != null &&
                                ageController.text.isNotEmpty &&
                                weightController.text.isNotEmpty &&
                                nameController.text.isNotEmpty) {
                              addpetService.create(
                                breedController.text,
                                nameController.text,
                                ageController.text,
                                weightController.text,
                                genderController.text,
                                user.uid,
                              );
                              breedController.clear();
                              genderController.clear();
                              ageController.clear();
                              weightController.clear();
                              nameController.clear();

                              showCompletionDialog(); // Display completion dialog
                            } else {
                              showInputRequiredDialog(); // Display input required dialog
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomDropdown(String label, List<String> items,
      String? selectedItem, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 2),
          DropdownButtonFormField<String>(
            value: selectedItem,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 11)),
              );
            }).toList(),
            hint: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 189, 189, 204),
              ),
            ),
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 195, 195, 195)),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 137, 137, 137)),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCustomTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 2),
          TextFormField(
            controller: controller,
            style: TextStyle(fontSize: 11),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 195, 195, 195)),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 137, 137, 137)),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
