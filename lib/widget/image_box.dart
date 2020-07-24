import 'dart:io';

import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageBoxContainer extends StatefulWidget {
  @override
  _ImageBoxContainerState createState() => _ImageBoxContainerState();
}

class _ImageBoxContainerState extends State<ImageBoxContainer> {
  File file;

  @override
  Widget build(BuildContext context) {
    return imageBox();
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
}
