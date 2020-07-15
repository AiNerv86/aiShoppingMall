import 'dart:io';

import 'package:aishoppingmall/model/user_model.dart';
import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMenuShop extends StatefulWidget {
  @override
  _AddMenuShopState createState() => _AddMenuShopState();
}

class _AddMenuShopState extends State<AddMenuShop> {
  UserModel userModel;
  String nameMenu, descriptionMenu;

  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Menu Item.',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyStyle().showTitleH2('Image Item'),
            imageBox(),
            nameForm(),
            MyStyle().mySizebox(),
            priceForm(),
            MyStyle().mySizebox(),
            descriptionForm(),
            addMenuItem(),
          ],
        ),
      ),
    );
  }

  Widget imageBox() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 36.0,
            ),
            onPressed: () => chooseImage(ImageSource.camera),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            child: file == null
                ? Image.asset(MyConstant().bgImagePicker)
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36.0,
            ),
            onPressed: () => chooseImage(ImageSource.gallery),
          )
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

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: TextField(
              onChanged: (value) => nameMenu = value.trim(),
              decoration: InputDecoration(
                labelText: 'Name Menu :',
                prefixIcon: Icon(Icons.account_box),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
  Widget priceForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: TextField(
              onChanged: (value) => nameMenu = value.trim(),
              decoration: InputDecoration(
                labelText: 'Price :',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget descriptionForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: TextField(
              onChanged: (value) => nameMenu = value.trim(),
              decoration: InputDecoration(
                labelText: 'Description :',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget addMenuItem() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        color: MyStyle().primaryColor,
        onPressed: () {},
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'Add Menu Item.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
