import 'package:firebase_auth/firebase_auth.dart';
import 'components/RaisedGradientButton.dart';
import 'package:flutter/material.dart';
import 'components/component.dart';
import 'business/AuthService.dart';
import 'theme/variables.dart';
import 'business/LoginStatus.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool pass = true;
  TextEditingController _mobile = new TextEditingController();
  TextEditingController _otp = new TextEditingController();
  String verificationId, smsCode, authid, phone;
  bool codeSent = false;
  Connect con = new Connect();

  var loginState = false;
  LoginStatus ls = new LoginStatus();

  void lgState() async{
    var status = await ls.loginState();
    setState(() {
      this.loginState = status;
    });
  }

  Future<void> verifyPhone(phoneNo) async{
    if(await con.check() == true){

        print(phoneNo);
        final PhoneVerificationCompleted verified = (AuthCredential authResult) async{
         await AuthService().signIn(authResult).then((val) async{
            print(val);
            if(val){
              print("Authentication & Registration Complete!");
              if(_scaffoldKey.currentContext != null){
                Navigator.of(context).pushReplacementNamed('/home');
              }
            }
          });
        };

        final PhoneVerificationFailed verification_failed = (FirebaseAuthException authException){
          print('${authException.message}');
          CDialog cd = new CDialog(context: context,tcolor: Colors.red);
          cd.dialogShow("Authentication Error", "${authException.message}", "OK");
        };

        final PhoneCodeSent smsSent = (String verId,[int forceResend]){
          this.verificationId = verId;
          setState(() {
            this.codeSent = true;
          });
        };

        final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId){
          this.verificationId = verId;
        };

        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: phoneNo,
            timeout: const Duration(seconds: 5),
            verificationCompleted: verified,
            verificationFailed: verification_failed,
            codeSent: smsSent,
            codeAutoRetrievalTimeout: autoTimeout
        );

    }else if(await con.check() == false){
      CDialog cd = new CDialog(context: context);
      cd.dialogShow("Error", "No Internet Connection", "OK");
    }
  }


  bool validatePhone(String value) {
  Pattern pattern = r'^(?:[+0]9)?[0-9]{10}$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? true : false;
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _mobile.text = "+91";
        if(loginState){
          Navigator.of(context).pushReplacementNamed('/home');
        }
    });
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
                Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 80.0),
                          child: Text("Login", style: TextStyle(color: txttitle, fontSize: 24.0),),
                        ),
                        Theme(
                          data: ThemeData(
                            primaryColor: Colors.black38,
                            cursorColor: Colors.black38,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 45.0),
                                  child: TextFormField(
                                    validator: (value){
                                      print("Value : ${value.length}");
                                      if(value.isEmpty || value.length < 4){
                                        return "Please enter your mobile number";
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Mobile",
                                      contentPadding: EdgeInsets.symmetric(vertical: 10.0,),
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: _mobile,
                                  ),
                                ),
                                SizedBox(height: 30.0,),
                                codeSent ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 45.0),
                                  child: TextFormField(
                                    validator: (value){
                                      if(value.isEmpty){
                                        return "Please enter your otp";
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: "OTP",
                                      contentPadding: EdgeInsets.symmetric(vertical: 10.0,),
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: _otp,
                                  ),
                                ) : Container(),
                                SizedBox(height: 50.0,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                                  child: RaisedGradientButton(
                                    child: codeSent ? Text("Log In", style: TextStyle(color: Colors.white, fontSize: 16.0,),) : Text("Verify", style: TextStyle(color: Colors.white, fontSize: 16.0,),),
                                    gradient: LinearGradient(colors: [primary,secondary]),
                                    onPressed: (){
                                      print("object");
                                      print("Value: ${_formKey.currentState.validate()}");
                                      if(_formKey.currentState.validate()){
                                        codeSent ? AuthService().signInWithOTP(_otp.text, verificationId) : verifyPhone(_mobile.text);
                                        // verifyPhone(_mobile.text);
                                      }
                                    },
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}