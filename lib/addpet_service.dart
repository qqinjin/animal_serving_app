// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPetService extends ChangeNotifier {
  final addpetCollection = FirebaseFirestore.instance.collection('pet');

  Future<QuerySnapshot> read(String uid) async {
    // 내 bucketList 가져오기
    return addpetCollection.where('uid', isEqualTo: uid).get();
  }

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

    await addpetCollection.add({
      'petvalue': petvalue, // 유저 식별자
      'petname': petname, // 하고싶은 일
      'petage': petage, // 완료 여부
      'petweight': petweight,
      'petsex': petsex,
      'uid': uid
    });

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
