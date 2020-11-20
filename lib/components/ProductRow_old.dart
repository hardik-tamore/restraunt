import 'ProductView.dart';
import 'package:flutter/material.dart';
import 'ProductCard.dart';
import '../theme/variables.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../business/Models/ProductModel.dart';
import '../components/component.dart';

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
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${widget.title}",
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Text(
                    "See all",
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ProductsView(
                        title: "${widget.title}",
                        data: pdata,
                      ),
                    ));
                    print("See all clicked!");
                  },
                ),
              ),
            ],
          ),
          pdata == null
              ? Center(child: LinearProgressIndicator())
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 270,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: pdata.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProductCard(
                            img: "${curl + pdata[i].img}",
                            price: "${pdata[i].price}",
                            title: "${pdata[i].title}",
                            id: "${pdata[i].id}",
                            val: i,
                            data: pdata,
                          ),
                        );
                      }),
                ),
        ],
      ),
    );
  }
}
