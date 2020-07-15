import 'package:aishoppingmall/model/user_model.dart';
import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListShop extends StatefulWidget {
  @override
  _OrderListShopState createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Text('Show List Orders');
  }
}
