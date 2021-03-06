import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kapra_cart/ModelClasses/loginUserModelClass.dart';
import 'package:kapra_cart/ModelClasses/shopDetailsModelClass.dart';
import 'package:kapra_cart/ShopKeeperDashboard/shopkeeperHomePage.dart';
import 'package:kapra_cart/constant.dart';
import 'package:kapra_cart/customWidgets/customAppbar.dart';
import 'package:kapra_cart/customWidgets/customButton.dart';
import 'package:http/http.dart' as http;

class AddShopDetails extends StatefulWidget {
  final String email;
  final String password;

  const AddShopDetails({Key key, this.email, this.password}) : super(key: key);
  @override
  _AddShopDetailsState createState() => _AddShopDetailsState();
}

class _AddShopDetailsState extends State<AddShopDetails> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController description = TextEditingController();
  String shopType;
  Future<File> file;
  String base64Image;
  File tempFile;
  var sk_id;
  var shop_id;
  loginUserModelClass shopKeeperdetails;
  String status = "";
  String errormessage = "Error in uploading image";

  void pickImage() {
    file = ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shopType = "";
    shopKeeperDetails();
  }

  void setShopType(val) {
    setState(() {
      shopType = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Create Your Store",
            style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
        ),
      ),
      body: layout(),
    );
  }

  layout() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [topLayout(), middleLayout(), endLayout()],
        ),
      ),
    );
  }

  topLayout() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(25)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Shop Details",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    "Step 1:  Entering Your details",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            )
          ],
        ),
        allFeilds(),
      ],
    );
  }

  allFeilds() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFeild(
            controller: name,
            name: "Name of Shop",
            hintText: "name",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFeild(
            controller: address,
            name: "Address",
            hintText: "Address",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFeild(
            controller: phone,
            name: "Phone",
            hintText: "phone #",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFeild(
            controller: city,
            name: "City",
            hintText: "City",
          ),
        ),
      ],
    );
  }

  middleLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Add Shop Image",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    "Step:2  Entering Your image",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(25)),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            pickImage();
          },
          child: file == null
              ? Container(
                  child: Icon(
                    Icons.add,
                    size: 20,
                  ),
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15)))
              : Container(
                  height: 80,
                  width: 80,
                  child: showImage(),
                ),
        ),
      ],
    );
  }

  endLayout() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(25)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Description",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    "Step:3  Entering Your Desdription",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        TextField(
          controller: description,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: new BorderSide(color: Colors.red)),
            hintText: "Description",
            labelText: "Description",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopkeeperHomePage(),
                  ));
            },
            child: GestureDetector(
              onTap: () {
                if (checkAllFeilds() == true) {
                  uploadShopDetails();
                  startUploadImage();

                  ////////////////////////////// add SK_ID and S_ID to shopkeeper and shop details.

                  Navigator.pop(context);
                }
              },
              child: CustomButton(
                buttonName: "Add Shop",
              ),
            ),
          ),
        )
      ],
    );
  }

  void uploadShopDetails() async {
    var response = await http.post(basicUrl + "uploadShopDetails.php", body: {
      'name': name.text,
      'address': address.text,
      'phone': phone.text,
      'city': city.text,
      'category': "Boutique",
      'image': tempFile.path.split("/").last,
      'description': description.text,
      'sk_id': sk_id,
    });

    print(response.body);
  }

  showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tempFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                  image: FileImage(snapshot.data),
                  fit: BoxFit.fill,
                )),
          );
        } else if (null != snapshot.error) {
          return Text("Error in picking");
        } else {
          return Text("Pick image",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ));
        }
      },
    );
  }

  bool checkAllFeilds() {
    if (name.text == "" ||
        address.text == "" ||
        phone.text == "" ||
        city.text == "" ||
        description.text == "" ||
        shopType == null) {
      _scaffoldState.currentState
          .showSnackBar(SnackBar(content: Text("Complete the Feilds First")));
      return false;
    } else {
      return true;
    }
    ;
  }

  void shopKeeperDetails() async {
    final response = await http.post(basicUrl + "checkUser.php", body: {
      'email': widget.email,
      'password': widget.password,
      'table': "shopkeeper"
    });
    shopKeeperdetails = loginUserModelClass.fromjson(jsonDecode(response.body));
    sk_id = shopKeeperdetails.id;
  }

  void setstatus(String message) {
    status = message;
  }

  startUploadImage() {
    setstatus("Uploading image.... ");
    if (null == tempFile.path) {
      setstatus(errormessage);
      return;
    }
    String filename = tempFile.path.split('/').last;
    upload(filename);
  }

  void upload(String filename) {
    http.post((basicUrl + "uploadImage.php"),
        body: {"image": base64Image, "name": filename}).then((value) {
      setstatus(value.statusCode == 200 ? value.body : errormessage);
    }).catchError((error) {
      setstatus(error);
    });
  }
}

class TextFeild extends StatefulWidget {
  final TextEditingController controller;
  final String name;
  final String hintText;

  const TextFeild({Key key, this.name, this.hintText, this.controller})
      : super(key: key);
  @override
  _TextFeildState createState() => _TextFeildState();
}

class _TextFeildState extends State<TextFeild> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: widget.name == "Phone" ? TextInputType.number : null,
          controller: widget.controller,
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: new BorderSide(color: Colors.red)),
            hintText: widget.hintText,
            labelText: widget.name,
          ),
        ),
      ],
    );
  }
}
