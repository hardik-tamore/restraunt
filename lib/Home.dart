import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

import 'Search.dart';
import 'components/CategoryRow.dart';
import 'package:flutter/material.dart';
import 'components/AppBar.dart';
import 'components/BottomNavigation.dart';
import 'components/CustomCarousel.dart';
import 'components/component.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'theme/variables.dart';
import 'business/LoginStatus.dart';
import 'business/Models/Categories.dart';
import 'components/bestselling/BestSellingRow.dart';
import 'components/featured/FeaturedRow.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'business/FCM.dart';
import 'business/Models/ProductModel.dart';
import 'Product.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//   int _current = 0;
  List<String> imgList;
  List<Categories> cdata;
  List<ProductModel> pdata;
  LoginStatus ls = new LoginStatus();
  Connect con = new Connect();
  Shared sh = new Shared();
  bool isLoading = true;
  String number, valid;
  final FirebaseMessaging _messaging = FirebaseMessaging();
  FCMCrud _fcm = new FCMCrud();
  String bimg;
  List<ProductModel> data;
  getProducts() async {
    if (await con.check() == true) {
      this.number = await sh.getShared("number");
      this.valid = await sh.getShared("id");
      print("Number : ${this.number}");
      print("Validation ID : ${this.valid}");

      try {
        final response = await http.post("${curl}Api/getAllProducts", body: {
          "number": this.number,
          "valid": this.valid,
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          print("Query DATA : ${data}");
          this.data = data
              .map<ProductModel>(((i) => ProductModel.fromJson(i)))
              .toList();
        }
      } catch (e) {
        print("Error : ${e.toString()}");
      }
    }
  }


  void callSlider() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getSlider",
            body: {"number": this.number, "valid": this.valid});
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            imgList = data.map<String>((i) => "${curl + i["img"]}").toList();
            isLoading = false;
          });
        }
      } catch (e) {
        print("Error : ${e.toString()}");
        CDialog cd = new CDialog(context: context);
        cd.dialogShow("Error", "Some error occured while loading.", "OK");
      }
    } else if (await con.check() == false) {
      CDialog cd = new CDialog(context: context);
      cd.dialogShow("Error", "No Internet Connection", "OK");
    }
  }

  void getBanner() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getBanner", body: {
          "number": this.number,
          "valid": this.valid,
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            print("${data[0]["bimg"]}");
            pdata = data
                .map<ProductModel>(((i) => ProductModel.fromJson(i)))
                .toList();
          });
          bimg = curl + data[0]["bimg"];
        } else if (jsonval["status"] == "failed") {
          print("Banner Failed");
        }
      } catch (e) {
        print("Error : ${e.toString()}");
        // CDialog cd = new CDialog(context: context);
        // cd.dialogShow("Error", "Some error occured while loading.", "OK");

      }
    } else if (await con.check() == false) {
      CDialog cd = new CDialog(context: context);
      cd.dialogShow("Error", "No Internet Connection", "OK");
    }
  }

  void getCategories() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getCategories",
            body: {"number": this.number, "valid": this.valid});
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            cdata =
                data.map<Categories>(((i) => Categories.fromJson(i))).toList();
          });
        }
      } catch (e) {
        print("Error : ${e.toString()}");
        CDialog cd = new CDialog(context: context);
        cd.dialogShow("Error", "Some error occured while loading.", "OK");
      }
    } else if (await con.check() == false) {
      CDialog cd = new CDialog(context: context);
      cd.dialogShow("Error", "No Internet Connection", "OK");
    }
  }

  void checkToken(token) async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/checkToken", body: {
          "valid": valid.toString(),
          "token": token.toString(),
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            _fcm.addToken(token).then((val) {
              print("Token added Successfully");
            });
          });
        }
      } catch (e) {
        print("Error : ${e.toString()}");
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

  Future<bool> lgState() async {
    var status = await ls.loginState();
    if (status == false) {
      Navigator.of(context).pushReplacementNamed("/home");
      return false;
    } else {
      return true;
    }
  }

  void initFunction() async {
    lgState().then((val) {
      print(val);
      if (val == true) {
        setState(() {
          getPreferences();
          callSlider();
          getBanner();
          getCategories();

          if (Platform.isIOS) {
            _messaging.onIosSettingsRegistered.listen((data) {
              // _saveDeviceToken();
            });
            _messaging.requestNotificationPermissions(
              IosNotificationSettings(),
            );
          } else {
            // _saveDeviceToken();
          }

          _messaging.configure(
            onMessage: (Map<String, dynamic> message) async {
              Navigator.of(context).pushNamed('/notification');
              print("onMessage: $message");
            },
            onResume: (Map<String, dynamic> message) async {
              print("onResume: $message");
              Navigator.of(context).pushNamed('/notification');
            },
            onLaunch: (Map<String, dynamic> message) async {
              print("onLaunch: $message");
              Navigator.of(context).pushNamed('/notification');
            },
          );

          _messaging.getToken().then((token) {
            print(token);
            checkToken(token);
          });
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFunction();
    getPreferences();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: AppliBar(
          title: "Home",
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 50),
      ),
      body: SafeArea(
        
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
             Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white),
              child: Row(children: [
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 25,
                  ),
                  onPressed: () {},
                ),
                Expanded(
                    child: TextField(
                  style: TextStyle(fontSize: 16, fontFamily: "circle"),
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(product: data),
                    );
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Your Product Here"),
                ))
              ]),
            ),
             SizedBox(
              height: 10.0,
            ),
            isLoading
                ? Center(
                    child: Loading(indicator: BallPulseIndicator(), size: 30.0,color: primary),
    
                  )
                : CustomCarousel(
                    imgList: this.imgList,
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  print("Advertisment Banner Clicked!");
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Product(
                      data: pdata,
                      id: pdata[0].id,
                      val: 0,
                    ),
                  ));
                },
                child: Container(
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    // borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      image: NetworkImage(bimg == null ? "" : bimg),
                      fit: BoxFit.cover,
                      
                    ),
                  ),
                  // child: Center(
                  //   child: Text(
                  //     "Add Banner",
                  //     style: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 24.0,
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "  All Categories",
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CategoryRow(cdata),
            ),
            BestSellingRow(title: "Best Selling"),
            FeaturedRow(
              title: "Featured",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}