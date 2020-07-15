import 'package:aishoppingmall/screens/add_info_shop.dart';
import 'package:aishoppingmall/screens/add_menu_shop.dart';
import 'package:flutter/material.dart';

class ListMenuShop extends StatefulWidget {
  @override
  _ListMenuShopState createState() => _ListMenuShopState();
}

class _ListMenuShopState extends State<ListMenuShop> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text('Show List Menu.'),
        addMenuButton(),
      ],
    );
  }

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

                    Navigator.push(context, route);
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );
}
