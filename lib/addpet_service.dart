// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPetService extends ChangeNotifier {
  final addpetCollection = FirebaseFirestore.instance.collection('pet');
  //final HealthCollection = FirebaseFirestore.instance.collection('health');

// **pet 컬렉션 내의 health 컬렉션을 불러옵니다
//**final healthCollection = petCollection.doc('petDocumentID').collection('health');

  Future<QuerySnapshot> read(String uid) async {
    // 내 bucketList 가져오기
    return addpetCollection.where('uid', isEqualTo: uid).get();
  }

  //final pid =
  //final healthCollection = addpetCollection.where('uid', isEqualTo: uid).collection('health');
//final healthCollection = addpetCollection.doc('pid').collection('health');

//   void create(String job, String uid) async {
// // bucket 만들기

//     await addpetCollection.add({
//       'uid': uid, // 유저 식별자
//       'job': job, // 하고싶은 일
//       'isDone': false, // 완료 여부
//     });
//     notifyListeners(); // 화면 갱신
//   }
  void create(String petvalue, String petname, String petage, String petweight,
      String petsex, String uid) async {
// bucket 만들기

    final petDocument = await addpetCollection.add({
      'petvalue': petvalue, // 유저 식별자
      'petname': petname, // 하고싶은 일
      'petage': petage, // 완료 여부
      'petweight': petweight,
      'petsex': petsex,
      'uid': uid,
      'animal_check': '0',
      'food_gram': '0',
      'food_check': '0'
    });

    final healthCollection = petDocument.collection('health');
    final recordCollection = petDocument.collection('record');
    final date = Timestamp.now();
    String mapweight = '첫생성!';

    await healthCollection.add({
      'date': date,
      'temperature': mapweight,
      'weight': mapweight,
    });

    final remainingFeedingMap = {
      'date': date,
      'weight': mapweight,
    };

    await recordCollection
        .add({'남은배식량': remainingFeedingMap, '배식량': remainingFeedingMap});
//, '배식량': remainingFeedingMap
    notifyListeners(); // 화면 갱신
  }

  void update(String docId, bool isDone) async {
    // bucket isDone 업데이트

    await addpetCollection.doc(docId).update({'isDone': isDone});
    notifyListeners(); // 화면 갱신
  }

  void delete(String docId) async {
    // bucket 삭제

    await addpetCollection.doc(docId).delete();
    notifyListeners(); // 화면 갱신
  }
}
