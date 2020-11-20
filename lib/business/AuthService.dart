import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../components/component.dart';
import '../Home.dart';
import '../Login.dart';
import 'LoginStatus.dart';

class AuthService {

  Shared sh = new Shared();
  LoginStatus ls = new LoginStatus();

  AuthService(){
    
  }

    Future<bool> register() async{
      User user = FirebaseAuth.instance.currentUser;
      bool rval = false;
      print(user.uid);
      print(user.phoneNumber);
      rval = await ls.login(user.phoneNumber, user.uid).then((val) async{
        print(val);
        if(val){
          var a = await sh.getShared("number");
          print("Number : $a");
          return val;
        }
      });
      return rval;
    }
  // Handles Auth
   handleAuth(){
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot){
        if(snapshot.hasData){
          return Home();
        }else{
          return Login();
        }
      },
    );
  }
  checkLogin(){
    if(FirebaseAuth.instance.currentUser != null){
      return true;
    }else{
      return false;
    }
  }

  // SignOut
  signOut() async{
    FirebaseAuth.instance.signOut();
  }
  
  // SignIn
  Future<bool> signIn(AuthCredential authCreds) async{
    bool rval = false;
    rval = await FirebaseAuth.instance.signInWithCredential(authCreds).then((val) async{
     return await register().then((val){
        print(val);
        if(val == true){
          print("Register Process Complete!");
          return true;
        }else{
          return false;
        }
      });
    });
    return rval;
  }

  // SignInWithOTP
  signInWithOTP(otp,verId){
    AuthCredential authCreds = PhoneAuthProvider.credential(verificationId: verId, smsCode: otp);
    signIn(authCreds);
  }
}
