import '../theme/variables.dart';
import '../components/component.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class LoginStatus {
  Connect con = new Connect();
  Shared sh = Shared();
  List data;

    Future<bool> login(phone,authid) async{
        try{
          final response = await http.post(
              "${curl}Api/register",
              body: {
                "phone":phone,
                "authid":authid,
              }
            );
          var jsonval = json.decode(response.body);
          print("Response : ${jsonval}");
          var data = jsonval["result"];
          print("DATA : ${data}");
          data[0]["id"] != null ? sh.setShared("id", data[0]["id"]) : sh.setShared("id", null); 
            data[0]["customer_id"] != null ? sh.setShared("customer_id", data[0]["customer_id"]) : sh.setShared("customer_id", null);
            data[0]["email"] != null ? sh.setShared("email", data[0]["email"]) : sh.setShared("email", null);
            data[0]["fname"] != null ? sh.setShared("fname", data[0]["fname"]) : sh.setShared("fname", null);
            data[0]["lname"] != null ? sh.setShared("lname", data[0]["lname"]) : sh.setShared("lname", null);
            data[0]["number"] != null ? sh.setShared("number", data[0]["number"]) : sh.setShared("number", null);
            data[0]["address"] != null ? sh.setShared("address", data[0]["address"]) : sh.setShared("address", null);
            data[0]["img"] != null ? sh.setShared("img", data[0]["img"]) : sh.setShared("img", null);
            sh.setSharedBool("login", true);
            return true;
        }catch(e){
          print("Error : ${e.message}");
          return false;
        }
        
    }


    Future<bool> loginState() async{
      var status = await sh.getSharedBool("login");
      if(status == true){
        return true;
      }else{
        return false;
      }
    }

}