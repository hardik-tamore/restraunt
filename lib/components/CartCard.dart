import 'package:flutter/material.dart';
import '../theme/variables.dart';
import 'Counter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'component.dart';

class CartCard extends StatefulWidget {
  final title;
  final unit;
  final price;
  final qty;
  final img;
  final id;
  final Function fn;
  CartCard(
      {this.title,
      this.price,
      this.qty,
      this.unit,
      this.img,
      this.id,
      this.fn});
  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  int value, qtprice, price;
  Connect con = new Connect();
  Shared sh = new Shared();
  String number, valid;
  List images;
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
              
              qtprice = price * value;
            } else if (action == "minus") {
              this.value--;
              qtprice = price * value;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreferences();
    setState(() {
      value = int.tryParse(widget.qty);
      price = int.tryParse(widget.price);
      images = json.decode(widget.img);
      qtprice = price * value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(10.0),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Container(
                  width: 150.0,
                  child: Text(
                    "${widget.title}",
                    style: TextStyle(color: txttitle, fontSize: 16.0),
                    softWrap: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "${widget.unit}",
                  style: TextStyle(color: txt2, fontSize: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "₹${widget.price}",
                  style: TextStyle(color: success1, fontSize: 16.0),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      "₹$qtprice",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
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
                              counterfn("${widget.id}", "minus");
                              widget.fn;
                            } else if (value > 1) {
                              counterfn("${widget.id}", "minus");
                            }
                          });
                        },
                      ),
                      Container(
                        width: 20.0,
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
                            counterfn("${widget.id}", "add");
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // Counter(
              //   id: "${widget.id}",
              //   value: "${widget.qty}",
              // ),
            ],
          ),
          Container(
            width: 30.0,
            height: 120.0,
            decoration: BoxDecoration(
                // color: Colors.red,
                ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: GestureDetector(
                    onTap: widget.fn,
                    child: Icon(
                      Icons.close,
                      color: txt2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
