import 'dart:io';

import 'package:aishoppingmall/screens/main_rider.dart';
import 'package:aishoppingmall/screens/main_shop.dart';
import 'package:aishoppingmall/screens/main_user.dart';
import 'package:aishoppingmall/screens/signIn.dart';
import 'package:aishoppingmall/screens/signUp.dart';
import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:aishoppingmall/utility/normal_doalog.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    checkPreference();
  }

  Future<Null> checkPreference() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging();

      String token = await messaging.getToken();

      print('token::::$token');

      SharedPreferences preferences = await SharedPreferences.getInstance();

      String chooseTypeStr = preferences.getString('chooseType');
      String idLogin = preferences.getString('id');

      print('idLogIn::::$idLogin');

      if (idLogin != null && idLogin.isNotEmpty) {
        String url =
            '${MyConstant().domain}/aishoppingmall/editTokenWhereId.php?isAdd=true&id=$idLogin&token=$token';
        await Dio().get(url).then((value) {
          //print('############Update Token Success.');
          showToast('Update Token Success.');
        });
      }

      if (chooseTypeStr != null && chooseTypeStr.isNotEmpty) {
        if (chooseTypeStr == 'User') {
          routeToService(MainUser());
        } else if (chooseTypeStr == 'Shop') {
          routeToService(MainShop());
        } else if (chooseTypeStr == 'Rider') {
          routeToService(MainRider());
        } else {
          normalDialog(context, 'Error User Type');
        }
      }
    } catch (e) {}
  }

  void showToast(String string) {
    Toast.show(
      string,
      context,
      duration: Toast.LENGTH_LONG,
    );
  }

  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
            signInMenu(),
            signUpMenu(),
          ],
        ),
      );

  ListTile signInMenu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text('Sign In'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignIn());
        Navigator.push(context, route);
      },
    );
  }

  ListTile signUpMenu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text('Sign Up'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignUp());
        Navigator.push(context, route);
      },
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('guest.jpg'),
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text('Guest'),
        accountEmail: Text('Please Login'));
  }
}
