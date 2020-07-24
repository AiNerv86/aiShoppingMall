import 'package:aishoppingmall/model/user_model.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:aishoppingmall/widget/about_shop.dart';
import 'package:aishoppingmall/widget/show_menu_item.dart';
import 'package:flutter/material.dart';

class ShowShopMenu extends StatefulWidget {
  final UserModel userModel;
  ShowShopMenu({Key key, this.userModel}) : super(key: key);
  @override
  _ShowShopMenuState createState() => _ShowShopMenuState();
}

class _ShowShopMenuState extends State<ShowShopMenu> {
  UserModel userModel;

  List<Widget> listsWidget = List();
  int indexPage = 0;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;

    listsWidget.add(AboutShop(
      userModel: userModel,
    ));
    listsWidget.add(ShowMenuItem(
      userModel: userModel,
    ));
  }

  BottomNavigationBarItem aboutShopNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.restaurant),
      title: Text('About Shop.'),
    );
  }

  BottomNavigationBarItem showMenuItemNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_menu),
      title: Text('List Menu.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          MyStyle().iconShowCart(context),
        ],
        title: Text(userModel.nameShop),
      ),
      body: listsWidget.length == 0
          ? MyStyle().showProgress()
          : listsWidget[indexPage],
      bottomNavigationBar: showBottomNavigationBar(),
    );
  }

  BottomNavigationBar showBottomNavigationBar() => BottomNavigationBar(
        backgroundColor: Colors.lightGreen,
        selectedItemColor: Colors.white,
        currentIndex: indexPage,
        items: <BottomNavigationBarItem>[
          aboutShopNav(),
          showMenuItemNav(),
        ],
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
      );
}
