import 'package:flutter/material.dart';
import '../theme/variables.dart';
import '../business/Models/ProductModel.dart';
import '../Product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../components/component.dart';

class Slist extends StatefulWidget {
  final title;
  final unit;
  final price;
  final desc;
  final qty;
  final img;
  final id;
  final Function fn;
  final List<ProductModel> data;
  final int val;
  Slist(
      {this.title,
      this.price,
      this.qty,
      this.unit,
      this.desc,
      this.img,
      this.id,
      this.fn,
      this.data,
      this.val});
  @override
  _SlistState createState() => _SlistState();
}

class _SlistState extends State<Slist> {
  List images;
  @override
  Widget build(BuildContext context) {
    List unit = json.decode(widget.unit);
     images = json.decode(widget.img);
    // List price = json.decode(widget.price);
    print(unit[0]);
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
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: primary, width: 2.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              offset: Offset(0.0, 1.5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 50.0,
              height: 50.0,
              // margin: EdgeInsets.all(5.0),
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
                  padding: const EdgeInsets.only(left: 5.0, bottom: 10.0),
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
                  padding: const EdgeInsets.only(
                    left: 5.0,
                  ),
                  child: Text(
                    "${(widget.desc).substring(0, widget.desc.length > 25 ? 25 : widget.desc.length)}",
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
