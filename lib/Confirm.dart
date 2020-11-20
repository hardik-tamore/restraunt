import 'Home.dart';
import 'components/RaisedGradientButton.dart';
import 'theme/variables.dart';
import 'package:flutter/material.dart';

class Confirm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                // color: Colors.red,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Image(image: AssetImage("assets/like.png"), fit: BoxFit.contain, width: 200.0,),
                    ),
                    Column(
                      children: <Widget>[
                        Text("Confirmation", style: TextStyle(color: txttitle, fontSize: 30.0),),
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 110.0, vertical: 20),
                           child: Column(
                             children: <Widget>[
                               Text("You have successfully", style: TextStyle(color: txt1, fontSize: 14.0), textAlign: TextAlign.center,),
                               Text("completed your payment procedure", style: TextStyle(color: txt1, fontSize: 14.0), textAlign: TextAlign.center,),
                             ],
                           ),
                         ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: RaisedGradientButton(
                  height: 60.0,
                  gradient: LinearGradient(colors: [primary,secondary]),
                  child: Text("Back To Home", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
                  onPressed: (){
                    print("Go to Home!");
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context)=> Home(),
                    ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}