import 'dart:io';

import 'package:aishoppingmall/model/food_model.dart';
import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:aishoppingmall/utility/normal_doalog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditMenuShop extends StatefulWidget {
  final FoodModel foodModel;
  EditMenuShop({Key key, this.foodModel}) : super(key: key);

  @override
  _EditMenuShopState createState() => _EditMenuShopState();
}

class _EditMenuShopState extends State<EditMenuShop> {
  FoodModel foodModel;
  File file;
  String name, price, detail, pathImage;

  @override
  void initState() {
    super.initState();

    foodModel = widget.foodModel;
    name = foodModel.nameFood;
    price = foodModel.price;
    detail = foodModel.detail;
    pathImage = foodModel.pathFood;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item ${foodModel.nameFood}.'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            nameFood(),
            priceFood(),
            detailFood(),
            imageBox(),
            updateMenuItem(),
            MyStyle().mySizebox(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton updateMenuItem() {
    return FloatingActionButton(
      onPressed: () {
        if (name.isEmpty || price.isEmpty || detail.isEmpty) {
          normalDialog(context, 'Please fullfill all Info.');
        } else {
          confirmEdit();
        }
      },
      child: Icon(Icons.cloud_upload),
    );
  }

  Future<Null> confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Are you sure to edit this item ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  editValueOnMySQL();
                },
                icon: Icon(Icons.check),
                label: Text('Confirm'),
              ),
              FlatButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.cancel),
                label: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> editValueOnMySQL() async {
    String id = foodModel.id;
    String url =
        '${MyConstant().domain}/aishoppingmall/editFoodWhereId.php?isAdd=true&id=$id&NameFood=$name&PathImage=$pathImage&Price=$price&Detail=$detail';
    await Dio().get(url).then((value) {
      print(id);
      print(name);
      print(pathImage);
      print(price);
      print(detail);
      print(value.toString().trim());
      if (value.toString().trim() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'Error, Please try again.');
      }
    });
  }

  Widget nameFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 16.0),
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                initialValue: foodModel.nameFood,
                decoration: InputDecoration(
                  labelText: 'Name:',
                  border: OutlineInputBorder(),
                ),
              )),
        ],
      );
  Widget priceFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 16.0),
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                keyboardType: TextInputType.number,
                initialValue: foodModel.price,
                decoration: InputDecoration(
                  labelText: 'Price:',
                  border: OutlineInputBorder(),
                ),
              )),
        ],
      );

  Widget detailFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 16.0),
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                initialValue: foodModel.detail,
                decoration: InputDecoration(
                  labelText: 'Detail:',
                  border: OutlineInputBorder(),
                ),
              )),
        ],
      );

  Widget imageBox() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseImage(ImageSource.camera),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.width * 0.75,
            child: file == null
                ? Image.network(
                    '${MyConstant().domain}${foodModel.pathFood}',
                    fit: BoxFit.cover,
                  )
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseImage(ImageSource.gallery),
          ),
        ],
      );

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      // ignore: deprecated_member_use
      var object = await ImagePicker().getImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );

      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }
}
