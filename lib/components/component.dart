import 'package:flutter/material.dart';
import 'dart:io';
import 'package:connectivity/connectivity.dart'; //  connectivity: ^0.4.2
import 'package:image_picker/image_picker.dart'; //  image_picker: ^0.5.0+6
import 'package:shared_preferences/shared_preferences.dart'; // shared_preferences: ^0.5.1+2
import 'package:intl/intl.dart'; //  intl: ^0.15.8
// import 'package:barcode_scan/barcode_scan.dart'; //   barcode_scan: ^0.0.4
// import 'package:flutter/services.dart'; // For PlatformException in barcode_scan
/*
Note:-
  Remember To await Future return type functions.
*/
class CDialog{
  final BuildContext context;
  final Color tcolor;
  final Color bcolor;
  final Color btcolor;
  final Function function;
  String title,body,bttext;
      CDialog({this.context,this.tcolor,this.bcolor,this.btcolor,this.function});
      void dialogShow(String title, String body, String btnText) {
          // flutter defined function
          this.title = title;
          this.body = body;
          this.bttext = btnText;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text(title,style: new TextStyle(color: tcolor),),
                content: new Text(body,style: new TextStyle(color: bcolor),),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text(btnText,style: new TextStyle(color: btcolor),),
                    onPressed: () {
                      Navigator.of(context).pop();
                      function();
                    },
                  ),
                ],
              );
            },
          );
        }

      String getTitle(){
        return this.title;
      }
      String getBody(){
        return this.body;
      }
      String getBText(){
        return this.bttext;
      }

}

class Connect{
  var ret;
  Connect(){
    ret = check();
  }
  Future<bool> check() async{
     var connectivityResult = await(new Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      ret = true;
      return ret;
    }else{
      ret = false;
      return ret;
    }
  }
}

class Camera{

  Future<File> getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    return image;
  }

  Future<File> getGallery() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }
}

class Shared{
  String str;
  int numint;
  double numdouble;
  bool boolval;
   setShared(String skey, String name) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(skey, name);
  }

   setSharedInt(String skey, int name) async{
    SharedPreferences pref =await SharedPreferences.getInstance();
    pref.setInt(skey, name);
  }
   setSharedDouble(String skey, double name) async{
    SharedPreferences pref =await SharedPreferences.getInstance();
    pref.setDouble(skey, name);
  }
   setSharedBool(String skey, bool name) async{
    SharedPreferences pref =await SharedPreferences.getInstance();
    pref.setBool(skey, name);
  }

  getShared(val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    str = pref.getString(val);
    return str;
  }
  getSharedInt(val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    numint = pref.getInt(val);
    return numint;
  }
  getSharedDouble(val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    numdouble = pref.getDouble(val);
    return numdouble;
  }
  getSharedBool(val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    boolval = pref.getBool(val);
    return boolval;
  }
  remove(val) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(val);
  }
  check(val) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool check = pref.containsKey(val);
    return check;
  }
  clear() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

class DateTimePicker{

    String dformat(date){
      date = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(date);
    }
    
    Function functiond;
    Function functiont;
    DateTimePicker({this.functiond,this.functiont});
    DateTime selectedDate = DateTime.now();
    DateTime picked_d;

    Future<Null> selectDate(BuildContext context) async{
        this.picked_d = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1947,1),
        lastDate: DateTime(2101),
      );
      checkd();
    }

    checkd(){
      if(picked_d != null && picked_d != selectedDate){
        selectedDate = picked_d;
      }
    }
    String getDate(){
      String currentDate = DateFormat('dd-MM-yyyy').format(selectedDate);
      return currentDate;
    }

    String tformat(date){
      date = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(date);
    }

    TimeOfDay time = TimeOfDay.fromDateTime(DateTime.parse('2018-10-20 16:30:04Z')); // 4:30pm
    TimeOfDay picked_t;
    BuildContext contextt;

    Future<Null> selectTime(contextt) async{
       this.picked_t = await showTimePicker(
        context: contextt,
        initialTime: time,
      );
      checkt();
      functiont();
    }
    checkt(){
      if (picked_t != null && picked_t != time) {
        time = picked_t;
      }
    }
      String getTime(){
        String formatedTime = time.format(contextt);
        return formatedTime;
    }

}


// class QR{
//     Future _scanQR() async {
//     try {
//       String qrResult = await BarcodeScanner.scan();
//         return qrResult;
//         print(qrResult);
//     } on PlatformException catch (ex) {
//       if (ex.code == BarcodeScanner.CameraAccessDenied) {
//           return "Camera permission was rejected";
//       } else {
//           return "Unknown Error $ex";
//       }
//     } on FormatException {
//         return "You pressed the back button before scanning anything";
//     } catch (ex) {
//         return "Unknown Error $ex";
//     }
//   }

// }

Widget buildTextField(String label, TextEditingController controller,bool isPassword){
  return TextFormField(
    controller: controller,
    decoration: new InputDecoration(
      labelText: label,
    ),
    obscureText: isPassword,
  );
}

