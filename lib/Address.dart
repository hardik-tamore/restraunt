import 'AddressAdd.dart';
import 'components/AppBar.dart';
import 'components/BottomNavigation.dart';
import 'package:flutter/material.dart';
import 'theme/variables.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'components/component.dart';
import 'Checkout.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  // List<GroupModel> data;
  Connect con = new Connect();
  Shared sh = new Shared();
  bool isLoading = true;
  bool hasData = false;
  String number, valid;

  int _currVal = 0;

  String _currText = '';

  List<GroupModel> _group = [
    GroupModel(
      text: "Flutter.dev",
      index: 1,
    ),
    GroupModel(
      text: "Inducesmile.com",
      index: 2,
    ),
    GroupModel(
      text: "Google.com",
      index: 3,
    ),
    GroupModel(
      text: "Yahoo.com",
      index: 4,
    ),
  ];

  void getAddress() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getAddress",
            body: {"number": this.number, "valid": this.valid});
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            this._group =
                data.map<GroupModel>(((i) => GroupModel.fromJson(i))).toList();
            hasData = true;
            isLoading = false;
          });
        } else if (jsonval["status"] == "failed") {
          setState(() {
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
    // TODO: implement initState
    super.initState();
    getPreferences();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          child: AppliBar(title: "Address"),
          preferredSize: Size(MediaQuery.of(context).size.width, 50.0)),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: Text(
                "Address",
                style: TextStyle(fontFamily: "Roboto-Slab",color: txttitle, fontSize: 24.0),
              ),
            ),
            isLoading
                ? Center(
                     child: Container(
              child: Image(image: AssetImage("assets/restGIF.gif"),),
            ),
                  )
                : hasData
                    ? Column(
                        children: <Widget>[
                          Column(
                            children: _group
                                .map((t) => RadioListTile(
                                      title: Text("${t.text}",style: TextStyle(fontFamily:"Roboto-Slab"),),
                                      groupValue: _currVal,
                                      value: t.index,
                                      onChanged: (val) {
                                        setState(() {
                                          print(val);
                                          _currVal = val;
                                          // _currText = t.text;
                                        });
                                      },
                                    ))
                                .toList(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: <Widget>[
                                MaterialButton(
                                  color: primary,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  onPressed: () {
                                    if (_currVal == 0) {
                                      CDialog cd =
                                          new CDialog(context: context);
                                      cd.dialogShow(
                                          "Alert!",
                                          "Please Select OR Add An Address.",
                                          "OK");
                                    } else {
                                      // Navigator.of(context).pop();
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop();
                                      }
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Checkout(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    "Proceed.",
                                    style: TextStyle(fontFamily: "Roboto-Slab",
                                        color: Colors.white, fontSize: 18.0),
                                  ),
                                ),
                                FlatButton(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AddressAdd()),
                                    );
                                  },
                                  child: Text(
                                    "Add New Address",
                                    style: TextStyle(fontFamily: "Roboto-Slab",
                                        color: txttitle, fontSize: 18.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddressAdd()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(25.0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 50.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: primary,
                                width: 1,
                                style: BorderStyle.solid),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                size: 35.0,
                                color: primary,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Add Address",
                                  style: TextStyle(fontFamily: "Roboto-Slab",color: txt2, fontSize: 21.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

class GroupModel {
  String text;
  int index;
  GroupModel({this.text, this.index});
  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      index: int.parse(json["index"]),
      text: json["text"],
    );
  }
}
