import 'package:aishoppingmall/model/cart_model.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:aishoppingmall/utility/sqlite_helper.dart';
import 'package:flutter/material.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<CartModel> cartModels = List();
  int total = 0;
  bool status = true;

  @override
  void initState() {
    super.initState();
    readSQLite();
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
            buildClearCart()
          ],
        ),
      ),
    );
  }

  Widget buildClearCart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton.icon(
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
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: MyStyle().showTitleH3('items'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3('Price'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3('Amount'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH3('Sum'),
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
              child: Text(cartModels[index].price),
            ),
            Expanded(
              flex: 1,
              child: Text(cartModels[index].amount),
            ),
            Expanded(
              child: Text(cartModels[index].sum),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () async {
                  int id = cartModels[index].id;
                  String sum = cartModels[index].sum;

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
}
