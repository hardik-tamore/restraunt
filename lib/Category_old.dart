import 'components/AppBar.dart';
import 'components/BottomNavigation.dart';
import 'components/ProductRow.dart';
import 'package:flutter/material.dart';
import 'components/component.dart';
import 'business/LoginStatus.dart';
import 'theme/variables.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'business/Models/SubCategories.dart';

class Category extends StatefulWidget {

  final id;
  final title;
  Category(this.id,this.title);
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  List<SubCategories> cdata;
  LoginStatus ls = new LoginStatus();
  Connect con = new Connect();
  Shared sh = new Shared();
  bool isLoading = true;
  String number,valid;

  void getSubCategories() async{
  if(await con.check() == true){
    try{
      final response = await http.post("${curl}Api/getSubCategories",
      body: {
        "number": this.number,
        "valid": this.valid,
        "id": widget.id
      });
      var jsonval = json.decode(response.body);
      print("Response : ${jsonval}");
      var data = jsonval["result"];
      if(jsonval["status"] == "success"){
        setState(() {
          print("DATA : ${data}");
            cdata = data.map<SubCategories>(((i) =>
                SubCategories.fromJson(i)
              )).toList();
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

  void lgState() async{
    var status = await ls.loginState();
    if(!status){
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed("/login");
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    lgState();
    setState(() {
      getPreferences();
      getSubCategories();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(child: AppliBar(title: "${widget.title}"), preferredSize: Size(MediaQuery.of(context).size.width,50)),
      body: SafeArea(
        child: isLoading ? Center(child: CircularProgressIndicator(),) : ListView(
          children: cdata.map((i)=>ProductRow(title: "${i.name}",id: "${i.id}",)).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}