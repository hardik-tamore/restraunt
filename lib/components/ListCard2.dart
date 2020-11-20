import 'package:flutter/material.dart';
import '../theme/variables.dart';
import '../business/Models/ProductModel.dart';
import '../Product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'component.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

class ListCard2 extends StatefulWidget {
  final title;
  final unit;
  final price;
  final c_price;
  final qty;
  final img;
  final id;
  final Function fn;
  final List<ProductModel> data;
  final int val;
  ListCard2(
      {this.title,
      this.price,
      this.c_price,
      this.qty,
      this.unit,
      this.img,
      this.id,
      this.fn,
      this.data,
      this.val});
  @override
  _ListCard2State createState() => _ListCard2State();
}

class _ListCard2State extends State<ListCard2> {
  String number, valid;
  Connect con = new Connect();
  Shared sh = new Shared();
  // String sunits, sprices;
  List units, prices, c_prices, images;
  List<DropdownMenuItem<String>> unitlist = [];
  List<DropdownMenuItem<String>> pricelist = [];
  String currentunit, currentprice, currentcprice;
  List<ProductModel> pdata;
  String cartid;
  int value, qtprice;
  bool counterstate = false;

  void getCart() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getCartById", body: {
          "number": this.number,
          "valid": this.valid,
          "pid": widget.id.toString(),
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        print("Cart Data : $data");
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            this.pdata = data
                .map<ProductModel>(((i) => ProductModel.fromJson(i)))
                .toList();
            cartid = pdata[0].id;
            value = int.tryParse(pdata[0].qty);
            counterstate = true;
          });
        } else if (jsonval["status"] == "failed") {
          setState(() {
            counterstate = false;
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

  void addToCart() async {
    if (await con.check() == true) {
      try {
        // print("id : ${this.widget.id}");
        // print("valid : ${this.valid}");

        final response = await http.post("${curl}Api/addToCart", body: {
          "number": this.number,
          "valid": this.valid,
          "id": this.widget.id,
          "unit": currentunit.toString(),
          "price": currentprice.toString(),
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            // CDialog cd = new CDialog(context: context, tcolor: success1);
            // cd.dialogShow("Success", "Product added to cart!", "OK");
            Fluttertoast.showToast(
              msg: "Product added to cart!",
              timeInSecForIosWeb: 4,
            );
            value = 1;
            getCart();
            counterstate = true;
          });
        } else if (jsonval["status"] == "available") {
          setState(() {
            print("DATA : ${data}");
            CDialog cd = new CDialog(context: context, tcolor: warning1);
            cd.dialogShow(
                "Alert!", "Product already added to cart successfully!", "OK");
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

  void counterfn(id, action) async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/counter", body: {
          "number": this.number,
          "valid": this.valid,
          "id": id.toString(),
          "action": action,
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            print("Quantity updated successfully.");
            if (action == "add") {
              this.value++;
              qtprice = int.tryParse(currentprice) * value;
            } else if (action == "minus") {
              this.value--;
              qtprice = int.tryParse(currentprice) * value;
            }
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

  void loadUnitData(List val) {
    unitlist = [];
    for (int i = 0; i < val.length; i++) {
      unitlist.add(new DropdownMenuItem(
        child: new Text(val[i]),
        value: val[i],
      ));
    }
  }

  void loadPriceData(List val) {
    pricelist = [];
    for (int i = 0; i < val.length; i++) {
      pricelist.add(new DropdownMenuItem(
        child: new Text(val[i]),
        value: val[i],
      ));
    }
  }

  void loadAll() {
    setState(() {
      prices = json.decode(widget.price);
      c_prices = json.decode(widget.c_price);
      units = json.decode(widget.unit);
      images = json.decode(widget.img);
      loadUnitData(units);
      loadPriceData(prices);
      // print("Units : $units");
      // print("Prices : $prices");
      currentunit = units[0];
      currentprice = prices[0];
      currentcprice = c_prices[0];
      qtprice = int.tryParse(currentprice);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreferences();
    getCart();
    loadAll();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        print("Product Tapped! & ID=${widget.id}");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Product(
              id: "${widget.id}",
              data: widget.data,
              val: widget.val,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              offset: Offset(0.0, 1.5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 100.0,
              height: 100.0,
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    offset: Offset(0.0, 1.5),
                  ),
                ],
                image: DecorationImage(
                    image: NetworkImage("${curl + images[0]}"),
                    fit: BoxFit.cover),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.55,
                    child: Text(
                      "${widget.title}",
                      style: TextStyle(color: txttitle, fontSize: 16.0,),
                      softWrap: true,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Container(
                            // color: Colors.red,
                            child: Text(
                              "₹${currentprice}.00",
                              style: TextStyle(color: success1, fontSize: 14.0,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          // color: Colors.yellow,
                          child: Text(
                            "₹${currentcprice}.00",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough, fontSize: 14.0,
                                color: Colors.red,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 30),
                   
                  ],
                ),
                ButtonBar(
                  children: <Widget>[
                      Container(
                      // color: Colors.yellow,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: DropdownButton<String>(
                          value: currentunit,
                          items: unitlist,
                          onChanged: (String val) {
                            setState(() {
                              this.currentunit = val;
                              currentprice = prices[units.indexOf(val)];
                              print(units.indexOf(val));
                              currentcprice = c_prices[units.indexOf(val)];
                              print(currentcprice);
                            });
                          }),
                    ),SizedBox(width:0),
                    // SizedBox(
                    //   width: 0,
                    // ),
                    counterstate
                        ? Container(
                            child: Column(
                              children: <Widget>[
                                // Center(
                                //   child: Text(
                                //     "₹$qtprice",
                                //     style: TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 15.0,
                                //     ),
                                //   ),
                                // ),
                                Row(
                                  children: <Widget>[
                                  
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        // To Do On Decrement
                                        setState(() {
                                          if (value == 0) {
                                            counterfn("$cartid", "minus");
                                            getCart();
                                            counterstate = false;
                                          } else if (value > 1) {
                                            counterfn("$cartid", "minus");
                                          }
                                        });
                                      },
                                    ),
                                    Container(
                                      width: 4.0,
                                      child: Center(
                                        child: Text(
                                          "$value",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        // To Do On Increment
                                        setState(() {
                                          counterfn("$cartid", "add");
                                          print(cartid);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : MaterialButton(
                            minWidth: 100,
                            color: primary,
                            onPressed: () {
                              // print("Product Tapped! & ID=${widget.id}");
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (BuildContext context) => Product(id: "${widget.id}",data: widget.data,val: widget.val,),),
                              //   );
                              addToCart();
                            },
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
