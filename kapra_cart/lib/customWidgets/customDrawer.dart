import 'package:flutter/material.dart';
import 'package:kapra_cart/BuyerDashboard/notificationScreen.dart';
import 'package:kapra_cart/ModelClasses/loginUserModelClass.dart';
import 'package:kapra_cart/ShopKeeperDashboard/profileScreen.dart';
import 'package:kapra_cart/constant.dart';
import 'package:kapra_cart/loginScreen.dart';
import 'package:kapra_cart/roleOptScreen.dart';

class customDrawer extends StatefulWidget {
  loginUserModelClass userDetails;
  customDrawer({this.userDetails});
  @override
  _customDrawerState createState() => _customDrawerState();
}

class _customDrawerState extends State<customDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: buttonColor,
            height: MediaQuery.of(context).size.height / 2 - 150,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    basicUrl + "${widget.userDetails.image}",
                    height: 80,
                    width: 80,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.userDetails.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        //fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ),
                Text(widget.userDetails.email,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      shopkeeperDetails: widget.userDetails,
                      roleStatus: '1',
                    ),
                  ));
            },
            leading: Text("Profile"),
            trailing: Icon(Icons.accessibility_new),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Notifications(),
                  ));
            },
            leading: Text("Notifications"),
            trailing: Icon(Icons.notification_important),
          ),
          ListTile(
            onTap: () {
              constants.sharedPreferences.clear();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => roleOptScreen(),
                  ));
            },
            leading: Text("Sign out"),
            trailing: Icon(Icons.supervised_user_circle),
          )
        ],
      ),
    );
  }
}
