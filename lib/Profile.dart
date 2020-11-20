import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:chandrhas/theme/themes.dart';

import 'ProfileEdit.dart';

import 'Cart.dart';
import 'Checkout.dart';
import 'Contact.dart';
import 'Orders.dart';
import 'WishList.dart';
import 'components/AppBar.dart';
import 'components/BottomNavigation.dart';
import 'components/ProfileNavBtn.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'theme/variables.dart';
import 'package:url_launcher/url_launcher.dart';
import 'business/AuthService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'components/component.dart';
import 'business/Models/Customer.dart';
import 'Login.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:chandrhas/theme/themeProvider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
  _launchURL(url) async {
    // const url = 'http://fruitech.co.in/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Customer> customer;
  Connect con = new Connect();
  Shared sh = new Shared();
  String number, valid, name, img, email;

  void getCustomer() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getCustomer", body: {
          "number": this.number,
          "valid": this.valid,
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            customer = data.map<Customer>((i) => Customer.fromJson(i)).toList();
            name = customer[0].name;
            img = customer[0].img;
            email = customer[0].email;
          });
        } else if (jsonval["status"] == "failed") {
          CDialog cd = new CDialog(context: context);
          cd.dialogShow(
              "Error", "Some error occured while loading your info...", "OK");
        }
      } catch (e) {
        print("Error : ${e.message}");
        CDialog cd = new CDialog(context: context);
        cd.dialogShow("Error", "Some error occured while loading.", "OK");
      }
    } else if (await con.check() == false) {
      CDialog cd = new CDialog(context: context);
      cd.dialogShow("Error", "No Internet Connection", "OK");
    }
  }

  getPreferences() async {
    this.number = await sh.getShared("number");
    this.valid = await sh.getShared("id");
    print("Number : ${this.number}");
    print("Validation ID : ${this.valid}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreferences();
    getCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppliBar(title: "Profile"),
          preferredSize: Size(MediaQuery.of(context).size.width, 40)),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [primary, secondary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Hero(
                          tag: "profile_img",
                          child: Image(
                            image: AssetImage("assets/edit.png"),
                            width: 25.0,
                          ),
                        ),
                        onPressed: () {
                          print("Edit!");
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfileEdit()),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 4.0),
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "${img == null ? curl + 'uploads/profile/default_user.png' : curl + img}"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  "${name == null ? '' : name}".toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w100),
                                  // textAlign: TextAlign.end,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0.0),
                                child: Text(
                                  "${name == null ? '' : email}",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w100),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0.0),
                                child: Text(
                                  "${name == null ? '' : number}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w100),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  LimitedBox(
                    maxHeight: double.maxFinite,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 800.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 35.0),
                        child: Column(
                          children: <Widget>[
                            ProfileNavBtn(
                              txt: "My Orders",
                              icon: Icon(
                                FontAwesomeIcons.clipboardList,
                                color: Colors.indigo,
                              ),
                              function: () {
                                print("My Orders!");
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => Orders(),
                                ));
                              },
                            ),
                            ProfileNavBtn(
                              txt: "WishList",
                              icon: Icon(
                                FontAwesomeIcons.solidHeart,
                                color: Colors.redAccent,
                              ),
                              function: () {
                                print("WishList!");
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => WishList(),
                                ));
                              },
                            ),
                            ProfileNavBtn(
                              txt: "Cart",
                              icon: Icon(
                                FontAwesomeIcons.shoppingCart,
                                color: Colors.orange,
                              ),
                              function: () {
                                print("Cart!");
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => Cart(),
                                ));
                              },
                            ),
                            ProfileNavBtn(
                              icon: Icon(
                                FontAwesomeIcons.phoneAlt,
                                color: Colors.blue,
                              ),
                              txt: "Contact Us",
                              function: () {
                                print("Contact Us!");
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => Contact(),
                                ));
                              },
                            ),
                            ProfileNavBtn(
                              txt: "Chat With Us",
                              icon: Icon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.green,
                              ),
                              function: () {
                                print("Chat With Us!");
                                _launchURL(
                                    "https://wa.me/919820825968?text=Hello%2C%20I%20have%20to%20Order%20______");
                              },
                            ),
                            // ProfileNavBtn(
                            //   txt: "Dark Mode",
                            //   icon: Icon(
                            //     FontAwesomeIcons.solidMoon,
                            //     color: Colors.black,
                            //   ),
                            //   function: () {
                            //     print("dark mode");
                                
                            //     Navigator.of(context).push(MaterialPageRoute(
                            //       builder: (BuildContext context) => Themes(),
                            //     ));
                            //   },
                            // ),
                            ProfileNavBtn(
                              txt: "Logout",
                              icon: Icon(
                                Icons.power_settings_new,
                                color: Colors.red,
                              ),
                              function: () {
                                print("Logout!");
                                AuthService().signOut();
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                Navigator.of(context)
                                    .pushReplacementNamed('/login');
                              },
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 50.0),
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "This app is powered by HR&Fruit-Tech",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          _launchURL("http://ihrtechi.com/");
                                        },
                                        child: Image(
                                          image: AssetImage(
                                              "assets/hrfruitech.png"),
                                          width: 300.0,
                                          height: 100.0,
                                          fit: BoxFit.fill,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
