import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kapra_cart/ModelClasses/getShopKeeperDetails.dart';
import 'package:kapra_cart/ModelClasses/loginUserModelClass.dart';
import 'package:kapra_cart/ModelClasses/shopDetailsModelClass.dart';
import 'package:kapra_cart/ShopKeeperDashboard/shopkeeperHomePage.dart';
import 'package:kapra_cart/constant.dart';
import 'package:kapra_cart/customWidgets/customAppbar.dart';
import 'package:kapra_cart/customWidgets/customButton.dart';
import 'package:http/http.dart' as http;

class AddProducts extends StatefulWidget {
  //final ShopDetailsModelClass shopId;
  final String s_id;
  final String shopKeeperId;

  const AddProducts({
    Key key,
    this.s_id,
    this.shopKeeperId,
  }) : super(key: key);

  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController name = TextEditingController();

  TextEditingController price = TextEditingController();

  TextEditingController description = TextEditingController();
  String productCategory;
  Future<File> file;
  String base64Image;
  File tempFile;
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
    productCategory = "";
  }

  void setShopType(val) {
    setState(() {
      productCategory = val;
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
          child: GestureDetector(
            onTap: () {
              print(widget.s_id + widget.shopKeeperId);
            },
            child: Text(
              "Add New Product",
              style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
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
                    "Add Product Details",
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
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Radio(
                      value: "Men",
                      groupValue: productCategory,
                      onChanged: (value) {
                        setShopType(value);
                      }),
                  Text(
                    "Men",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Column(
                children: [
                  Radio(
                      value: "Women",
                      groupValue: productCategory,
                      onChanged: (value) {
                        setShopType(value);
                      }),
                  Text(
                    "Women",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Column(
                children: [
                  Radio(
                      value: "Kids",
                      groupValue: productCategory,
                      onChanged: (value) {
                        setShopType(value);
                      }),
                  Text(
                    "Kids",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
        )
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
            name: "Product Name",
            hintText: "name",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFeild(
            controller: price,
            name: "Price",
            hintText: "price",
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
                    "Add Product Image",
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
                    "Step:3  Enter  Description ",
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

                  Navigator.pop(context);
                }
              },
              child: CustomButton(
                buttonName: "Add Product",
              ),
            ),
          ),
        )
      ],
    );
  }

  void uploadShopDetails() async {
    var response =
        await http.post(basicUrl + "uploadProductDetails.php", body: {
      'name': name.text,
      'price': price.text,
      'category': productCategory,
      'image': tempFile.path.split("/").last,
      'description': description.text,
      'shopid': widget.s_id
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
        price.text == "" ||
        description.text == "" ||
        productCategory == null) {
      _scaffoldState.currentState
          .showSnackBar(SnackBar(content: Text("Complete the Feilds First")));
      return false;
    } else {
      return true;
    }
    ;
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
    http.post(basicUrl + "uploadImage.php",
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
