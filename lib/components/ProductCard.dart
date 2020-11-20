import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chandrhas/theme/variables.dart';
import '../Product.dart';
import '../business/Models/ProductModel.dart';
import 'dart:convert';
import '../theme/variables.dart';

class ProductCard extends StatelessWidget {
  final String price;
  final String title;
  final String img;
  final String id;
  final String c_price;
  final List<ProductModel> data;
  final int val;
  ProductCard(
      {this.title,
      this.price,
      this.img,
      this.id,
      this.c_price,
      this.data,
      this.val});

  @override
  Widget build(BuildContext context) {
    List prices = json.decode(price);
    List c_prices = json.decode(c_price);
    List images = json.decode(this.img);
    print("ProductCard Image :${images}");
    return data == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GestureDetector(
            onTap: () {
              print("Product Tapped! & ID=$id");
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Product(
                    id: "$id",
                    data: data,
                    val: val,
                  ),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: 150,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.40),
                        blurRadius: 12.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          children: [
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.green[400],
                                  // border: Border.all(),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(10.0),
                                  )),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${(100 - (int.parse(prices[0]) / int.parse(c_prices[0]) * 100)).toStringAsFixed(0)}% off",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Image.network(
                        "${curl + images[0]}",
                        fit: BoxFit.contain,
                        height: 100,
                        width: 250,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 5.0),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                     "${title}".length<=8 ?"$title":"${title.substring(0,9)}...",
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "₹${prices[0]}.00",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                //  SizedBox(height:5),
                                Text(
                                  "₹${c_prices[0]}.00",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    color: Colors.red,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
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
