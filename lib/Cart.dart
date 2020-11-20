import 'Address.dart';
import 'components/AppBar.dart';
import 'components/BottomNavigation.dart';
import 'components/CartCard.dart';
import 'components/ListCard2.dart';
import 'components/RaisedGradientButton.dart';
import 'theme/variables.dart';
import 'package:flutter/material.dart';
import 'business/Models/ProductModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'components/component.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<ProductModel> pdata;
  Connect con = new Connect();
  Shared sh = new Shared();
  bool isLoading = true;
  bool hasData = false;
  String number, valid;

  void deleteFromCart(id, int i) async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/deleteFromCart",
            body: {"number": this.number, "valid": this.valid, "id": id});
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            print("delete cart ${id} at ${i}");
            pdata.removeAt(i);
          });
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
            print(data[0]["unit"]);
            this.pdata = data
                .map<ProductModel>(((i) => ProductModel.fromJson(i)))
                .toList();
            hasData = true;
            isLoading = false;
          });
        } else if (jsonval["status"] == "failed") {
          setState(() {
            isLoading = false;
          });
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

  void getCartTotal() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getCartTotal",
            body: {"number": this.number, "valid": this.valid});
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            //  this.total = data[0]["total"];
          });
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
    setState(() {
      getPreferences();
      getCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          child: AppliBar(title: "Cart"),
          preferredSize: Size(MediaQuery.of(context).size.width, 50)),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: Container(
              child: Image(image: AssetImage("assets/restGIF.gif"),),
            ),
              )
            : hasData
                ? ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 25.0),
                              child: Text(
                                "Cart",
                                style:
                                    TextStyle(color: txttitle, fontSize: 24.0),
                              ),
                            ),
                            Column(
                              children: pdata
                                  .map<Widget>((i) => CartCard(
                                        fn: () {
                                          deleteFromCart(
                                              i.id, pdata.indexOf(i));
                                        },
                                        title: "${i.title}",
                                        price: "${i.price}",
                                        qty: "${i.qty}",
                                        unit: "${i.unit}",
                                        img: "${i.img}",
                                        id: "${i.id}",
                                      ))
                                  .toList(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 20.0),
                              child: Divider(
                                color: Color(0xffD8D8D8),
                                thickness: 1,
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 15.0,),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: <Widget>[
                            //       Text("Total", style: TextStyle(color: txttitle, fontSize: 17.0),),
                            //       Text("₹${this.total == null ? 0 : this.total}", style: TextStyle(color: txttitle, fontSize: 17.0),),
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 15.0),
                              child: RaisedGradientButton(
                                gradient: LinearGradient(
                                    colors: [primary, secondary]),
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                height: 60,
                                onPressed: () {
                                  print("Continue To Checkout Page!");
                                  Navigator.of(context).push(MaterialPageRoute(
                                    // builder: (BuildContext context)=>Address(),
                                    builder: (BuildContext context) =>
                                        Address(),
                                  ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      "No products in cart yet!",
                      style: TextStyle(color: txttitle, fontSize: 24.0),
                    ),
                  ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
