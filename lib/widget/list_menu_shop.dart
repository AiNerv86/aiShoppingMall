import 'dart:convert';

import 'package:aishoppingmall/model/food_model.dart';
import 'package:aishoppingmall/screens/add_menu_shop.dart';
import 'package:aishoppingmall/screens/edit_menu_shop.dart';
import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListMenuShop extends StatefulWidget {
  @override
  _ListMenuShopState createState() => _ListMenuShopState();
}

class _ListMenuShopState extends State<ListMenuShop> {
  FoodModel foodModel;
  String nameMenu, price, descriptionMenu, urlPicture;
  bool status = true; // Have data
  bool loadStatus = true; //process load JSON

  List<FoodModel> foodModels = List();

  @override
  void initState() {
    super.initState();
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    if (foodModels.length != 0) {
      foodModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString('id');

    // print('idShop ::::: $idShop');

    String url =
        '${MyConstant().domain}/aishoppingmall/getFoodWhereIdShop.php?isAdd=true&idShop=$idShop';

    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString().trim() != 'null') {
        var result = json.decode(value.data);

        for (var map in result) {
          foodModel = FoodModel.fromJson(map);
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        loadStatus ? MyStyle().showProgress() : showContent(),
        addMenuButton(),
      ],
    );
  }

  Widget showContent() {
    return status
        ? showListMenu()
        : Center(
            child: Text('No Record Menu.'),
          );
  }

  Widget showListMenu() => ListView.builder(
        itemCount: foodModels.length,
        itemBuilder: (context, index) => Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: Image.network(
                '${MyConstant().domain}/${foodModels[index].pathFood}',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.4,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      foodModels[index].nameFood,
                      style: MyStyle().mainTitle,
                    ),
                    Text(
                      'price: ${foodModels[index].price} Bath',
                      style: MyStyle().mainH2Title,
                    ),
                    Text(
                      foodModels[index].detail,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => EditMenuShop(
                                foodModel: foodModels[index],
                              ),
                            );
                            Navigator.push(context, route).then(
                              (value) => readFoodMenu(),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => deleteFood(foodModels[index]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget addMenuButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => AddMenuShop(),
                    );

                    Navigator.push(context, route)
                        .then((value) => readFoodMenu());
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );

  Future<Null> deleteFood(FoodModel foodModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle()
            .showTitleH2('Are you delete menu ${foodModel.nameFood} ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);

                  String url =
                      '${MyConstant().domain}/aishoppingmall/deleteFoodWhereId.php?isAdd=true&id=${foodModel.id}';
                  await Dio().get(url).then((value) => readFoodMenu());
                },
                child: Text('Confirm'),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
