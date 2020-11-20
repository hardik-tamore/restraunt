import 'package:flutter/material.dart';
import 'components/AppBar.dart';
import 'components/NotificationCard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'components/component.dart';
import 'theme/variables.dart';



class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  Connect con = new Connect();
  Shared sh = new Shared();
  bool isLoading = true;
  bool hasData = false;
  List<Noti> ndata;
  
  String number,valid;

  void getNotification() async{
    if(await con.check() == true){
      try{
        final response = await http.post("${curl}Notification/notifications",);
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if(jsonval["status"] == "success"){
          setState(() {
            print("DATA : ${data}");
            this.ndata = data.map<Noti>(((i) =>
                Noti.fromJson(i)
              )).toList();
            isLoading = false;
            hasData = true;
          });
        }else if(jsonval["status"] == "failed"){
          setState((){
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
    getNotification();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(child: AppliBar(title: "Notifications",), preferredSize: Size(MediaQuery.of(context).size.width, 50),),
      body: SafeArea(
        child: isLoading ? Center(child: Container(
              child: Image(image: AssetImage("assets/restGIF.gif"),),
            ),) : hasData ? ListView(
          children: ndata.map((i)=>NotificationCard(title: i.title,body: i.body,)).toList(),
        ) : Center(child: Text("No Notifications Yet!",style: TextStyle(fontSize: 16,color: txttitle),),),
      ),
    );
  }
}

class Noti {
  final title;
  final body;

  Noti({this.title,this.body});

  factory Noti.fromJson(Map<String, dynamic> json){
    return Noti(
      title: json["title"],
      body: json["body"]
    );
  }
}