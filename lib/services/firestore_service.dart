import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreServices{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future insertNote (String title,String description,String userID) async {
    try{
      await firestore.collection("notes").add({
        "title":title,
        "description":description,
        "date":DateTime.now(),
        "userId":userID
      });
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future updateNote(String docId,String title,String description)async{
    try{
      await firestore.collection("notes").doc(docId).update({
        "title":title,
        "description":description,
      });
    }catch(e){
      debugPrint(e.toString());
    }
  }
  Future deleteNote(String docId)async{
    try{
      await firestore.collection("notes").doc(docId).delete();
    }catch(e){
      debugPrint(e.toString());
    }
  }
}