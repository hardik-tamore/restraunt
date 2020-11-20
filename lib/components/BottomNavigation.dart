import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/myicons.dart';
import 'package:flutter/material.dart';
import '../Home.dart';
import '../WishList.dart';
import '../Profile.dart';
import '../Cart.dart';
import '../Search.dart';
import '../components/component.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../theme/variables.dart';
import '../business/Models/ProductModel.dart';
import 'package:share/share.dart';

class BottomNavigation extends StatefulWidget {
  final index;
  BottomNavigation({this.index});
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List<ProductModel> data;
  Connect con = new Connect();
  Shared sh = new Shared();
  bool isLoading = true;
  int cartVal;
  String number, valid;

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
  void getCart() async {
    print("cart");
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getCart",
            body: {"number": this.number, "valid": this.valid});
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA Cart : ${data.length}");
            cartVal = data.length;
            isLoading = false;
          });
        }
      } catch (e) {
        print("Error : ${e.message}");
        // CDialog cd = new CDialog(context: context);
        // cd.dialogShow("Error", "Some error occured while loading.", "OK");

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

  void share(BuildContext context, String text, String subject) {
    final RenderBox box = context.findRenderObject();
    Share.share(
      text,
      subject: subject,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
    getProducts();
    getCart();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: primary,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.home,color:Colors.white),
          title: new Text("Home"),
        ),
        // BottomNavigationBarItem(
        //   icon: new Image.asset("assets/search.png",width: 22.5),
        //   title: new Text("Search"),
        // ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.bell,color:Colors.white),
          title: new Text("notification"),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.heart,color:Colors.white),
          title: new Text("WishList"),
        ),
        BottomNavigationBarItem(
          // icon: new Image.asset("assets/shopping_cart.png", width: 22.5),
          icon: Container(
            child: Stack(
              children: [
                Center(child: Icon(FontAwesomeIcons.shoppingBasket,color:Colors.white)),
         
               isLoading ? Container() : Positioned(
                  top: 0.0,
                  right: 20.0,
                  child: Container(
                    width: 15.0,
                    height: 15.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "$cartVal",
                        style: TextStyle(color: Colors.red, fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: new Text("Cart"),
        ),
        // BottomNavigationBarItem(
        //   icon: new Image.asset("assets/profile.png", width: 22.5),
        //   title: new Text("Profile"),
        // ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.share,
            size: 22.5,
            color: Colors.white,
          ),
          title: new Text("Share"),
        ),
      ],
      onTap: (index) {
        print(index);
        if (index == 0) {
          // Navigator.of(context).maybePop();
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
        } else if (index == 1) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          // showSearch(
          //   context: context,
          //   delegate: CustomSearchDelegate(product: data),
          // );
          Navigator.of(context).pushNamed('/notification');
        } else if (index == 2) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => WishList()));
        } else if (index == 3) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Cart()));
        } else if (index == 4) {
          // if (Navigator.of(context).canPop()) {
          //   Navigator.of(context).pop();
          // }
          share(
              context,
              "Check out the Chandrahas app and order your Foods Online😁 https://play.google.com/store/apps/details?id=com.hrfruitech.chandrhas",
              "We belive in Quality");
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Profile()));
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Subscription()));
        }
      },
    );
  }
}
