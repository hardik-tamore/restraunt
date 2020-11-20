import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../components/component.dart';
import '../theme/variables.dart';

class Counter extends StatefulWidget {
  final value;
  final id;
  final Function minus;
  final Function add;
  Counter({this.value, this.id, this.add, this.minus});
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int value;
  Connect con = new Connect();
  Shared sh = new Shared();
  String number, valid;

  void counterfn(id, action) async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/counter", body: {
          "number": this.number,
          "valid": this.valid,
          "id": id.toString(),
          "action": action,
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            print("Quantity updated successfully.");
            if (action == "add") {
              this.value++;
            } else if (action == "minus") {
              this.value--;
            }
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
    this.value = int.parse(widget.value);
    getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Color(0xffF6F6F6),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            highlightColor: Colors.transparent,
            icon: Icon(Icons.remove),
            onPressed: () {
              setState(() {
                if (value != 0 && value > 1) {
                  counterfn("${widget.id}", "minus");
                }
              });
            },
          ),
          Text(
            this.value.toString(),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                counterfn("${widget.id}", "add");
              });
            },
          ),
        ],
      ),
    );
  }
}
