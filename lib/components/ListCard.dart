import 'package:flutter/material.dart';
import '../theme/variables.dart';
import '../business/Models/ProductModel.dart';
import '../Product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'component.dart';
import 'dart:async';

class ListCard extends StatefulWidget {
  final title;
  final unit;
  final price;
  final qty;
  final img;
  final id;
  final Function fn;
  final List<ProductModel> data;
  final int val;
  ListCard(
      {this.title,
      this.price,
      this.qty,
      this.unit,
      this.img,
      this.id,
      this.fn,
      this.data,
      this.val});
  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  String number, valid;
  Connect con = new Connect();
  Shared sh = new Shared();
  // String sunits, sprices;
  List units, prices, cprices;
  List<DropdownMenuItem<String>> unitlist = [];
  List<DropdownMenuItem<String>> pricelist = [];
  List<DropdownMenuItem<String>> cpricelist = [];

  String currentunit, currentprice, currentcprice;

  void addToCart() async {
    if (await con.check() == true) {
      try {
        // print("id : ${this.widget.id}");
        // print("valid : ${this.valid}");

        final response = await http.post("${curl}Api/addToCart", body: {
          "number": this.number,
          "valid": this.valid,
          "id": widget.id,
          "unit": currentunit,
          "price": currentprice,
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            CDialog cd = new CDialog(context: context, tcolor: success1);
            cd.dialogShow("Success", "Product added to cart!", "OK");
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

  void loadCPriceData(List val) {
    pricelist = [];
    for (int i = 0; i < val.length; i++) {
      cpricelist.add(new DropdownMenuItem(
        child: new Text(val[i]),
        value: val[i],
      ));
    }
  }

  void loadAll() {
    setState(() {
      prices = json.decode(widget.price);
      units = json.decode(widget.unit);
      cprices = json.decode(widget.data[widget.val].c_price);
      loadUnitData(units);
      loadPriceData(prices);
      loadCPriceData(cprices);
      // print("Units : $units");
      // print("Prices : $prices");
      currentunit = units[0];
      currentprice = prices[0];
      currentcprice = cprices[0];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreferences();
    loadAll();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List prices = json.decode(widget.price);
    // List units = json.decode(widget.unit);
    // this.unit = units[0];
    // this.price = prices[0];
    // const oneSec = const Duration(seconds: 1);
    // new Timer.periodic(oneSec, (Timer t) {
    //   print('hi!');
    //   // loadAll();
    //   // afterBuild(context);
    //   // buildResults(context);
    //   // buildSuggestions(context);
    //   if (t.isActive) {
    //     t.cancel();
    //   }
    //   // this.dispose();
    // });

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
        margin: EdgeInsets.all(15.0),
        // padding: EdgeInsets.all(10.0),
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
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: double.maxFinite,
              height: 250.0,
              // margin: EdgeInsets.all(10.0),
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
                    image: NetworkImage("${curl + widget.img}"),
                    fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "${widget.title}",
                            style: TextStyle(color: txttitle, fontSize: 16.0),
                            softWrap: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "${widget.data[widget.val].desc}",
                            style: TextStyle(color: txttitle, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                          width: 150.0,
                          child: RichText(
                            text: TextSpan(
                              text: "₹$currentprice",
                              style: TextStyle(color: txttitle, fontSize: 16.0),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "   ",
                                ),
                                TextSpan(
                                  text: "₹$currentcprice",
                                  style: TextStyle(
                                    color: txttitle,
                                    fontSize: 16.0,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Text(
                          //   "₹$currentprice",
                          //   style: TextStyle(color: txttitle, fontSize: 16.0),
                          // ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: primary,
                        child: Center(
                            child: Text(
                          '${(100 - (int.parse(currentprice) / int.parse(currentcprice) * 100)).toStringAsFixed(1)}%\nOFF',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        )),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 1.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: primary,
                                  style: BorderStyle.solid,
                                  width: 1.0),
                            ),
                            // child: Text(
                            //   "${units[0]}",
                            //   style: TextStyle(
                            //       fontSize: 18.0,
                            //       color: Colors.black,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            child: DropdownButton<String>(
                                value: currentunit,
                                items: unitlist,
                                onChanged: (String val) {
                                  setState(() {
                                    this.currentunit = val;
                                    currentprice = prices[units.indexOf(val)];
                                    print(units.indexOf(val));
                                    currentcprice = cprices[units.indexOf(val)];
                                    print(units.indexOf(val));
                                  });
                                }),
                          ),
                          MaterialButton(
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
            // Container(
            //   width: 30.0,
            //   height: 120.0,
            //   decoration: BoxDecoration(
            //       // color: Colors.red,
            //       ),
            //   child: Stack(
            //     children: <Widget>[
            //       // Positioned(
            //       //   top: 0.0,
            //       //   right: 0.0,
            //       //   child: GestureDetector(
            //       //     onTap: widget.fn,
            //       //     child: Icon(Icons.close, color: txt2,),
            //       //     ),
            //       //   ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
