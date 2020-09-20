import 'dart:io';

import 'package:aishoppingmall/utility/my_style.dart';
import 'package:aishoppingmall/utility/signout_process.dart';
import 'package:aishoppingmall/widget/info_shop.dart';
import 'package:aishoppingmall/widget/list_menu_shop.dart';
import 'package:aishoppingmall/widget/order_list_shop.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class MainShop extends StatefulWidget {
  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  // Field
  Widget currentWidget = OrderListShop();

  String nameUser;

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('name');
    });
  }

  Future<Null> aboutNotification() async {
    if (Platform.isAndroid) {
      print('about Notif Work Android');

      FirebaseMessaging firebaseMessaging = FirebaseMessaging();

      await firebaseMessaging.configure(
        onLaunch: (message) {
          print('Notif onLanch');
        },
        onResume: (message) {
          print(
              'Notif onResume from home or sleep screen::${message.toString()}');
        },
        onMessage: (message) {
          print('Notif onMessage still open app::${message.toString()}');
          showToast('Have order from user.');
        },
      );
    } else if (Platform.isIOS) {
      print('about Notif Work IOS');
    }
  }

  @override
  void initState() {
    super.initState();

    aboutNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signOutProcess(context),
          )
        ],
        title: Text('Main shop'),
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showHead(),
                homeMenu(),
                foodMenu(),
                infomationMenu(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                signOutMenu(),
              ],
            ),
          ],
        ),
      );

  ListTile homeMenu() => ListTile(
        leading: Icon(Icons.home),
        title: Text('Lists Order'),
        subtitle: Text('Queue Order'),
        onTap: () {
          setState(() {
            currentWidget = OrderListShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile foodMenu() => ListTile(
        leading: Icon(Icons.fastfood),
        title: Text('Menu'),
        subtitle: Text('List Menu'),
        onTap: () {
          setState(() {
            currentWidget = ListMenuShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile infomationMenu() => ListTile(
        leading: Icon(Icons.info),
        title: Text('info shop'),
        subtitle: Text('shop detail'),
        onTap: () {
          setState(() {
            currentWidget = InfoShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile signOutMenu() => ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Sign Out'),
        subtitle: Text('back to Home'),
        onTap: () => signOutProcess(context),
      );

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration('shop.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text('Name Login'),
      accountEmail: Text('Login'),
    );
  }

  ////////////////////////////////////////////
  ///Toast

  void showToast(String string) {
    Toast.show(
      string,
      context,
      duration: Toast.LENGTH_LONG,
    );
  }
}
