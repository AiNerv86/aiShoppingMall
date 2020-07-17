import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

File file;

Widget imageBox(var _width, var _height, String imagePath) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () => chooseImage(ImageSource.camera),
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          width: _width,
          height: _height,
          child: file == null
              ? Image.network(
                  imagePath,
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

    // setState(() {
    //   file = File(object.path);
    // });
  } catch (e) {}
}
