import 'dart:convert';

import 'package:aishoppingmall/model/user_model.dart';
import 'package:aishoppingmall/screens/add_info_shop.dart';
import 'package:aishoppingmall/screens/edit_info_shop.dart';
import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoShop extends StatefulWidget {
  @override
  _InfoShopState createState() => _InfoShopState();
}

class _InfoShopState extends State<InfoShop> {
  UserModel userModel;
  @override
  void initState() {
    super.initState();

    readDataUser();
  }

  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');

    String url =
        '${MyConstant().domain}/aishoppingmall/getUserWhereUserId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) {
      var result = json.decode(value.data);

      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
        });
      }
    });
  }

  void routeToAddInfo() {
    Widget widget = userModel.nameShop.isEmpty ? AddInfoShop() : EditInfoShop();

    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.push(context, materialPageRoute).then(
      (value) => readDataUser(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        userModel == null
            ? MyStyle().showProgress()
            : userModel.nameShop.isEmpty ? showNoData(context) : showListInfo(),
        addAndEditBTN()
      ],
    );
  }

  Widget showListInfo() => Column(
        children: <Widget>[
          MyStyle().showTitleH2('Shop Infomation: ${userModel.nameShop}'),
          showImage(),
          MyStyle().mySizebox(),
          Row(
            children: <Widget>[
              MyStyle().showTitleH2('Shop Address: '),
            ],
          ),
          Row(
            children: <Widget>[
              Text(userModel.address),
            ],
          ),
          MyStyle().mySizebox(),
          showMap(),
        ],
      );

  Container showImage() {
    return Container(
      width: 200.0,
      height: 200.0,
      child: Image.network('${MyConstant().domain}/${userModel.urlPicture}'),
    );
  }

  Widget showMap() {
    double lat = double.parse(userModel.lat);
    double lng = double.parse(userModel.lng);

    LatLng latLng = LatLng(lat, lng);
    CameraPosition position = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );

    return Expanded(
      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: shopMarker(),
      ),
    );
  }

  Set<Marker> shopMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myShop'),
        position:
            LatLng(double.parse(userModel.lat), double.parse(userModel.lng)),
        infoWindow: InfoWindow(
          title: 'myShop',
          snippet: 'latitude: ${userModel.lat}, longitude: ${userModel.lng}',
        ),
      )
    ].toSet();
  }

  Widget showNoData(BuildContext context) {
    return MyStyle().titleCenter(
        'Not Found Data... \nPlease fill your infomation shop.', context);
  }

  Row addAndEditBTN() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () => routeToAddInfo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
