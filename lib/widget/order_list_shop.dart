import 'dart:convert';

import 'package:aishoppingmall/model/food_model.dart';
import 'package:aishoppingmall/model/order_model.dart';
import 'package:aishoppingmall/utility/my_api.dart';
import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListShop extends StatefulWidget {
  @override
  _OrderListShopState createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  FoodModel foodModel;

  bool status = true; // Have data
  bool loadStatus = true; //process load JSON

  String idShop, nameFoodStr;

  List<FoodModel> foodModels = [];
  List<OrderModel> orderModels = [];
  List<List<String>> listNameFoods = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listSums = [];
  List<int> totals = [];

  @override
  void initState() {
    super.initState();
    readFoodMenu();
    findIdShop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: orderModels.length == 0
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: orderModels.length,
              itemBuilder: (context, index) => Card(
                //color: index % 2 == 0 ? Colors.white : Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyStyle().showTitleH2(orderModels[index].nameUser),
                      MyStyle().showTitleH3(orderModels[index].orderDateTime),
                      buildTitle(),
                      ListView.builder(
                        itemCount: listNameFoods[index].length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index2) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: buildNameFoodText(index, index2),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(listPrices[index][index2]),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(listAmounts[index][index2]),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(listSums[index][index2]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MyStyle().showTitleH2('Total :'),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child:
                                MyStyle().showTitleH2(totals[index].toString()),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RaisedButton.icon(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              onPressed: () {},
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              )),
                          RaisedButton.icon(
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              onPressed: () {},
                              icon: Icon(
                                Icons.restaurant,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Cooking',
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Container buildTitle() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.grey),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Name Food',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Price',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Amount',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Sum',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> readFoodMenu() async {
    if (foodModels.length != 0) {
      foodModels.clear();
    }

    String url = '${MyConstant().domain}/aishoppingmall/getFood.php?isAdd=true';

    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString().trim() != 'null') {
        var result = json.decode(value.data);

        for (var map in result) {
          foodModel = FoodModel.fromJson(map);

          //print(foodModel.id);
          setState(() {
            foodModels.add(foodModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  Widget buildNameFoodText(int index, int index2) {
    //print('$index, $index2');

    for (var i = 0; i < foodModels.length; i++) {
      if (foodModels[i].id == listNameFoods[index][index2]) {
        nameFoodStr = foodModels[i].nameFood;
      }
    }
    return Text(nameFoodStr);
  }

  Future<Null> findIdShop() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idShop = preferences.getString(MyConstant().keyID);

    print('idShop = $idShop');

    String path =
        '${MyConstant().domain}/aishoppingmall/getOrderWhereIdShop.php?isAdd=true&idShop=$idShop';

    await Dio().get(path).then((value) {
      // print('value ==>> $value');

      var result = json.decode(value.data);

      for (var item in result) {
        OrderModel model = OrderModel.fromJson(item);

        //print('orderDateTime == ${model.orderDateTime}');

        List<String> nameFoods = MyAPI().createStringArray(model.idFood);
        List<String> prices = MyAPI().createStringArray(model.price);
        List<String> amounts = MyAPI().createStringArray(model.amount);
        List<String> sums = MyAPI().createStringArray(model.sum);

        int total = 0;
        for (var item in sums) {
          total = total + int.parse(item);
        }
        setState(() {
          orderModels.add(model);
          listNameFoods.add(nameFoods);
          listPrices.add(prices);
          listAmounts.add(amounts);
          listSums.add(sums);
          totals.add(total);
        });
      }
    });
  }
}
