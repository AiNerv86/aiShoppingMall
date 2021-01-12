import 'dart:convert';

import 'package:aishoppingmall/model/user_model.dart';
import 'package:aishoppingmall/screens/show_shop_menu.dart';
import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ShowListShop extends StatefulWidget {
  @override
  _ShowListShopState createState() => _ShowListShopState();
}

class _ShowListShopState extends State<ShowListShop> {
  List<UserModel> userModels = [];
  List<Widget> shopCards = [];

  @override
  void initState() {
    super.initState();
    readShop();
  }

  @override
  Widget build(BuildContext context) {
    return shopCards.length == 0
        ? MyStyle().showProgress()
        : GridView.extent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.5,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            children: shopCards,
          );
  }

  Future<Null> readShop() async {
    String url =
        '${MyConstant().domain}/aishoppingmall/getUserWhereChooseType.php?isAdd=true&chooseType=Shop';

    await Dio().get(url).then(
      (value) {
        // print('value::::$value');
        var result = json.decode(value.data);
        int index = 0;

        for (var map in result) {
          UserModel model = UserModel.fromJson(map);

          if (model.nameShop.isNotEmpty) {
            print('NameShop:::: ${model.nameShop}');
            setState(() {
              userModels.add(model);
              shopCards.add(createCard(model, index));
              index++;
            });
          }
        }
      },
    );
  }

  Widget createCard(UserModel userModel, int index) {
    return GestureDetector(
      onTap: () {
        print('index clicked:: $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowShopMenu(
            userModel: userModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    '${MyConstant().domain}/${userModel.urlPicture}'),
              ),
            ),
            MyStyle().showTitleH3(userModel.nameShop),
          ],
        ),
      ),
    );
  }
}
