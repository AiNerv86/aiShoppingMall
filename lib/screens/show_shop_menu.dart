import 'package:aishoppingmall/model/user_model.dart';
import 'package:flutter/material.dart';

class ShowShopMenu extends StatefulWidget {
  final UserModel userModel;
  ShowShopMenu({Key key, this.userModel}) : super(key: key);
  @override
  _ShowShopMenuState createState() => _ShowShopMenuState();
}

class _ShowShopMenuState extends State<ShowShopMenu> {
  UserModel userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel.nameShop),
      ),
    );
  }
}
