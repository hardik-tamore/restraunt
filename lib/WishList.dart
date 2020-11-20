import 'components/AppBar.dart';
import 'package:flutter/material.dart';
import 'components/ListCard.dart';
import 'components/BottomNavigation.dart';
import 'business/Models/ProductModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'components/component.dart';
import 'theme/variables.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  List<ProductModel> pdata;
  Connect con = new Connect();
  Shared sh = new Shared();
  bool isLoading = true;
  String number, valid;
  bool wishlist = false;

  void getWishList() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getWishList", body: {
          "number": this.number,
          "valid": this.valid,
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
            wishlist = true;
            isLoading = false;
          });
        } else if (jsonval["status"] == "failed") {
          setState(() {
            print("DATA : ${data}");
            wishlist = false;
            isLoading = false;
          });
        }
      } catch (e) {
        print("Error : ${e.message()}");
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
    // TODO: implement initState
    super.initState();
    setState(() {
      getPreferences();
      getWishList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 50),
        child: AppliBar(
          title: "WishList",
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
               child: Container(
              child: Image(image: AssetImage("assets/restGIF.gif"),),
            ),
              )
            : wishlist
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 8.0),
                              child: Text(
                                "Your Choices",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 24.0),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),

                          itemCount: pdata.length,
                          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //   crossAxisCount: 2,
                          //   crossAxisSpacing: 10.0,
                          //   mainAxisSpacing: 10.0,
                          //   childAspectRatio: MediaQuery.of(context).size.width/(500.0),
                          // ),
                          itemBuilder: (BuildContext context, int i) {
                            return Center(
                              child: GestureDetector(
                                onTap: () {
                                  print("Product Clicked!");
                                },
                                child: ListCard(
                                  img: "${pdata[i].img}",
                                  price: "${pdata[i].price}",
                                  title: "${pdata[i].title}",
                                  id: "${pdata[i].id}",
                                  unit: "${pdata[i].unit}",
                                  data: pdata,
                                  val: i,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      "No products in wishlist yet!",
                      style: TextStyle(color: txttitle, fontSize: 24.0),
                    ),
                  ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
