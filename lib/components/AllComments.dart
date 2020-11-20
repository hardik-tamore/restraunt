import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:chandrhas/business/Models/CommentModel.dart';
import 'package:chandrhas/theme/variables.dart';

import 'AppBar.dart';
import 'BottomNavigation.dart';
import 'component.dart';
import 'package:http/http.dart' as http;


class AllComments extends StatefulWidget {
    final id;
    AllComments({this.id});

  @override
  _AllCommentsState createState() => _AllCommentsState();
}

class _AllCommentsState extends State<AllComments> {
  Connect con = new Connect();
  Shared sh = new Shared();
  bool isLoading2 = false;
  bool hasData = false;
  String number, valid;
  List<CommentModel> cdata;

    void getComments() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Comment/get", body: {
          "number": this.number,
          "valid": this.valid,
          "pid": widget.id.toString(),
        });
        var jsonval = json.decode(response.body);
        print("Comments Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            this.cdata = data
                .map<CommentModel>(((i) => CommentModel.fromJson(i)))
                .toList();
            hasData = true;
            isLoading2 = false;
          });
        } else if (jsonval["status"] == "failed") {
          setState(() {
            hasData = false;
            isLoading2 = false;
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
    setState(() {
    getComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppliBar(title: "All Comments"),
          preferredSize: Size(MediaQuery.of(context).size.width, 50)),
          body: SafeArea(
            child:Scaffold(
          backgroundColor: Colors.white,
          body:isLoading2
                      ? Center(
              child: Container(
                child: Image(image: AssetImage("assets/restGIF.gif"),),
              ),
            )
                      : hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: cdata.length,
                              itemBuilder: (BuildContext context, int i) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: ListTile(
                                    leading: Image.network(
                                      cdata[i].img == null
                                          ? curl +
                                              'uploads/profile/default_user.png'
                                          : curl + cdata[i].img,
                                    ),
                                    title: Container(
                                      width: 150.0,
                                      child: Text(
                                        "${cdata[i].name}",
                                      ),
                                    ),
                                    subtitle: Container(
                                      width: 150.0,
                                      child: Text(
                                        "${cdata[i].comment}",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : Center(
                              child: Text(
                                "No Reviews Yet!",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 18.0),
                              ),
                            )
                             
        )
          ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}