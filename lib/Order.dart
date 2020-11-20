import 'components/AppBar.dart';
import 'components/BottomNavigation.dart';
import 'components/OrderCard2.dart';
import 'package:flutter/material.dart';
import 'theme/variables.dart';
import 'business/Models/ProductModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'components/component.dart';

class Order extends StatefulWidget {
  final id;
  final status;
  Order({this.id, this.status});
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  List<ProductModel> pdata;
  Connect con = new Connect();
  Shared sh = new Shared();
  bool isLoading = true;
  bool hasData = false;
  String number, valid;

  void getOrders() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getOrder", body: {
          "number": this.number,
          "valid": this.valid,
          "id": "${widget.id}",
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
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
        print("Error : ${e.message()}");
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
    super.initState();
    getPreferences();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          child: AppliBar(title: "Order"),
          preferredSize: Size(MediaQuery.of(context).size.width, 50.0)),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            isLoading
                ? Center(
                    child:  Container(
              child: Image(image: AssetImage("assets/restGIF.gif"),),
            ),
                  )
                : Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 25.0),
                          child: Text(
                            "Status : ${widget.status}",
                            style: TextStyle(color: txttitle, fontSize: 16.0),
                          ),
                        ),
                        Column(
                          children: pdata
                              .map((i) => OrderCard2(
                                    title: "${i.title}",
                                    qty: "${i.qty}",
                                    price: "${i.price}",
                                    unit: "${i.unit}",
                                    img: "${i.img}",
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Total",
                                style:
                                    TextStyle(color: txttitle, fontSize: 17.0),
                              ),
                              Text(
                                "₹ ${pdata[0].amount}",
                                style:
                                    TextStyle(color: txttitle, fontSize: 17.0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
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
