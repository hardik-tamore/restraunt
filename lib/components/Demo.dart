// import 'components/OrderCard2.dart';

// import 'Confirm.dart';
// import 'components/AppBar.dart';
// import 'components/BottomNavigation.dart';
// import 'components/RaisedGradientButton.dart';
// import 'theme/variables.dart';
// import 'package:flutter/material.dart';
// import 'business/Models/ProductModel.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'components/component.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/services.dart';

// class Checkout extends StatefulWidget {
//   @override
//   _CheckoutState createState() => _CheckoutState();
// }

// class _CheckoutState extends State<Checkout> {
//   List<ProductModel> pdata;
//   Connect con = new Connect();
//   Shared sh = new Shared();
//   bool isLoading = true;
//   bool hasData = false;
//   String number, valid, total, delivery;
//   num amt;
//   Razorpay _razorpay;
//   TextEditingController _remark = new TextEditingController();

//   void getCheckOut() async {
//     if (await con.check() == true) {
//       try {
//         final response = await http.post("${curl}Api/getCheckOut",
//             body: {"number": this.number, "valid": this.valid});
//         var jsonval = json.decode(response.body);
//         print("Response : ${jsonval}");
//         var data = jsonval["result"];
//         if (jsonval["status"] == "success") {
//           setState(() {
//             print("DATA : ${data}");
//             this.pdata = data
//                 .map<ProductModel>(((i) => ProductModel.fromJson(i)))
//                 .toList();
//             hasData = true;
//             isLoading = false;
//           });
//         } else if (jsonval["status"] == "failed") {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       } catch (e) {
//         print("Error : ${e.message()}");
//         CDialog cd = new CDialog(context: context);
//         cd.dialogShow("Error", "Some error occured while loading.", "OK");
//       }
//     } else if (await con.check() == false) {
//       CDialog cd = new CDialog(context: context);
//       cd.dialogShow("Error", "No Internet Connection", "OK");
//     }
//   }

//   void getCartTotal() async {
//     if (await con.check() == true) {
//       try {
//         final response = await http.post("${curl}Api/getCartTotal",
//             body: {"number": this.number, "valid": this.valid});
//         var jsonval = json.decode(response.body);
//         print("Response : ${jsonval}");
//         var data = jsonval["result"];
//         if (jsonval["status"] == "success") {
//           setState(() {
//             print("DATA : ${data}");
//             this.total = data[0]["total"];
//           });
//         }
//       } catch (e) {
//         print("Error : ${e.message()}");
//         CDialog cd = new CDialog(context: context);
//         cd.dialogShow("Error", "Some error occured while loading.", "OK");
//       }
//     } else if (await con.check() == false) {
//       CDialog cd = new CDialog(context: context);
//       cd.dialogShow("Error", "No Internet Connection", "OK");
//     }
//   }

//   void placeOrder(paymentid) async {
//     if (await con.check() == true) {
//       try {
//         final response = await http.post("${curl}Api/placeOrder", body: {
//           "number": this.number,
//           "valid": this.valid,
//           "total": "${this.total.toString()}",
//           "payment_id": "$paymentid",
//           "delivery": "$delivery",
//           "remark": _remark.text,
//         });
//         var jsonval = json.decode(response.body);
//         print("Response : ${jsonval}");
//         var data = jsonval["result"];
//         if (jsonval["status"] == "success") {
//           setState(() {
//             print("DATA : ${data}");
//             Navigator.of(context).pushReplacement(MaterialPageRoute(
//               builder: (BuildContext context) => Confirm(),
//             ));
//           });
//         } else if (jsonval["status"] == "failed") {
//           CDialog cd = new CDialog(context: context);
//           cd.dialogShow(
//               "Error", "Some error occured while placing the order.", "OK");
//         }
//       } catch (e) {
//         print("Error : ${e.message()}");
//         CDialog cd = new CDialog(context: context);
//         cd.dialogShow("Error", "Some error occured while loading.", "OK");
//       }
//     } else if (await con.check() == false) {
//       CDialog cd = new CDialog(context: context);
//       cd.dialogShow("Error", "No Internet Connection", "OK");
//     }
//   }

//   getPreferences() async {
//     this.number = await sh.getShared("number");
//     this.valid = await sh.getShared("id");
//     print("Number : ${this.number}");
//     print("Validation ID : ${this.valid}");
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getPreferences();
//     getCheckOut();
//     getCartTotal();
//     // _razorpay = Razorpay();
//     // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   // @override
//   // void dispose() {
//   //   // TODO: implement dispose
//   //   super.dispose();
//   //   _razorpay.clear();
//   // }

