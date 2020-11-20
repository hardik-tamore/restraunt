import 'package:flutter/material.dart';
import 'business/Models/ProductModel.dart';
import 'components/ProductCard.dart';
import 'components/Slist.dart';
import 'components/ListCard2.dart';
import 'theme/variables.dart';
import 'dart:async';

class CustomSearchDelegate extends SearchDelegate {
  final List<ProductModel> product;
  var gval = 0;

  CustomSearchDelegate({this.product});

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // buildSuggestions(context);
    print(query);
    List<ProductModel> result;
    if (product != null) {
      result = product
          .where((a) =>
              a.title.toLowerCase().contains(query) ||
              a.desc.toLowerCase().contains(query) ||
              a.price.toLowerCase().contains(query))
          .toList();
      return result != null
          ? ListView.builder(
              itemCount: result.length,
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: 2,
              //   crossAxisSpacing: 5.0,
              //   mainAxisSpacing: 5.0,
              //   childAspectRatio: MediaQuery.of(context).size.width/(500.0),
              // ),
              itemBuilder: (BuildContext context, int i) {
                print(result[i].price);
                return result.length > 0
                    ? Center(
                        child: GestureDetector(
                          onTap: () {
                            print("Product Clicked!");
                          },
                          child: Slist(
                            img: "${result[i].img}",
                            price: "${result[i].price}",
                            title: "${result[i].title}",
                            id: "${result[i].id}",
                            unit: "${result[i].unit}",
                            desc: "${result[i].desc}",
                            data: result,
                            val: i,
                          ),
                        ),
                      )
                    : Center(
                        child: Text("No Data!"),
                      );
              },
            )
          : Center(
              child: Text("No Data!"),
            );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    print(query);
    List<ProductModel> result;
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) {
      print('hi!');
      // this.showResults(context);
      // this.showSuggestions(context);
      // afterBuild(context);
      // buildResults(context);
      // buildSuggestions(context);
      if (t.isActive) {
        t.cancel();
      }
    });
    if (product != null) {
      result = product
          .where((a) =>
              a.title.toLowerCase().contains(query) ||
              a.desc.toLowerCase().contains(query) ||
              a.price.toLowerCase().contains(query))
          .toList();
      return result != null
          ? ListView.builder(
              itemCount: result.length,
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: 2,
              //   crossAxisSpacing: 5.0,
              //   mainAxisSpacing: 5.0,
              //   childAspectRatio: MediaQuery.of(context).size.width/(500.0),
              // ),
              itemBuilder: (BuildContext context, int i) {
                print("Search :${result[i]}");
                return result.length > 0
                    ? Center(
                        child: GestureDetector(
                          onTap: () {
                            print("Product Clicked!");
                          },
                          child: Slist(
                            img: "${result[i].img}",
                            price: "${result[i].price}",
                            title: "${result[i].title}",
                            id: "${result[i].id}",
                            unit: "${result[i].unit}",
                            desc: "${result[i].desc}",
                            data: result,
                            val: i,
                          ),
                        ),
                      )
                    : Center(
                        child: Text("No Data!"),
                      );
              },
            )
          : Center(
              child: Text("No Data!"),
            );
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));

    // buildResults(context);
  }

  void afterBuild(context) {
    print("build end!");
    this.buildResults(context);
  }
}
