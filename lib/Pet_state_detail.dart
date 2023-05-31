import 'package:flutter/material.dart';
import 'HealthPage.dart';
import 'DistributePage.dart';

class PetDetailPage extends StatelessWidget {
  final String petName;

  const PetDetailPage({required this.petName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 186, 181, 244),
        elevation: 0,
        title: Text('$petName'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.0), // 상단 여백
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DistributePage(petName: petName),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.restaurant),
                  title: Text('배식 상황'),
                  subtitle: Text('현재 반려동물의 배식상황을 확인해보세요.'),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.0), // 리스트 항목 사이 간격
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthPage(petName: petName),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('건강 상태'),
                  subtitle: Text('반려동물의 건강상태를 확인해보세요.'),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0), // 하단 여백
        ],
      ),
    );
  }
}

