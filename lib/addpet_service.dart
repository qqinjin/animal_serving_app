// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPetService extends ChangeNotifier {
  final addpetCollection = FirebaseFirestore.instance.collection('pet');

  Future<QuerySnapshot> read(String uid) async {
    return addpetCollection.where('uid', isEqualTo: uid).get();
  }

  void create(String text, String uid) {}

  void delete(String id) {}

  void update(String id, bool bool) {}
}
