import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Colors.orange.shade900;
  Color primaryColor = Colors.blue.shade400;

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  SizedBox mySizebox() => SizedBox(
        width: 8.0,
        height: 16.0,
      );

  Text showTitle(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 24.0,
            color: Colors.orange.shade900,
            fontWeight: FontWeight.bold),
      );

  Text showTitleH2(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 18.0,
            color: Colors.orange.shade900,
            fontWeight: FontWeight.bold),
      );

  Widget titleCenter(String string, BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          string,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Container showLogo() {
    return Container(
      width: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  BoxDecoration myBoxDecoration(String namePic) {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/$namePic'), fit: BoxFit.cover));
  }

  MyStyle();
}
