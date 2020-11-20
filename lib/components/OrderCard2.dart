import 'package:flutter/material.dart';
import '../theme/variables.dart';
import 'dart:convert';


class OrderCard2 extends StatefulWidget {
  final title;
  final unit;
  final price;
  final qty;
  final img;
  OrderCard2({this.title,this.unit,this.price,this.qty,this.img});
  @override
  _OrderCard2State createState() => _OrderCard2State();
}

class _OrderCard2State extends State<OrderCard2> {

  List images;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images = json.decode(widget.img);
  }

  @override
  Widget build(BuildContext context) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                offset: Offset(0.0,1.5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      offset: Offset(0.0,1.5),
                    ),
                  ],
                  image: DecorationImage(image: NetworkImage("${curl+images[0]}"), fit: BoxFit.cover),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Container(
                      width: 150.0,
                      child: Text("${widget.title}", style: TextStyle(color: txttitle, fontSize: 16.0),),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text("${widget.unit}", style: TextStyle(color: txt2, fontSize: 16.0),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text("₹${widget.price}", style: TextStyle(color: primary, fontSize: 16.0),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text("Qty : ${widget.qty}", style: TextStyle(color: txttitle, fontSize: 16.0),),
                  ),
                ],
              ),
              // Container(
              //   width: 30.0,
              //   height: 120.0,
              //   decoration: BoxDecoration(
              //     // color: Colors.red,
              //   ),
              //   child: Stack(
              //     children: <Widget>[
              //       Positioned(
              //         top: 0.0,
              //         right: 0.0,
              //         child: GestureDetector(
              //           onTap: (){
              //             print("close cart item");
              //           },
              //           child: Icon(Icons.close, color: txt2,),
              //           ),
              //         ),
              //     ],
              //   ),
              //   ),
            ],
          ),
        );
  }
}