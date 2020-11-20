import 'package:chandrhas/components/ListCard.dart';

import '../components/ListCard2.dart';
import 'ProductView.dart';
import 'package:flutter/material.dart';
import 'ProductCard.dart';
import '../theme/variables.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../business/Models/ProductModel.dart';
import 'component.dart';

class ProductRow extends StatefulWidget {
  final title;
  final id;
  ProductRow({this.title, this.id});

  @override
  _ProductRowState createState() => _ProductRowState();
}

class _ProductRowState extends State<ProductRow> {
  List<ProductModel> pdata;
  Connect con = new Connect();
  Shared sh = new Shared();
  bool isLoading = true;
  String number, valid;

  void getProducts() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getProducts", body: {
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
            pdata = data
                .map<ProductModel>(((i) => ProductModel.fromJson(i)))
                .toList();
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

  getPreferences() async {
    this.number = await sh.getShared("number");
    this.valid = await sh.getShared("id");
    print("Number : ${this.number}");
    print("Validation ID : ${this.valid}");
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getPreferences();
      getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // return ListView.builder(
    //     scrollDirection: Axis.vertical,
    //     itemCount: pdata.length,
    //     itemBuilder: (BuildContext context, int i) {
    //       return Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: ListCard(
    //           img: "${curl + pdata[i].img}",
    //           price: "${pdata[i].price}",
    //           title: "${pdata[i].title}",
    //           id: "${pdata[i].id}",
    //           val: i,
    //           data: pdata,
    //         ),
    //       );
    //     });
    return isLoading
        ? Center(
            child:  Container(
              child: Image(image: AssetImage("assets/restGIF.gif"),),
            ),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: pdata.length,
            itemBuilder: (BuildContext context, int i) {
              return Center(
                //child: Container(child: Text('abcd'),),
                child: 
                GestureDetector(
                  onTap: () {
                    print("Product Clicked!");
                  },
                  child: ListCard2(
                    img: "${pdata[i].img}",
                    price: "${pdata[i].price}",
                    c_price: "${pdata[i].c_price}",
                    title: "${pdata[i].title}",
                    id: "${pdata[i].id}",
                    unit: "${pdata[i].unit}",
                    data: pdata,
                    val: i,
                  ),
                ),
              );
              ;
            });
  }
}
