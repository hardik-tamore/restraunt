import 'package:chandrhas/components/ListCard2.dart';

import '../business/Models/ProductModel.dart';
import '../theme/variables.dart';
import 'AppBar.dart';
import 'BottomNavigation.dart';
import 'ListCard.dart';
import 'package:flutter/material.dart';

class ProductsView extends StatefulWidget {
  final title;
  final List<ProductModel> data;
  ProductsView({this.title, this.data});
  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 50),
        child: AppliBar(
          title: "Products",
        ),
      ),
      body: SafeArea(
        child: widget.data == null
            ? Center(
                child: Container(
              child: Image(image: AssetImage("assets/restGIF.gif"),),
            ),
              )
            : Container(
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
                            "${widget.title}",
                            style:
                                TextStyle(color: Colors.black, fontSize: 24.0),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: widget.data.length,
                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //   crossAxisCount: 2,
                      //   crossAxisSpacing: 5.0,
                      //   mainAxisSpacing: 5.0,
                      //   childAspectRatio: MediaQuery.of(context).size.width/(500.0),
                      // ),
                      itemBuilder: (BuildContext context, int i) {
                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              print("Product Clicked!");
                            },
                            child: ListCard2(
                              img: "${widget.data[i].img}",
                              price: "${widget.data[i].price}",
                              c_price: "${widget.data[i].c_price}",
                              title: "${widget.data[i].title}",
                              unit: "${widget.data[i].unit}",
                              id: "${widget.data[i].id}",
                              data: widget.data,
                              val: i,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
