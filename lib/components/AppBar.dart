import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../theme/variables.dart';
import '../theme/myicons.dart';
import '../Cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../components/component.dart';
import '../business/Models/Customer.dart';
import '../Search.dart';
import '../Profile.dart';
import '../business/Models/ProductModel.dart';

class AppliBar extends StatefulWidget {
  final String title;
  AppliBar({@required this.title, Key key}) : super(key: key);

  @override
  _AppliBarState createState() => _AppliBarState();
}

class _AppliBarState extends State<AppliBar> {
  List<ProductModel> data;
  Connect con = new Connect();
  Shared sh = new Shared();
  bool isLoading1 = true;
  bool isLoading2 = true;
  List<Customer> customer;

  String number, valid, img, name;

  void getNotification() async {
    if (await con.check() == true) {
      try {
        final response = await http.post(
          "${curl}Notification/notifications",
        );
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            isLoading1 = false;
          });
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

  void getCart() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getCart",
            body: {"number": this.number, "valid": this.valid});
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            isLoading2 = false;
          });
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
    // getCart();
    // getNotification();
    getProducts();
    getCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      actionsForegroundColor: Colors.white,
      backgroundColor: primary,
      middle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text("${widget.title}",style: TextStyle(fontFamily:"Roboto-Slab",color: Colors.white),),
          ),
          Material(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    MyFlutterApp.search,
                    size: 20,
                  ),
                  onPressed: () {
                    if (data != null) {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                      showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(product: data),
                      );
                    }
                  },
                ),
                GestureDetector(
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  },
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                            "${img == null ? curl + 'uploads/profile/default_user.png' : curl + img}"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: <Widget>[
            //     Stack(
            //       children: <Widget>[
            //         IconButton(icon: Icon(MyFlutterApp.icon_notifications, size: 20,), onPressed: (){
            //           // Navigator.of(context).maybePop();
            //           Navigator.of(context).pushNamed('/notification');
            //         },),
            //         isLoading1 ? Container() :Positioned(
            //           top: 13.0,
            //           right: 16.0,
            //           child: Container(
            //             width: 7.0,
            //             height: 7.0,
            //             decoration: BoxDecoration(
            //               color: danger1,
            //               borderRadius: BorderRadius.circular(5.0)
            //             ),
            //           ),
            //         )
            //       ],
            //     ),
            //     Stack(
            //       children: <Widget>[
            //         IconButton(icon: Icon(MyFlutterApp.cart, size: 20,), onPressed: (){
            //           // Navigator.of(context).maybePop();
            //           Navigator.of(context).pushNamed('/cart');
            //         },),
            //         isLoading2 ? Container() : Positioned(
            //           top: 10.0,
            //           right: 14.0,
            //           child: Container(
            //             width: 7.0,
            //             height: 7.0,
            //             decoration: BoxDecoration(
            //               color: success,
            //               borderRadius: BorderRadius.circular(5.0),
            //             ),
            //           ),
            //         )
            //       ],
            //     ),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }
}
