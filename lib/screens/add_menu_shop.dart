import 'dart:io';
import 'dart:math';

import 'package:aishoppingmall/model/user_model.dart';
import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:aishoppingmall/utility/normal_doalog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMenuShop extends StatefulWidget {
  @override
  _AddMenuShopState createState() => _AddMenuShopState();
}

class _AddMenuShopState extends State<AddMenuShop> {
  UserModel userModel;
  String nameMenu, price, descriptionMenu;

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

  Widget nameForm() => Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextField(
          onChanged: (value) => nameMenu = value.trim(),
          decoration: InputDecoration(
            labelText: 'Name Menu :',
            prefixIcon: Icon(Icons.account_box),
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget priceForm() => Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) => price = value.trim(),
          decoration: InputDecoration(
            labelText: 'Price :',
            prefixIcon: Icon(Icons.attach_money),
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget descriptionForm() => Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextField(
          onChanged: (value) => descriptionMenu = value.trim(),
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Description :',
            prefixIcon: Icon(Icons.description),
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget addMenuItem() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        color: MyStyle().primaryColor,
        onPressed: () {
          if (file == null) {
            normalDialog(context,
                'Please choose image By take a photo or select a gallery.');
          } else if (nameMenu == null ||
              nameMenu.isEmpty ||
              price == null ||
              price.isEmpty ||
              descriptionMenu == null ||
              descriptionMenu.isEmpty) {
            normalDialog(context, 'Please fullfill all info.');
          } else {
            uploadFoodAndInsertData();
          }
        },
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

  Future<Null> uploadFoodAndInsertData() async {
    String urlUpload = '${MyConstant().domain}/aishoppingmall/saveFood.php';

    Random random = Random();
    int i = random.nextInt(1000000);
    String nameFile = 'food$i.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);

      await Dio().post(urlUpload, data: formData).then((value) async {
        String urlPathImage = '/aishoppingmall/Food/$nameFile';
        print('urlPathImage = ${MyConstant().domain}$urlPathImage');

        SharedPreferences preferences = await SharedPreferences.getInstance();
        String idShop = preferences.getString('id');

        String urlInsertData =
            '${MyConstant().domain}/aishoppingmall/addFood.php?isAdd=true&idShop=$idShop&nameFood=$nameMenu&pathImage=$urlPathImage&price=$price&detail=$descriptionMenu';
        await Dio().get(urlInsertData).then((value) {
          String valueToString = value.toString().trim();

          if (valueToString == 'true') {
            Navigator.pop(context);
          } else {}
        });
      });
    } catch (e) {}
  }
}
