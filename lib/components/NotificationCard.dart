import 'package:flutter/material.dart';
import '../theme/variables.dart';
import '../Home.dart';

class NotificationCard extends StatelessWidget {
  final title;
  final body;
  NotificationCard({this.title,this.body});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
              onTap: (){
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => Home(),
                ));
              },
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 5.0),
                      width: double.maxFinite,
                      child: Text("$title",style: TextStyle(color: txttitle, fontSize: 18.0), textAlign: TextAlign.start,),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20.0, bottom: 15.0),
                      width: double.maxFinite,
                      child: Text("$body",style: TextStyle(color: txttitle, fontSize: 15.0),textAlign: TextAlign.start,),
                    ),
                  ],
                ),
              ),
            );
  }
}