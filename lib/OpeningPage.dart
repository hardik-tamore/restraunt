import 'Login.dart';
import 'components/RaisedGradientButton.dart';
import 'components/TransparentButton.dart';
import 'package:flutter/material.dart';
import 'theme/variables.dart';
import 'SignIn.dart';

class OpeningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: txt1, fontSize: 18.0),
                        children: <TextSpan>[
                          TextSpan(text: "Welcome to "),
                          TextSpan(
                              text: "Vivlin-Mart",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Text(
                      "Explore Us",
                      style: TextStyle(color: txt1, fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 339.0,
              height: 216.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Image.png"), fit: BoxFit.contain),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  RaisedGradientButton(
                    child: Text(
                      "Log In",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    width: 200.0,
                    gradient: LinearGradient(colors: [primary, secondary]),
                    onPressed: () {
                      print("Log In!");
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Login(),
                      ));
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TransparentButton(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: txt1, fontSize: 16.0),
                    ),
                    width: 200.0,
                    onPressed: () {
                      print("Sign Up!");
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Signin(),
                      ));
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
