import 'Cart.dart';
import 'components/AppBar.dart';
import 'components/BottomNavigation.dart';
import 'theme/variables.dart';
import 'package:flutter/material.dart';
import 'components/RaisedGradientButton.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'components/component.dart';
import 'business/Models/Customer.dart';


class AddressAdd extends StatefulWidget {
  @override
  _AddressAddState createState() => _AddressAddState();
}

class _AddressAddState extends State<AddressAdd> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  TextEditingController _pincode = new TextEditingController();

  TextEditingController _email = new TextEditingController();

  List<Customer> customer;
  Connect con = new Connect();
  Shared sh = new Shared();
  String number,valid;

  void addAddress() async{
  if(await con.check() == true){
    try{
      final response = await http.post("${curl}Api/addAddress",
      body: {
        "number": this.number,
        "valid": this.valid,
        "name":_name.text,
        "email":_email.text,
        "address":_address.text,
        "pincode":_pincode.text,
      });
      var jsonval = json.decode(response.body);
      print("Response : ${jsonval}");
      var data = jsonval["result"];
      if(jsonval["status"] == "success"){
        setState(() {
          print("DATA : ${data}");
          CDialog cd = new CDialog(context: context);
          cd.dialogShow("Success", "Address added successfully!", "OK");
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Cart(),
          ));
        });
      }else if(jsonval["status"] == "failed"){
          CDialog cd = new CDialog(context: context);
          cd.dialogShow("Error", "Some error occured while saving...", "OK");
      }
    }catch(e){
          print("Error : ${e.message}");
          CDialog cd = new CDialog(context: context);
          cd.dialogShow("Error", "Some error occured while loading.", "OK");

    }
  }else if(await con.check() == false){
      CDialog cd = new CDialog(context: context);
      cd.dialogShow("Error", "No Internet Connection", "OK");
  }
}

  Future<bool> getPinCode() async{
  if(await con.check() == true){
    try{
      final response = await http.post("${curl}Api/getPincode",
      body: {
        "number": this.number,
        "valid": this.valid,
        "pincode":_pincode.text,
      });
      var jsonval = json.decode(response.body);
      print("Response : ${jsonval}");
      var data = jsonval["result"];
      if(jsonval["status"] == "success"){
        return true;
      }else if(jsonval["status"] == "failed"){
        return false;
      }
    }catch(e){
          print("Error : ${e.message}");
          CDialog cd = new CDialog(context: context);
          cd.dialogShow("Error", "Some error occured while loading.", "OK");

    }
  }else if(await con.check() == false){
      CDialog cd = new CDialog(context: context);
      cd.dialogShow("Error", "No Internet Connection", "OK");
  }
}


  void getCustomer() async{
  if(await con.check() == true){
    try{
      final response = await http.post("${curl}Api/getCustomer",
      body: {
        "number": this.number,
        "valid": this.valid,
      });
      var jsonval = json.decode(response.body);
      print("Response : ${jsonval}");
      var data = jsonval["result"];
      if(jsonval["status"] == "success"){
        setState(() {
          print("DATA : ${data}");
          customer = data.map<Customer>((i)=>Customer.fromJson(i)).toList();
          _name.text = customer[0].name;
          _email.text = customer[0].email;
        });
      }else if(jsonval["status"] == "failed"){
          CDialog cd = new CDialog(context: context);
          cd.dialogShow("Error", "Some error occured while saving...", "OK");
      }
    }catch(e){
          print("Error : ${e.message}");
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
    getCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(child: AppliBar(title: "Add Address"), preferredSize: Size(MediaQuery.of(context).size.width,50.0)),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 30.0,),
            Theme(
              data: ThemeData(
                primaryColor: Colors.black38,
                cursorColor: Colors.black38,
                fontFamily: "Roboto-Slab",
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                      child: TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return "Please enter your name";
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Name",
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0,),
                        ),
                        controller: _name,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                      child: TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return "Please enter your email";
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Email",
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0,),
                        ),
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                      child: TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return "Please enter your address";
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Address",
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0,),
                        ),
                        maxLines: 3,
                        controller: _address,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                      child: TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return "Please enter your PinCode";
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "PinCode",
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0,),
                        ),
                        controller: _pincode,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(height: 50.0,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: RaisedGradientButton(
                        height: 55.0,
                        child: Text("Add Address", style: TextStyle(fontFamily:"Roboto-Slab",color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),),
                        gradient: LinearGradient(colors: [primary,secondary]),
                        onPressed: (){
                          if(_formKey.currentState.validate()){
                            getPinCode().then((val){
                              if(val){
                                addAddress();
                              }else{
                                CDialog cd = new CDialog(context: context, tcolor: danger);
                                cd.dialogShow("Sorry!", "We do not provide delivery service at this pincode.", "OK");
                              }
                            });
                          }
                        },
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