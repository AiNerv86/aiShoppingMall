import 'dart:convert';

import 'package:aishoppingmall/model/cart_model.dart';
import 'package:aishoppingmall/model/food_model.dart';
import 'package:aishoppingmall/model/user_model.dart';
import 'package:aishoppingmall/utility/my_api.dart';
import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:aishoppingmall/utility/normal_doalog.dart';
import 'package:aishoppingmall/utility/sqlite_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:toast/toast.dart';

class ShowMenuItem extends StatefulWidget {
  final UserModel userModel;

  ShowMenuItem({Key key, this.userModel}) : super(key: key);

  @override
  _ShowMenuItemState createState() => _ShowMenuItemState();
}

class _ShowMenuItemState extends State<ShowMenuItem> {
  UserModel userModel;

  FoodModel foodModel;
  List<FoodModel> foodModels = List();

  String idShop, nameShop;

  int amount = 1;

  double lat1, lng1, lat2, lng2;
  Location location = Location();

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
    idShop = userModel.id;

    readFoodMenu();
    findLocation();
  }

  @override
  Widget build(BuildContext context) {
    return foodModels.length == 0
        ? MyStyle().showProgress()
        : ListView.builder(
            itemCount: foodModels.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                print('You Click index = $index');
                amount = 1;
                confirmOrder(index);
              },
              child: Row(
                children: <Widget>[
                  showFoodImage(context, index),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              foodModels[index].nameFood,
                              style: MyStyle().mainTitle,
                            ),
                          ],
                        ),
                        Text(
                          '${foodModels[index].price} Bath.',
                          style: TextStyle(
                            fontSize: 40,
                            color: MyStyle().darkColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.5 - 8.0,
                              child: Text(foodModels[index].detail),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Container showFoodImage(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      width: MediaQuery.of(context).size.width * 0.5 - 16.0,
      height: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(
              '${MyConstant().domain}${foodModels[index].pathFood}'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<Null> findLocation() async {
    location.onLocationChanged.listen(
      (event) {
        lat1 = event.latitude;
        lng1 = event.longitude;
        // print('lat1: $lat1 , lng1:$lng1, lat2: $lat2 , lng2:$lng2');
      },
    );
  }

  Future<Null> readFoodMenu() async {
    String url =
        '${MyConstant().domain}/aishoppingmall/getFoodWhereIdShop.php?isAdd=true&idShop=$idShop';

    Response response = await Dio().get(url);

    var result = json.decode(response.data);

    // print('response ==>>>> $result');

    for (var map in result) {
      foodModel = FoodModel.fromJson(map);
      setState(() {
        foodModels.add(foodModel);
      });
    }
  }

  Future<Null> confirmOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                foodModels[index].nameFood,
                style: MyStyle().mainH2Title,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 180,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: NetworkImage(
                          '${MyConstant().domain}${foodModels[index].pathFood}'),
                      fit: BoxFit.cover),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      size: 36,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        amount++;
                        print('amount = $amount');
                      });
                    },
                  ),
                  Text(
                    amount.toString(),
                    style: MyStyle().mainTitle,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      size: 36,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      if (amount > 1) {
                        setState(() {
                          amount--;
                        });
                      }
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 110,
                    child: RaisedButton(
                      color: MyStyle().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () {
                        Navigator.pop(context);

                        addOrderToCart(index);

                        print(
                            'Order ${foodModels[index].nameFood} Amount = $amount');
                      },
                      child: Text(
                        'Order',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: 110,
                    child: RaisedButton(
                      color: MyStyle().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> addOrderToCart(int index) async {
    String nameShop = userModel.nameShop;
    String idFood = foodModels[index].id;
    String nameFood = foodModels[index].nameFood;
    String price = foodModels[index].price;
    int sum = int.parse(price) * amount;

    lat2 = double.parse(userModel.lat);
    lng2 = double.parse(userModel.lng);
    double distance = MyAPI().calculateDistance(lat1, lng1, lat2, lng2);

    var distanceFormat = NumberFormat('#0.0#', 'en_US');
    String distanceString = distanceFormat.format(distance);

    int transport = MyAPI().calculateTransport(distance);

    //print(
    //    'idShop = $idShop, nameShop = $nameShop, idFood = $idFood, nameFood = $nameFood, price = $price, amount = $amount, sum = $sum, distance = $distanceString, transport = $transport');

    Map<String, dynamic> map = Map();

    map['idShop'] = idShop;
    map['nameShop'] = nameShop;
    map['idFood'] = idFood;
    map['nameFood'] = nameFood;
    map['price'] = price;
    map['amount'] = amount.toString();
    map['sum'] = sum.toString();
    map['distance'] = distanceString;
    map['transport'] = transport.toString();

    print('map ====> ${map.toString()}');

    CartModel cartModel = CartModel.fromJson(map);

    var object = await SQLiteHelper().readAllDataFromSQLite();

    print('object = ${object.toString()}');

    if (object.length == 0) {
      await SQLiteHelper().insertDataToSQLite(cartModel).then(
        (value) {
          print('Insert Seccess');
          showToast('Insert Seccess');
        },
      );
    } else {
      String idShopSQLite = object[0].idShop;

      if (idShop == idShopSQLite) {
        await SQLiteHelper().insertDataToSQLite(cartModel).then((value) {
          print('insert seccess');
          showToast('Insert Seccess');
        });
      } else {
        normalDialog(context,
            'Cart have order from shop ${object[0].nameShop} \n Please finish order from this shop.');
      }
    }
  }

  void showToast(String string) {
    Toast.show(
      string,
      context,
      duration: Toast.LENGTH_LONG,
    );
  }
}
