import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kapra_cart/API/allOrdersApi.dart';
import 'package:kapra_cart/API/fetchAllServicesOrders.dart';
import 'package:kapra_cart/API/productApi.dart';
import 'package:kapra_cart/ModelClasses/oderModelClass.dart';
import 'package:kapra_cart/ModelClasses/product.dart';
import 'package:kapra_cart/ModelClasses/loginUserModelClass.dart';
import 'package:http/http.dart' as http;
import 'package:kapra_cart/ModelClasses/serviceOrderModelClass.dart';
import 'package:kapra_cart/ShopKeeperDashboard/orderDetailsScreenShopkeeper.dart';
import 'package:kapra_cart/TailorDashboard/orderDetailsScreenTailor.dart';
import 'package:kapra_cart/constant.dart';
import 'package:kapra_cart/customWidgets/clayContainer.dart';

class TailorOrdersScrren extends StatefulWidget {
  final String category;
  final String tailorshopId;

  const TailorOrdersScrren({Key key, this.category, this.tailorshopId})
      : super(key: key);
  @override
  _TailorOrdersScrrenState createState() => _TailorOrdersScrrenState();
}

class _TailorOrdersScrrenState extends State<TailorOrdersScrren> {
  loginUserModelClass user;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: layout(),
    );
  }

  layout() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              clayContainer(
                borderRadius: 75,
                color: Colors.white,
                height: 130,
                width: 130,
                child: Center(
                    child: Text(
                  "Orders",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Container(
                  child: FutureBuilder(
                    future: fetchAllServicesOrders(widget.tailorshopId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, index) {
                            ServicesOrderDetails servicesOrderDetails =
                                snapshot.data[index];

                            return allOrders(servicesOrderDetails, index + 1);
                          },
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  allOrders(ServicesOrderDetails servicesOrderDetails, count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        elevation: 20,
        child: GestureDetector(
          onTap: () {
            fetchUserDetails(servicesOrderDetails);
            print(servicesOrderDetails.completed);
            _globalKey.currentState.showSnackBar(
                SnackBar(content: Text("Loading Order Details...")));
            CircularProgressIndicator();
            Timer(Duration(seconds: 2), () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OderDetailsScreenTailor(
                      count: count,
                      servicesOrderDetails: servicesOrderDetails,
                      buyer: user,
                    ),
                  ));
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 130,
            decoration: BoxDecoration(
                color: servicesOrderDetails.completed == "0"
                    ? Colors.red[400]
                    : Colors.green,
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 5),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(40),
                //     child: Image.network(
                //       "http://192.168.18.13/kapraCartScript/${product.pImage}",
                //       height: 100,
                //       width: 100,
                //       fit: BoxFit.fill,
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Order # " + count.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            letterSpacing: 2),
                      ),
                      Flexible(
                        child: Text(
                          "Tap to view Details",
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              color: buttonColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Tap for",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                        letterSpacing: 1),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                        letterSpacing: 1),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Delivery in 7 days",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: buttonColor,
                                            letterSpacing: 1),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void fetchUserDetails(ServicesOrderDetails servicesOrderDetails) async {
    var response =
        await http.post(basicUrl + "fetchUserDetailsBygivngId.php", body: {
      'buyerId': servicesOrderDetails.buyerId,
    });

    user = loginUserModelClass.fromjson(jsonDecode(response.body));
  }
}
