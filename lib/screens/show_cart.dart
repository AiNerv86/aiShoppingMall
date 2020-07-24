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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readAllDataFromSQLite();

    for (var model in object) {
      String sumString = model.sum;

      total = total + int.parse(sumString);

      setState(() {
        cartModels = object;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: cartModels.length == 0 ? MyStyle().showProgress() : buildContent(),
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
          ],
        ),
      ),
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
}
