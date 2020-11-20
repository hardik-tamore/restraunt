import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FCMCrud{
  bool isLoggedIn(){
    if(FirebaseAuth.instance.currentUser != null){
      return true;
    }else{
      return false;
    }
  }

  Future<void> addToken(data) async{
    if(isLoggedIn()){
      FirebaseFirestore.instance.collection('tokens').add({'token':data}).catchError((e){
        print(e);
      });
    }
  }
}