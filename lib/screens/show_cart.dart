import 'package:aishoppingmall/model/cart_model.dart';
import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:aishoppingmall/utility/normal_doalog.dart';
import 'package:aishoppingmall/utility/sqlite_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<CartModel> cartModels = List();
  int total = 0;
  bool status = true;

  String idUser;

  bool statusOrder = false;

  @override
  void initState() {
    super.initState();
    // readSQLite();

    findUser();
  }

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
        readSQLite();
      } else {}

      print('response = $response');
    }
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readAllDataFromSQLite();

    print('object length ==> ${object.length}');

    total = 0;

    if (object.length != 0) {
      for (var model in object) {
        String sumString = model.sum;

        setState(() {
          status = false;
          cartModels = object;

          total = total + int.parse(sumString);
        });
      }
    } else {
      setState(() {
        status = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: status
          ? Center(
              child: Text('Cart is Empty'),
            )
          : cartModels.length == 0 ? MyStyle().showProgress() : buildContent(),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildNameShop(),
            buildHeadTitles(),
            buildListFood(),
            Divider(),
            buildTotal(),
            buildClearCart(),
            buildOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget buildClearCart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          child: RaisedButton.icon(
              color: MyStyle().darkColor,
              onPressed: () {
                confirmDeleteAllData();
              },
              icon: Icon(
                Icons.delete_sweep,
                color: Colors.white,
              ),
              label: Text(
                'Clear Cart.',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget buildOrderButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          child: RaisedButton.icon(
              color: MyStyle().primaryColor,
              onPressed: () {
                orderThead();
              },
              icon: Icon(
                Icons.fastfood,
                color: Colors.white,
              ),
              label: Text(
                'Order',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget buildTotal() => Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MyStyle().showTitleH2('Total = '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH2(total.toString()),
          ),
        ],
      );

  Widget buildNameShop() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              MyStyle().showTitleH2('Shop: ${cartModels[0].nameShop}'),
            ],
          ),
          Row(
            children: <Widget>[
              MyStyle().showTitleH3('Distance: ${cartModels[0].distance} Km.'),
            ],
          ),
          Row(
            children: <Widget>[
              MyStyle()
                  .showTitleH3('Transport: ${cartModels[0].transport} Bath.'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeadTitles() {
    return Container(
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(color: Colors.grey),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: MyStyle().showTitleH3White('items'),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MyStyle().showTitleH3White('Price'),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MyStyle().showTitleH3White('Amount'),
              ],
            ),
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
          Expanded(
            flex: 1,
            child: MyStyle().mySizebox(),
          ),
        ],
      ),
    );
  }

  Widget buildListFood() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: cartModels.length,
        itemBuilder: (context, index) => Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text(cartModels[index].nameFood),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(cartModels[index].price),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(cartModels[index].amount),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(cartModels[index].sum),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () async {
                  int id = cartModels[index].id;

                  print('Clicked id: $id');

                  await SQLiteHelper().deleteDataWhereId(id).then((value) {
                    print('success delete id: $id');

                    readSQLite();
                  });
                },
              ),
            ),
          ],
        ),
      );

  Future<Null> confirmDeleteAllData() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Are you clear cart?'),
          ],
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);

                  await SQLiteHelper().deleteAllData().then((value) {
                    readSQLite();
                  });
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Text('Confirm.'),
              ),
              RaisedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text('Cancel.'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> orderThead() async {
    DateTime dateTime = DateTime.now();
    // print(dateTime.toString());
    String orderDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    String idShop = cartModels[0].idShop;
    String nameShop = cartModels[0].nameShop;
    String distance = cartModels[0].distance;
    String transport = cartModels[0].transport;

    List<String> idFoods = List();
    List<String> nameFoods = List();
    List<String> prices = List();
    List<String> amounts = List();
    List<String> sums = List();

    for (var model in cartModels) {
      idFoods.add(model.idFood);
      nameFoods.add(model.nameFood);
      prices.add(model.price);
      amounts.add(model.amount);
      sums.add(model.sum);
    }

    String idFood = idFoods.toString();
    String nameFood = nameFoods.toString();
    String price = prices.toString();
    String amount = amounts.toString();
    String sum = sums.toString();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idUser = preferences.getString('id');
    String nameUser = preferences.getString('name');

    // print(
    // 'orderDateTime = $orderDateTime, idUser = $idUser, nameUser = $nameUser, idShop = $idShop, nameShop = $nameShop, distance = $distance, transport = $transport');
    // print(
    //     'idFood = $idFood, nameFood = $nameFood, price = $price, amount = $amount, sum = $sum');

    String url =
        '${MyConstant().domain}/aishoppingmall/addOrder.php?isAdd=true&OrderDateTime=$orderDateTime&idUser=$idUser&NameUser=$nameUser&idShop=$idShop&NameShop=$nameShop&Distance=$distance&Transport=$transport&idFood=$idFood&NameFood=$nameFood&Price=$price&Amount=$amount&Sum=$sum&idRider=none&Status=UserOrder';

    await Dio().get(url).then((value) {
      print('value = ${value.toString()}');

      String valueToString = value.toString().trim();

      if (valueToString == 'true') {
        clearAllSQLite();
      } else {
        normalDialog(context, 'Can not order. Please try again.');
      }
    });
  }

  Future<Null> clearAllSQLite() async {
    Toast.show(
      'Order Completed.',
      context,
      duration: Toast.LENGTH_LONG,
    );
    await SQLiteHelper().deleteAllData().then((value) {
      readSQLite();
    });
  }
}
