import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnimalServingService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 'pet' 컬렉션 내에 petName 문서에 데이터 저장
  Future<void> create(String foodGram, String petName) async {
    try {
      await _firestore.collection('pet').doc(petName).set({
        'food_gram': foodGram
      }, SetOptions(merge: true));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
