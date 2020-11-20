import 'package:chandrhas/components/ProductCarousel.dart';

import 'Cart.dart';
import 'components/AllComments.dart';
import 'components/AppBar.dart';
import 'components/BottomNavigation.dart';
import 'theme/variables.dart';
import 'package:flutter/material.dart';
import 'business/Models/ProductModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'components/component.dart';
import 'package:flutter/services.dart';
import 'business/Models/CommentModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Product extends StatefulWidget {
  final id;
  final List<ProductModel> data;
  final int val;

  Product({this.id, this.data, this.val});
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  String img =
      "https://www.gomatabliss.com/wp-content/uploads/2019/06/500-toor-dal-arhar-dal-desi-arhar-dal-un-branded-original-imaeymjgrjw8xgvw.jpeg";
  bool wlist = false;
  List<ProductModel> pdata;

  Connect con = new Connect();
  Shared sh = new Shared();
  bool isLoading = true;
  bool isLoading2 = true;
  String number, valid;
  String cvL1;
  List units, prices, cprices, images;
  List<String> imgList;
  List<CommentModel> cdata;
  List<DropdownMenuItem<String>> unitlist = [];
  List unitlist2 = ["1", "2", "3"];
  List<DropdownMenuItem<String>> pricelist = [];
  List<DropdownMenuItem<String>> cpricelist = [];

  final _formKey = GlobalKey<FormState>();
  TextEditingController comment = new TextEditingController();

  bool pcode = false;
  bool opcode = false;
  bool hasData = false;
  bool counterstate = false;
  String cartid;

  int value, qtprice;

  String currentunit, currentprice, currentcprice;

  void addToWishList() async {
    if (await con.check() == true) {
      try {
        // print("id : ${this.widget.id}");
        // print("valid : ${this.valid}");

        final response = await http.post("${curl}Api/addToWishList", body: {
          "number": this.number,
          "valid": this.valid,
          "id": this.widget.id
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            wlist = true;
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

  void removeFromWishList() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/removeFromWishList",
            body: {
              "number": this.number,
              "valid": this.valid,
              "id": this.widget.id
            });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            wlist = false;
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

  void checkWishList() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/checkWishList", body: {
          "number": this.number,
          "valid": this.valid,
          "id": this.widget.id
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            wlist = true;
          });
        } else if (jsonval["status"] == "failed") {
          setState(() {
            print("DATA : ${data}");
            wlist = false;
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

  void addComment() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Comment/add", body: {
          "number": this.number,
          "valid": this.valid,
          "pid": this.widget.id,
          "comment": comment.text,
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            CDialog cd = new CDialog(context: context, tcolor: success1);
            cd.dialogShow("Success", "Comment Added Succesfully!", "OK");
            comment.text = '';
            Future.delayed(Duration(seconds: 1), () {
              getComments();
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

  void getComments() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Comment/get", body: {
          "number": this.number,
          "valid": this.valid,
          "pid": widget.id.toString(),
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            this.cdata = data
                .map<CommentModel>(((i) => CommentModel.fromJson(i)))
                .toList();
            hasData = true;
            isLoading2 = false;
          });
        } else if (jsonval["status"] == "failed") {
          setState(() {
            hasData = false;
            isLoading2 = false;
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

  wishListState() {
    if (wlist == false) {
      setState(() {
        addToWishList();
      });
    } else if (wlist == true) {
      setState(() {
        removeFromWishList();
      });
    }
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

  void loadCpriceData(List val) {
    cpricelist = [];
    for (int i = 0; i < val.length; i++) {
      cpricelist.add(new DropdownMenuItem(
        child: new Text(val[i]),
        value: val[i],
      ));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      print("ProductID : ${widget.id}");
      getPreferences();
      checkWishList();
      print("Units ${widget.data[widget.val].unit}");
      print("Images ${widget.data[widget.val].img}");

      units = json.decode(widget.data[widget.val].unit);
      prices = json.decode(widget.data[widget.val].price);
      cprices = json.decode(widget.data[widget.val].c_price);
      images = json.decode(widget.data[widget.val].img);
      imgList = images.map<String>((i) => "${curl + i}").toList();

      print("Array Count is ${units.length}");
      print("0 Val is ${units}");
      loadUnitData(units);
      loadPriceData(prices);
      loadCpriceData(cprices);
      currentunit = units[0];
      currentprice = prices[0];
      currentcprice = cprices[0];

      getComments();
      print("Val of Units is $units");
      qtprice = int.tryParse(currentprice);
      // value = int.tryParse(widget.data[widget.val].qty);
      getCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppliBar(title: "Product"),
          preferredSize: Size(MediaQuery.of(context).size.width, 50)),
      body: SafeArea(
        child: widget.data == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300.0,
                    // decoration: BoxDecoration(
                    //   color: Colors.red,
                    //   image: DecorationImage(
                    //     image: NetworkImage(
                    //         "${curl + widget.data[widget.val].img}"),
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    child: Stack(
                      children: <Widget>[
                        ProductCarousel(
                          imgList: this.imgList,
                        ),
                        Positioned(
                          top: 15.0,
                          right: 15.0,
                          child: AnimatedCrossFade(
                            crossFadeState: wlist
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: GestureDetector(
                              child: Image(
                                image: AssetImage("assets/wishlist.png"),
                                width: 29.0,
                              ),
                              onTap: () {
                                print("wishList Removed");
                                wishListState();
                              },
                            ),
                            secondChild: GestureDetector(
                              child: Image(
                                image: AssetImage("assets/wishlist_empty.png"),
                                width: 29.0,
                              ),
                              onTap: () {
                                print("wishList Added");
                                wishListState();
                              },
                            ),
                            duration: const Duration(milliseconds: 200),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: Text(
                          "${widget.data[widget.val].title}",
                          style: TextStyle(color: txttitle, fontSize: 24.0),
                        ),
                      ),
                      FlatButton(
                        color: Colors.green[400],
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        onPressed: () {
                          /*...*/
                        },
                        child: Center(
                            child: Text(
                          '${(100 - (int.parse(currentprice) / int.parse(currentcprice) * 100)).toStringAsFixed(0)}% OFF',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        )),
                      ),
                      //   CircleAvatar(
                      //   backgroundColor: primary,
                      //   child: Center(
                      //       child: Text(
                      //     '${(100 - (int.parse(currentprice) / int.parse(currentcprice) * 100)).toStringAsFixed(1)}%\nOFF',
                      //     style: TextStyle(color: Colors.white, fontSize: 10),
                      //   )),
                      // ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Column(
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: txttitle),
                                    children: [
                                      TextSpan(
                                        text: "₹$currentprice  ",
                                        style: TextStyle(
                                            color: primary, fontSize: 20.0),
                                      ),
                                      TextSpan(
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 16.0),
                                        text: "₹$currentcprice",
                                      ),
                                    ],
                                  ),
                                ),
                                // Text(
                                //   "${widget.data[widget.val].unit}",
                                //   style: TextStyle(fontSize: 18.0, color: txt2),
                                // ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            // DropdownButton<String>(
                            //     value: cvL1,
                            //     items: <String>[
                            //       'One',
                            //       'Two',
                            //       'Free',
                            //       'Four'
                            //     ].map<DropdownMenuItem<String>>((String value) {
                            //       return DropdownMenuItem<String>(
                            //         value: value,
                            //         child: Text(value),
                            //       );
                            //     }).toList(),
                            //     onChanged: (String val) {
                            //       setState(() {
                            //         this.cvL1 = val;
                            //         // currentprice = prices[units.indexOf(val)];
                            //         // print(units.indexOf(val));
                            //         // currentcprice = cprices[units.indexOf(val)];
                            //         // print(currentcprice);
                            //         // qtprice =
                            //         //     int.tryParse(currentprice) * value;
                            //       });
                            //     }),
                            DropdownButton<String>(
                                value: currentunit,
                                items: unitlist,
                                onChanged: (String val) {
                                  setState(() {
                                    this.currentunit = val;
                                    currentprice = prices[units.indexOf(val)];
                                    print(units.indexOf(val));
                                    currentcprice = cprices[units.indexOf(val)];
                                    print(currentcprice);
                                    qtprice =
                                        int.tryParse(currentprice) * value;
                                  });
                                }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: int.parse(widget.data[widget.val].qty) == 0
                            ? Text(
                                "Out of Stock",
                                style: TextStyle(color: danger, fontSize: 20.0),
                              )
                            : int.parse(widget.data[widget.val].qty) <= 2
                                ? Text(
                                    "${widget.data[widget.val].qty} Left In Stock",
                                    style: TextStyle(
                                        color: success1, fontSize: 20.0),
                                  )
                                : null,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Description",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          "${widget.data[widget.val].desc}",
                          style: TextStyle(fontSize: 16.0, color: txt1),
                        ),
                      ],
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      counterstate
                          ? Container(
                              child: Column(
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      "₹$qtprice",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17.0,
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
                                        width: 40.0,
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
                              onPressed: () {
                                print(
                                    "Product ID: ${widget.data[widget.val].id}");
                                addToCart();
                              },
                              child: Text("ADD TO CART"),
                              color: Color(0xffE1E1E1),
                              minWidth: 150.0,
                              height: 50.0,
                            ),
                      MaterialButton(
                        onPressed: () {
                          print("Product ID: ${widget.data[widget.val].id}");
                          addToCart();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => Cart(),
                          ));
                        },
                        child: Text("BUY NOW"),
                        color: primary,
                        minWidth: 150.0,
                        height: 50.0,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        if (opcode == true) {
                          setState(() {
                            opcode = false;
                          });
                        } else if (opcode == false) {
                          setState(() {
                            opcode = true;
                          });
                        }
                      },
                      child: Text(
                        "Comment",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17.0,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  opcode
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 15.0),
                          child: Form(
                            key: _formKey,
                            child: Theme(
                              data: ThemeData(
                                primaryColor: Colors.black,
                              ),
                              child: TextFormField(
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(100),
                                ],
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        addComment();
                                      }
                                    },
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black12, width: 1.0),
                                  ),
                                  helperMaxLines: null,
                                  filled: true,
                                  fillColor: Color.fromRGBO(245, 245, 245, 1),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 15.0),
                                ),
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                keyboardType: TextInputType.text,
                                controller: comment,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  isLoading2
                      ? LinearProgressIndicator()
                      : hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: cdata.length < 5 ? cdata.length : 5,
                              itemBuilder: (BuildContext context, int i) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: ListTile(
                                    leading: Image.network(
                                      cdata[i].img == null
                                          ? curl +
                                              'uploads/profile/default_user.png'
                                          : curl + cdata[i].img,
                                    ),
                                    title: Container(
                                      width: 150.0,
                                      child: Text(
                                        "${cdata[i].name}",
                                      ),
                                    ),
                                    subtitle: Container(
                                      width: 150.0,
                                      child: Text(
                                        "${cdata[i].comment}",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : Center(
                              child: Text(
                                "No Reviews Yet!",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 18.0),
                              ),
                            ),
                  hasData
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => AllComments(id: widget.id.toString(),)));
                            },
                            child: Text(
                              "See All",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
