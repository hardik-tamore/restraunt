import 'components/AppBar.dart';
import 'components/BottomNavigation.dart';
import 'theme/variables.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  _launchURL(url) async {
    // const url = 'http://fruitech.co.in/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppliBar(title: "Contact Us"),
          preferredSize: Size(MediaQuery.of(context).size.width, 50.0)),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 60.0,
                      ),
                      Text(
                        "Chandrahas",
                        style: TextStyle(color: txttitle, fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 25.0),
                        child: Text(
                         "Hotel Chandrahas: We provide a variety of Cusines ranging from Chinese, Indian and Tandoori Dishes. We are deliver our spicy dishes all over Airoli with zero delivery charges. Now Enjoy the Most authentic Curries from Hotel Vrushali with zero hazzle.",
                          style: TextStyle(color: txttitle, fontSize: 14.0),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Container(
                        width: double.infinity,
                        // color: Colors.blue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 25.0),
                                    child: Text("TAP TO CALL",style: TextStyle(fontWeight:FontWeight.bold),),),
                            GestureDetector(
                              onTap: () {
                                _launchURL("tel:+919892427079");
                              },
                              
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 25.0),
                                child: Text(
                                  "+91 9892427079",
                                  style: TextStyle(
                                      color: Colors.blue,decoration: TextDecoration.underline, fontSize: 16.0),
                                ),
                              ),
                            ),
                             GestureDetector(
                              onTap: () {
                                _launchURL("tel:+919820825968");
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 25.0),
                                child: Text(
                                  "+91 9820825968",
                                  style: TextStyle(
                                      color: Colors.blue,decoration: TextDecoration.underline, fontSize: 16.0),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       vertical: 8.0, horizontal: 25.0),
                            //   child: Text(
                            //     "+91 79057 76282",
                            //     style:
                            //         TextStyle(color: txttitle, fontSize: 16.0),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
                            //   child: Text("support@fruitech.co.in",style: TextStyle(color: txttitle, fontSize: 16.0),),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
                            //   child: Text("ihrtechi.com",style: TextStyle(color: txttitle, fontSize: 16.0),),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
                            //   child: Text("fruitech.co.in",style: TextStyle(color: txttitle, fontSize: 16.0),),
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 25.0),
                              child: Text(
                                "Girja Kunj Opp Ajit kanta Kalyan Shil road MIDC No.1 Dombivli East",
                                style:
                                    TextStyle(color: txttitle, fontSize: 16.0),
                              ),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            Center(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Powered By:",
                                    style: TextStyle(
                                        color: txttitle,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _launchURL("http://ihrtechi.com/");
                                      },
                                      child: Image(
                                        image:
                                            AssetImage("assets/hrfruitech.png"),
                                        width: 200.0,
                                        height: 100.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
