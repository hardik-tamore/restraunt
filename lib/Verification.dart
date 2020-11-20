import 'components/AppBar.dart';
import 'components/BottomNavigation.dart';
import 'components/RaisedGradientButton.dart';
import 'theme/myicons.dart';
import 'theme/variables.dart';
import 'package:flutter/material.dart';

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final _formKey = GlobalKey<FormState>();
  bool pass = true;
  TextEditingController _name = new TextEditingController();
  TextEditingController _shopname = new TextEditingController();
  TextEditingController _license = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  Color bg = danger;
  Color vborder = danger1;
  String statusmsg = "Verification Pending!";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(child: AppliBar(title: "Verification"), preferredSize: Size(MediaQuery.of(context).size.width,50)),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Verification Status", textAlign: TextAlign.center,),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              padding: EdgeInsets.symmetric(vertical: 15.0),
              decoration: BoxDecoration(
                border: Border.all(color: vborder, width: 2),
                borderRadius: BorderRadius.circular(10.0),
                color: bg,
              ),
              child: Center(
                child: Text("$statusmsg", style: TextStyle(color: Colors.white, fontSize: 16.0),),
              ),
            ),
            SizedBox(height: 50.0,),
            Theme(
              data: ThemeData(
                primaryColor: txt1,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Name",
                        ),
                        controller: _name,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Shop Name",
                        ),
                        controller: _shopname,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "License",
                        ),
                        controller: _license,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Address",
                        ),
                        controller: _address,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Upload License", style: TextStyle(color: txt1, fontSize: 16.0),),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Upload.pdf", style: TextStyle(color: txttitle, fontSize: 14.0),),
                              ),
                              
                            ],
                          ),
                          GestureDetector(
                            onTap: (){
                              print("Upload License!");
                            },
                            child: Container(
                              width: 40.0,
                              height: 29.0,
                              margin: EdgeInsets.only(right: 25.0),
                              decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Icon(MyFlutterApp.upload_cloud_outline, color: Colors.white, size: 20.0,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 25.0),
                      child: RaisedGradientButton(
                        height: 60.0,
                        child: Text("Update", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,),),
                        gradient: LinearGradient(colors: [primary, secondary]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}