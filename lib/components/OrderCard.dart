import '../Order.dart';
import 'package:flutter/material.dart';
import '../theme/variables.dart';

class OrderCard extends StatefulWidget {
  final id;
  final orderid;
  final items;
  final status;
  final date;
  OrderCard({this.id,this.orderid, this.items, this.status, this.date});
  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  
  String status;
  Color bg = Colors.black12;
  Color border = Colors.black;
  @override
  void initState() {
    super.initState();
    if(widget.status == "P"){
      setState(() {
        status = "Pending..";
        bg = danger;
        border = danger1;
      });
    }else if(widget.status == "A"){
      setState(() {
        status = "Aproved";
        bg = success1;
        border = Colors.green;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
              margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("OrderID", style: TextStyle(color: txttitle, fontSize: 16.0, fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("#${widget.orderid}", style: TextStyle(color: txttitle, fontSize: 16.0,),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0,),
                          width: 90.0,
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Items", style: TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.bold),),
                              SizedBox(width: 5.0,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text("${widget.items}", style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Status", style: TextStyle(color: txttitle, fontSize: 16.0, fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 6.0,),
                            width: 110.0,
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(color: border, width: 1),
                            ),
                            child: Center(child: Text("$status", style: TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.bold),)),
                          ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Date", style: TextStyle(color: txttitle, fontSize: 16.0, fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("${widget.date}", style: TextStyle(color: txttitle, fontSize: 16.0,),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: (){
                            print("View Order");
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Order(id: "${widget.id}", status: status,),
                            ));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5.0,),
                            width: 90.0,
                            decoration: BoxDecoration(
                              color: success1,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(child: Text("View", style: TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.bold),)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
  }
}