//   // void openCheckout() async {
//   //   var options = {
//   //     'key': 'rzp_test_CHXCAMyRqY8OvJ',
//   //     'amount': amt*100,
//   //     'name': 'Vivlin-Mart',
//   //     'description': 'New Order',
//   //     'prefill': {'contact': '$number'},
//   //     'external': {
//   //       'wallets': ['paytm']
//   //     }
//   //   };

//   //   try {
//   //     _razorpay.open(options);
//   //   } catch (e) {
//   //     debugPrint(e);
//   //   }
//   // }

//   // void _handlePaymentSuccess(PaymentSuccessResponse response) {
//   //   Fluttertoast.showToast(
//   //       msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4,);
//   //   placeOrder(response.paymentId);

//   // }

//   // void _handlePaymentError(PaymentFailureResponse response) {
//   //   Fluttertoast.showToast(
//   //       msg: "ERROR: " + response.code.toString() + " - " + response.message,
//   //       timeInSecForIosWeb: 4);
//   // }

//   // void _handleExternalWallet(ExternalWalletResponse response) {
//   //   Fluttertoast.showToast(
//   //       msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           child: AppliBar(title: "Checkout"),
//           preferredSize: Size(MediaQuery.of(context).size.width, 50)),
//       body: SafeArea(
//         child: (isLoading == true || this.total.isEmpty)
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : hasData
//                 ? ListView(
//                     scrollDirection: Axis.vertical,
//                     children: <Widget>[
//                       Container(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Column(
//                               children: pdata
//                                   .map((i) => OrderCard2(
//                                         title: i.title,
//                                         qty: i.qty,
//                                         unit: i.unit,
//                                         price: i.price,
//                                         img: i.img,
//                                       ))
//                                   .toList(),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 50.0, left: 15.0, right: 15.0),
//                               child: Column(
//                                 children: <Widget>[
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: <Widget>[
//                                       Text(
//                                         "Subtotal",
//                                         style: TextStyle(
//                                             color: txt1, fontSize: 17.0),
//                                       ),
//                                       Text(
//                                         "₹${this.total}",
//                                         style: TextStyle(
//                                             color: txttitle, fontSize: 17.0),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: <Widget>[
//                                       Text(
//                                         "Shipping",
//                                         style: TextStyle(
//                                             color: txt1, fontSize: 17.0),
//                                       ),
//                                       (int.parse(this.total) < 0)
//                                           ? Text(
//                                               "₹50",
//                                               style: TextStyle(
//                                                   color: txttitle,
//                                                   fontSize: 17.0),
//                                             )
//                                           : Text(
//                                               "Free Shipping!",
//                                               style: TextStyle(
//                                                   color: success1,
//                                                   fontSize: 17.0),
//                                             ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 15.0, vertical: 20.0),
//                               child: Divider(
//                                 color: Color(0xffD8D8D8),
//                                 thickness: 1,
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 15.0,
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Text(
//                                     "Total",
//                                     style: TextStyle(
//                                         color: txttitle, fontSize: 17.0),
//                                   ),
//                                   int.parse(this.total) >= 0
//                                       ? Text(
//                                           "₹${this.total}",
//                                           style: TextStyle(
//                                               color: txttitle, fontSize: 17.0),
//                                         )
//                                       : Text(
//                                           "₹${int.parse(this.total) + 50}",
//                                           style: TextStyle(
//                                               color: txttitle, fontSize: 17.0),
//                                         ),
//                                 ],
//                               ),
//                             ),
//                             // Padding(
//                             //   padding: const EdgeInsets.symmetric(
//                             //       horizontal: 45.0, vertical: 10.0),
//                             //   child: TextFormField(
//                             //     inputFormatters: [
//                             //       new LengthLimitingTextInputFormatter(100),
//                             //     ],
//                             //     decoration: InputDecoration(
//                             //       labelText: "Remarks",
//                             //       contentPadding: EdgeInsets.symmetric(
//                             //         vertical: 10.0,
//                             //       ),
//                             //       hintMaxLines: 5,
//                             //     ),
//                             //     controller: _remark,
//                             //   ),
//                             // ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 15.0, vertical: 45.0),
//                               child: RaisedGradientButton(
//                                 gradient: LinearGradient(
//                                     colors: [primary, secondary]),
//                                 child: Text(
//                                   "Buy",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 20.0,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 height: 60,
//                                 onPressed: () {
//                                   print("Confirm Order!");

//                                   setState(() {
//                                     int.parse(this.total) < 0
//                                         ? delivery = "1"
//                                         : delivery = "0";
//                                     amt = num.parse(total);
//                                   });
//                                   // openCheckout();
//                                   placeOrder("f23fjdf3rdlfFJjfljf");
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   )
//                 : Center(
//                     child: Text(
//                       "No Products!",
//                       style: TextStyle(color: txttitle, fontSize: 20.0),
//                     ),
//                   ),
//       ),
//       bottomNavigationBar: BottomNavigation(),
//     );
//   }
// }
