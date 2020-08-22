import 'dart:convert';

import 'package:aishoppingmall/model/order_model.dart';
import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';

class ShowStatusOrder extends StatefulWidget {
  @override
  _ShowStatusOrderState createState() => _ShowStatusOrderState();
}

class _ShowStatusOrderState extends State<ShowStatusOrder> {
  String idUser;

  bool statusOrder = false;

  List<OrderModel> orderModels = List();
  List<List<String>> listOrders = List();
  List<List<String>> listPrices = List();
  List<List<String>> listAmounts = List();
  List<List<String>> listSums = List();
  List<int> listTotals = List();
  List<int> statusInts = List();

  @override
  void initState() {
    super.initState();
    findUser();
  }

  @override
  Widget build(BuildContext context) {
    return statusOrder ? buildContent() : buildNoneOrder();
  }

  Widget buildContent() => ListView.builder(
        itemCount: orderModels.length,
        itemBuilder: (context, index) => Column(
          children: <Widget>[
            buildNameShop(index),
            buildDateTimeOrder(index),
            buildDistance(index),
            buildTransport(index),
            buildHead(),
            buildListViewListOrder(index),
            buildTotal(index),
            buildStopIndicator(statusInts[index]),
            MyStyle().mySizebox(),
          ],
        ),
      );

  Widget buildStopIndicator(int index) => Column(
        children: <Widget>[
          StepsIndicator(
            lineLength: 80,
            selectedStep: index,
            nbSteps: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('Order'),
              Text('Cooking'),
              Text('Delivery'),
              Text('Finish'),
            ],
          )
        ],
      );

  ListView buildListViewListOrder(int index) => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: listOrders[index].length,
        itemBuilder: (context, index2) => Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text(listOrders[index][index2]),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(listPrices[index][index2]),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(listAmounts[index][index2]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(listSums[index][index2]),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildTotal(int index) => Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MyStyle().showTitleH2('Total = '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH2(listTotals[index].toString()),
          ),
        ],
      );

  Container buildHead() {
    return Container(
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(color: Colors.grey),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: MyStyle().showTitleH3White('Order List'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3White('Price'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3White('Amount'),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MyStyle().showTitleH3White('Sum'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row buildTransport(int index) {
    return Row(
      children: <Widget>[
        MyStyle().showTitleH3('Transport: ${orderModels[index].transport}'),
      ],
    );
  }

  Row buildDistance(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        MyStyle().showTitleH3('Distance: ${orderModels[index].distance} Km.'),
      ],
    );
  }

  Row buildDateTimeOrder(int index) {
    return Row(
      children: <Widget>[
        MyStyle().showTitleH3(
            'Date Time Order: ${orderModels[index].orderDateTime}'),
      ],
    );
  }

  Row buildNameShop(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MyStyle().showTitleH2(orderModels[index].nameShop),
      ],
    );
  }

  Center buildNoneOrder() => Center(child: Text('List order is empty.'));

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idUser = preferences.getString('id');

    print('idUser = $idUser');

    readOrderFromIdUser();
  }

  Future<Null> readOrderFromIdUser() async {
    if (idUser != null) {
      String url =
          '${MyConstant().domain}/aishoppingmall/getOrderWhereUserId.php?isAdd=true&idUser=$idUser';

      Response response = await Dio().get(url);

      if (response.toString() != 'null') {
        var result = json.decode(response.data);

        for (var map in result) {
          OrderModel model = OrderModel.fromJson(map);

          List<String> orders = changeArray(model.nameFood);
          List<String> prices = changeArray(model.price);
          List<String> amounts = changeArray(model.amount);
          List<String> sums = changeArray(model.sum);

          int status = 0;
          switch (model.status) {
            case 'UserOrder':
              status = 0;
              break;
            case 'ShopCooking':
              status = 1;
              break;
            case 'RiderHandle':
              status = 2;
              break;
            case 'Finish':
              status = 3;
              break;
            default:
          }

          int total = 0;

          for (var value in sums) {
            total = total + int.parse(value.trim());
          }

          setState(() {
            statusOrder = true;
            orderModels.add(model);
            listOrders.add(orders);
            listPrices.add(prices);
            listAmounts.add(amounts);
            listSums.add(sums);
            listTotals.add(total);
            statusInts.add(status);
          });
        }
      } else {
        setState(() {
          statusOrder = false;
        });
      }

      // print('response = $response');
    }
  }

  List<String> changeArray(String string) {
    List<String> list = List();

    String myString = string.substring(1, string.length - 1);

    // print('myString = $myString');
    list = myString.split(', ');
    return list;
  }
}
