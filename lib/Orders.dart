import 'components/AppBar.dart';
import 'components/BottomNavigation.dart';
import 'components/OrderCard.dart';
import 'package:flutter/material.dart';
import 'theme/variables.dart';
import 'business/Models/OrderModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'components/component.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  List<OrderModel> pdata;
  Connect con = new Connect();
  Shared sh = new Shared();
  bool isLoading = true;
  bool hasData = false;
  String number,valid;

  void getOrders() async{
  if(await con.check() == true){
    try{
      final response = await http.post("${curl}Api/getOrders",
      body: {
        "number": this.number,
        "valid": this.valid
      });
      var jsonval = json.decode(response.body);
      print("Response : ${jsonval}");
      var data = jsonval["result"];
      if(jsonval["status"] == "success"){
        setState(() {
          print("DATA : ${data}");
            this.pdata = data.map<OrderModel>(((i) =>
                OrderModel.fromJson(i)
              )).toList();
              hasData = true;
          isLoading = false;
        });
      }else if(jsonval["status"] == "failed"){
        setState(() {
          isLoading = false;
        });
      }
    }catch(e){
          print("Error : ${e.message()}");
          CDialog cd = new CDialog(context: context);
          cd.dialogShow("Error", "Some error occured while loading.", "OK");

    }
  }else if(await con.check() == false){
      CDialog cd = new CDialog(context: context);
      cd.dialogShow("Error", "No Internet Connection", "OK");
  }
}

getPreferences() async{
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
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(child: AppliBar(title: "My Orders"), preferredSize: Size(MediaQuery.of(context).size.width,50.0)),
      body: SafeArea(
        child: isLoading ? Center(child:Container(
              child: Image(image: AssetImage("assets/restGIF.gif"),),
            ),) : hasData ? ListView(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: Text("My Orders", style: TextStyle(color: txttitle, fontSize: 24.0),),
                  ),
                  Column(
                    children: pdata.map((i)=>OrderCard(id: i.id,orderid: i.order_id,items: i.items,status: i.status,date: i.date,)).toList(),
                  ),
                ],
              ),
            ),
          ],
        ): Center(child: Text("No Orders Placed Yet!",style: TextStyle(fontSize: 16.0,color: txttitle),),),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}