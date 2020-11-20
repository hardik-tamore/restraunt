import 'components/OrderCard2.dart';

import 'Confirm.dart';
import 'components/AppBar.dart';
import 'components/BottomNavigation.dart';
import 'components/RaisedGradientButton.dart';
import 'theme/variables.dart';
import 'package:flutter/material.dart';
import 'business/Models/ProductModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'components/component.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  List<ProductModel> pdata;
  Connect con = new Connect();
  Shared sh = new Shared();
  bool isLoading = true;
  bool hasData = false;
  String number, valid, total, delivery,discount,tamount;
  num amt;
  int famt;
  int d_amnt;
  int t_amnt;
  double cartamtval;
  String promoid;
  bool subscription = false;
  bool pcode = false;
  bool opcode = false;
  bool fstate = false;
  bool status_state = false;
  String paymentmode;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _pcode = new TextEditingController();

  Razorpay _razorpay;
  TextEditingController _remark = new TextEditingController();

  void getCheckOut() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getCheckOut",
            body: {"number": this.number, "valid": this.valid});
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
        print("Error : ${e.message}");
        CDialog cd = new CDialog(context: context);
        cd.dialogShow("Error", "Some error occured while loading.", "OK");
      }
    } else if (await con.check() == false) {
      CDialog cd = new CDialog(context: context);
      cd.dialogShow("Error", "No Internet Connection", "OK");
    }
  }

  Future<bool> getCartTotal() async {
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
            this.total = data[0]["total"];
            cartamtval = double.tryParse(this.total);
            return true;
          });
        } else {
          return false;
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

//****** */ 
  Future<bool> getStoreStatus() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getStoreStatus", );
        
        print("Response : ${response.body}");
        // var data = jsonval["result"];
        var state = response.body;
        if(state == "on"){
          status_state = true;
        }else if(state == "off"){
          status_state = false; 
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

//****** */ 


  void placeOrder(paymentid) async {
    if (await con.check() == true) {
      if(cartamtval >= 100){
        try {
          final response = await http.post("${curl}Api/placeOrder", body: {
            "number": this.number,
            "valid": this.valid,
            "payment_mode":paymentmode,
            "total": "${this.total.toString()}",
            "payment_id": "$paymentid",
            "delivery": "$delivery",
            "remark": _remark.text,
          });
          var jsonval = json.decode(response.body);
          print("Response : ${jsonval}");
          var data = jsonval["result"];
          if (jsonval["status"] == "success") {
            setState(() {
              print("DATA : ${data}");
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => Confirm(),
              ));
            });
          } else if (jsonval["status"] == "failed") {
            CDialog cd = new CDialog(context: context);
            cd.dialogShow(
                "Error", "Some error occured while placing the order.", "OK");
          }
        } catch (e) {
          print("Error : ${e.message}");
          CDialog cd = new CDialog(context: context);
          cd.dialogShow("Error", "Some error occured while loading.", "OK");
        }
      }else{
          CDialog cd = new CDialog(context: context);
          cd.dialogShow("Error", "Please place an order with cart value more than ₹100.", "OK");
      }
    } else if (await con.check() == false) {
      CDialog cd = new CDialog(context: context);
      cd.dialogShow("Error", "No Internet Connection", "OK");
    }
  }
