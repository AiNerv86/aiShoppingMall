import 'dart:convert';

import 'package:aishoppingmall/model/user_model.dart';
import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:aishoppingmall/utility/signout_process.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String nameUser;
  List<UserModel> userModels = List();

  @override
  void initState() {
    super.initState();
    findUser();
    readShop();
  }

  Future<Null> readShop() async {
    String url =
        '${MyConstant().domain}/aishoppingmall/getUserWhereChooseType.php?isAdd=true&chooseType=Shop';

    await Dio().get(url).then(
      (value) {
        // print('value::::$value');
        var result = json.decode(value.data);

        for (var map in result) {
          UserModel model = UserModel.fromJson(map);

          if (model.nameShop.isNotEmpty) {
            print('NameShop:::: ${model.nameShop}');
            setState(() {
              userModels.add(model);
            });
          } else {}
        }
      },
    );
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('name');
    });
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
        title: Text(nameUser == null ? 'Main user' : '$nameUser login'),
      ),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[showHead()],
        ),
      );

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration('user.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text('Name Login'),
      accountEmail: Text('Login'),
    );
  }
}
