import 'package:aishoppingmall/utility/my_style.dart';
import 'package:aishoppingmall/utility/signout_process.dart';
import 'package:aishoppingmall/widget/show_list_shop.dart';
import 'package:aishoppingmall/widget/show_status_order.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String nameUser;

  Widget currentWidget;

  @override
  void initState() {
    super.initState();
    currentWidget = ShowListShop();
    findUser();
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
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showHead(),
                listShop(),
                listOrder(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                signOutMenu(),
              ],
            ),
          ],
        ),
      );

  ListTile listShop() {
    return ListTile(
      leading: Icon(Icons.home),
      title: Text('Show Shops'),
      subtitle: Text('Near Me.'),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = ShowListShop();
        });
      },
    );
  }

  ListTile listOrder() {
    return ListTile(
      leading: Icon(Icons.restaurant_menu),
      title: Text('Show Order'),
      subtitle: Text('Order status'),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = ShowStatusOrder();
        });
      },
    );
  }

  Widget signOutMenu() {
    return Container(
      decoration: BoxDecoration(color: Colors.orange.shade700),
      child: ListTile(
        leading: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        title: Text(
          'Sign Out.',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'back to Home',
          style: TextStyle(color: Colors.white),
        ),
        onTap: () => signOutProcess(context),
      ),
    );
  }

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration('user.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(
        nameUser == null ? 'Name Login' : nameUser,
        style:
            TextStyle(color: MyStyle().darkColor, fontWeight: FontWeight.bold),
      ),
      accountEmail: Text('Login'),
    );
  }
}
