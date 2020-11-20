import 'package:flutter/material.dart';
import 'components/CustomShape.dart';
import 'dart:io';
import 'components/component.dart';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'Profile.dart';
import 'theme/variables.dart';
import 'components/AppBar.dart';
import 'business/Models/Customer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class ProfileEdit extends StatefulWidget {
  ProfileEdit({Key key}) : super(key: key);

  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();

  Connect con = new Connect();
  Shared sh = Shared();
  File imgfile;
  List<Customer> customer;
  String number, valid, name, img;

  void getGallery() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgfile = file;
    });
  }

  void _updateProfile() async {
    if (await con.check() == true) {
      try {
        var uri = Uri.parse("${curl}Api/updateProfile");
        var request = http.MultipartRequest("POST", uri);
        if (imgfile != null) {
          print("processing img");
          var stream =
              http.ByteStream(DelegatingStream.typed(imgfile.openRead()));
          stream != null
              ? print("stream processed")
              : print("stream processing");
          var length = await imgfile.length();
          length != null
              ? print("length processed")
              : print("length processing");
          final mimeTypeData =
              lookupMimeType(imgfile.path, headerBytes: [0xFF, 0xD8])
                  .split('/');
          var multipartFile = http.MultipartFile("img", stream, length,
              filename: p.basename(imgfile.path),
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
          print(p.basename(imgfile.path));
          multipartFile != null
              ? print("file processed")
              : print("file processing");
          request.files.add(multipartFile);
        }
        request.fields["number"] = number;
        request.fields["valid"] = valid;
        request.fields["name"] = _name.text;
        request.fields["email"] = _email.text;
        var response = await request.send();
        print("Response :${await response.stream.bytesToString()}");
        if (response.statusCode == 200) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Profile(),
          ));
        } else {
          print("Response : ${response.statusCode}");
        }
      } catch (e) {
        CDialog cd = new CDialog(context: context, tcolor: Colors.red);
        cd.dialogShow("Sorry", "Some Server Error Has Occured!", "OK");
      }
    } else if (await con.check() == false) {
      CDialog cd = new CDialog(context: context);
      cd.dialogShow("Error", "No Internet Connection", "OK");
    }
  }

  void getCustomer() async {
    if (await con.check() == true) {
      try {
        final response = await http.post("${curl}Api/getCustomer", body: {
          "number": this.number,
          "valid": this.valid,
        });
        var jsonval = json.decode(response.body);
        print("Response : ${jsonval}");
        var data = jsonval["result"];
        if (jsonval["status"] == "success") {
          setState(() {
            print("DATA : ${data}");
            customer = data.map<Customer>((i) => Customer.fromJson(i)).toList();
            _name.text = customer[0].name;
            _email.text = customer[0].email;
            img = customer[0].img;
          });
        } else if (jsonval["status"] == "failed") {
          CDialog cd = new CDialog(context: context);
          cd.dialogShow("Error", "Some error occured while saving...", "OK");
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
    getCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: PreferredSize(
          child: AppliBar(title: "Edit Profile"),
          preferredSize: Size(MediaQuery.of(context).size.width, 50)),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            new ClipPath(
              clipper: CustomShape(),
              child: new Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 80.0,
                decoration: BoxDecoration(
                  color: primary,
                ),
              ),
            ),
            ListView(
              children: <Widget>[
                Center(
                  child: new Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(top: 50.0),
                    child: new Form(
                      key: _formKey,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Hero(
                                tag: 'profile_img',
                                child: Container(
                                  width: 150.0,
                                  height: 150.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 4.0),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imgfile == null
                                            ? img == null
                                                ? NetworkImage(
                                                    "${curl}uploads/profile/default_user.png")
                                                : NetworkImage("${curl + img}")
                                            : FileImage(imgfile),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        getGallery();
                                      });
                                    },
                                    color: primary,
                                    child: Icon(
                                      Icons.cloud_upload,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          new Text(
                            "Name",
                            style: new TextStyle(color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                          new SizedBox(
                            height: 3.0,
                          ),
                          new TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Name';
                              }
                            },
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 10.0),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            controller: _name,
                          ),
                          new SizedBox(
                            height: 20.0,
                          ),
                          new Text("Email",
                              style: new TextStyle(color: Colors.white),
                              textAlign: TextAlign.left),
                          new SizedBox(
                            height: 3.0,
                          ),
                          new TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Email';
                              }
                            },
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 10.0),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            keyboardType: TextInputType.emailAddress,
                            controller: _email,
                          ),
                          new SizedBox(
                            height: 40.0,
                          ),
                          Center(
                            child: MaterialButton(
                              child: Text(
                                "Update",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              color: primary,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _updateProfile();
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                new SizedBox(
                  height: 40.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
