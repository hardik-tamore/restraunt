import 'package:flutter/material.dart';

class ProfileNavBtn extends StatelessWidget {
  final txt;
  final icon;
  final function;
  ProfileNavBtn({this.txt,this.icon,this.function});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
              onTap: function,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.black, width:1.0)),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black26,
                  //     blurRadius: 5.0,
                  //     offset: Offset(0.0,0.0),
                  //   ),
                  // ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("$txt", style: TextStyle(fontSize: 20.0),),
                    icon,
                  ],
                ),
              ),
            );
  }
}