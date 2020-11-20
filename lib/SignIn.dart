import 'Home.dart';
import 'Login.dart';
import 'components/RaisedGradientButton.dart';
import 'package:flutter/material.dart';
import 'theme/variables.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  bool pass = true;
  TextEditingController _name = new TextEditingController();
  TextEditingController _mobile = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
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
                          child: Text("Sign Up", style: TextStyle(color: txttitle, fontSize: 24.0),),
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
                                      if(value.isEmpty){
                                        return "Please enter your name";
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Name",
                                      contentPadding: EdgeInsets.symmetric(vertical: 10.0,),
                                    ),
                                    controller: _name,
                                  ),
                                ),
                                SizedBox(height: 30.0,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 45.0),
                                  child: TextFormField(
                                    validator: (value){
                                      if(value.isEmpty){
                                        return "Please enter your mobile number";
                                      }else if(value.length > 10 || value.length < 10){
                                        return "Please enter a valid mobile number of 10 digits";
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 45.0),
                                  child: TextFormField(
                                    validator: (value){
                                      if(value.isEmpty){
                                        return "Please enter your password";
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      contentPadding: EdgeInsets.symmetric(vertical: 10.0,),
                                      suffixIcon: IconButton(
                                        onPressed: (){
                                          if(pass == true){
                                            setState(() {
                                              pass = false;
                                            });
                                          }else if(pass == false){
                                            setState(() {
                                              pass = true;
                                            });
                                          }
                                        },
                                        icon: Icon(Icons.remove_red_eye),
                                      ),
                                    ),
                                    obscureText: pass,
                                    controller: _password,
                                  ),
                                ),
                                SizedBox(height: 50.0,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                                  child: RaisedGradientButton(
                                    child: Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 16.0,),),
                                    gradient: LinearGradient(colors: [primary,secondary]),
                                    onPressed: (){
                                      if(_formKey.currentState.validate()){
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                                          builder: (BuildContext context) => Home(),
                                        ));
                                      }
                                    },
                                    ),
                                ),
                                SizedBox(height: 15.0,),
                                GestureDetector(
                                  onTap: (){
                                    print("Sign In!");
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context)=>Login(),
                                    ));
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: txt2, fontSize: 14.0),
                                      children: <TextSpan>[
                                        TextSpan(text: "Already have an account ? "),
                                        TextSpan(text:"Sign In", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
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