// online payment and cod
 showAlertDialog(BuildContext context) {
        // set up the buttons
        Widget cancelButton = FlatButton(
          child: Text("Online Payment".toUpperCase() ,style: TextStyle(color:primary,fontSize: 16),textAlign: TextAlign.start,),
          onPressed:  () {
                print("Confirm Order!");

                setState(() {
                  double.parse(this.total) < 0
                      ? delivery = "1"
                      : delivery = "0";
                  amt = num.parse(total);
                  paymentmode = "Online Payment";
                });
                openCheckout();
          },
        );
        Widget continueButton = FlatButton(
          child: Text("Cash on delivery".toUpperCase(),style: TextStyle(color:Colors.black,fontSize: 16),),
          onPressed:  () {
              print("Confirm Order!");

              setState(() {
                double.parse(this.total) < 0
                    ? delivery = "1"
                    : delivery = "0";
                amt = num.parse(total);
                 paymentmode = "Cash On Delivery";
              });
                if (!fstate) {
                placeOrder("f23fjdf3rdlfFJjfljf");
              }
          },
        );
        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: Center(child: Text("Select Payment Mode".toUpperCase())),
          content: Text(""),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
// online payment and cod
 showAlertDialog1(BuildContext context) {
        // set up the buttons
        Widget cancelButton = FlatButton(
          child: Text("OK".toUpperCase() ,style: TextStyle(color:primary,fontSize: 16),textAlign: TextAlign.start,),
          onPressed:  () {
            Navigator.of(context).pop();  
          },
        );

        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: Center(child: Text("Sorry, Currently We are Not Taking any Orders".toUpperCase())),
          content: Text(""),
          actions: [
            cancelButton,
          ],
        );
        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }

  Future<bool> checkCode(c) async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/checkCode",
            body: {"number": this.number, "valid": this.valid, "pcode": c});
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (!data.isEmpty) {
          print("Data : ${data[0]["damount"]}");
        }

        if (jsonval["status"] == "success") {
          getCartTotal().then((val) {
            setState(() {
              promoid = data[0]["id"];
              pcode = true;
              var tamnt= double.tryParse(this.total);
             var damnt=num.tryParse(data[0]["damount"]);
              var tval = (( tamnt- damnt ));
              famt = tval.toInt();
              t_amnt= tamnt.toInt();
              d_amnt= damnt.toInt();
              this.tamount = t_amnt.toString();
              this.discount = d_amnt.toString();
              this.total = famt.toString();
              print(this.total);
              _formKey.currentState.validate();
            });
          });
           opcode =false;
        } else if (jsonval["status"] == "failed") {
          setState(() {
            pcode = false;
            getCartTotal();
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
    return true;
  }

  bool validcode() {
    if (pcode) {
      return true;
    } else {
      // getCartTotal();
      return false;
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
    this.total="0";
    // TODO: implement initState
    super.initState();
    getStoreStatus();
    getPreferences();
    getCheckOut();
    getCartTotal();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      // 'key': 'rzp_test_5ZPC3YmhrJBSLP',  //testMode
      'key' : 'rzp_live_k8VlPcTwTefD18', //liveMode
      'amount': amt*100,
      'name': 'Vivlin-mart',
      'description': 'New Order',
      'prefill': {'contact': '$number'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4,);
    placeOrder(response.paymentId);

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          child: AppliBar(title: "Checkout"),
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
                            Column(
                              children: pdata
                                  .map((i) => OrderCard2(
                                        title: i.title,
                                        qty: i.qty,
                                        unit: i.unit,
                                        price: i.price,
                                        img: i.img,
                                      ))
                                  .toList(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 50.0, left: 15.0, right: 15.0),
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      validcode()==true?
                                    Text(
                                          "${_pcode.text} ",
                                          style: TextStyle(
                                            color: primary,
                                            fontSize: 17.0,
                                          ),
                                        )
                                     :FlatButton(
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
                                          "+ Apply Promo Code",
                                          style: TextStyle(
                                            color: primary,
                                            fontSize: 17.0,
                                          ),
                                        ), ),
                                      opcode
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 25.0),
                                              child: Form(
                                                key: _formKey,
                                                child: TextFormField(
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter a valid promo code.';
                                                    } else if (validcode() ==
                                                        false) {
                                                      return "The promo code is not valid!";
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                      border:
                                                          UnderlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                      suffix: MaterialButton(
                                                        color: Colors.white,
                                                        child: Text(
                                                          "Apply",
                                                          style: TextStyle(
                                                            fontSize: 18.0,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          fstate = true;
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      0), () {
                                                            checkCode(
                                                                    _pcode.text)
                                                                .then((value) =>
                                                                    {
                                                                      if (_formKey
                                                                          .currentState
                                                                          .validate())
                                                                        {}
                                                                    });

                                                            fstate = false;
                                                         
                                                          });
                                                            
                                                        },
                                                        
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2.0,
                                                              horizontal: 15.0),
                                                      filled: true,
                                                      fillColor: Color.fromRGBO(
                                                          224, 224, 224, 0.5)
                                                          ),
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  controller: _pcode,
                                                  onChanged: (val) {
                                                    // fstate = true;
                                                    // Future.delayed(
                                                    //     const Duration(
                                                    //         milliseconds: 500),
                                                    //     () {
                                                    //   checkCode(val).then(
                                                    //       (value) => {
                                                    //             if (_formKey
                                                    //                 .currentState
                                                    //                 .validate())
                                                    //               {}
                                                    //           });

                                                    //   fstate = false;
                                                    // });
                                                  },
                                                  
                                                ),
                                                
                                              ),
                                              
                                            )
                                          : Container(),
                                    ],
                                  ),
                                 validcode()==true ? 
                                  Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Subtotal",
                                              style: TextStyle(
                                                  color: txt1, fontSize: 17.0),
                                            ),
                                            Text(
                                              "₹${this.tamount}",
                                              style: TextStyle(
                                                  color: txttitle, fontSize: 17.0),
                                            ),
                                          ],
                                        ),
                              
                                        Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Total discount",
                                            style: TextStyle(
                                                color: txt1, fontSize: 17.0),
                                          ),
                                          Text(
                                            "₹${this.discount}",
                                            style: TextStyle(
                                                color: txttitle, fontSize: 17.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ) :  
                                 
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Shipping",
                                        style: TextStyle(
                                            color: txt1, fontSize: 17.0),
                                      ),
                                      (double.parse(this.total) < 0)
                                          ? Text(
                                              "₹50",
                                              style: TextStyle(
                                                  color: txttitle,
                                                  fontSize: 17.0),
                                            )
                                          : Text(
                                              "Free Shipping!",
                                              style: TextStyle(
                                                  color: success1,
                                                  fontSize: 17.0),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Total",
                                    style: TextStyle(
                                        color: txttitle, fontSize: 17.0),
                                  ),
                                  double.parse(this.total) >= 0
                                      ? Text(
                                          "₹${this.total}",
                                          style: TextStyle(
                                              color: txttitle, fontSize: 17.0),
                                        )
                                      : Text(
                                          "₹${double.parse(this.total) + 50}",
                                          style: TextStyle(
                                              color: txttitle, fontSize: 17.0),
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 10.0),
                              child: TextFormField(
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(100),
                                ],
                                decoration: InputDecoration(
                                  labelText: "Remarks",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 8.0,
                                  ),
                                  // hintMaxLines: 5,
                                  helperMaxLines: null,
                                ),
                                controller: _remark,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 45.0),
                              child: RaisedGradientButton(
                                gradient: LinearGradient(
                                    colors: [primary, secondary]),
                                child: Text(
                                  "Buy",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                height: 60,
                                onPressed: () {
                                  status_state?
                                  showAlertDialog(context) : showAlertDialog1(context);
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
                      "No Products!",
                      style: TextStyle(color: txttitle, fontSize: 20.0),
                    ),
                  ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
