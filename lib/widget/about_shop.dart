import 'package:aishoppingmall/model/user_model.dart';
import 'package:aishoppingmall/utility/my_api.dart';
import 'package:aishoppingmall/utility/my_constant.dart';
import 'package:aishoppingmall/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class AboutShop extends StatefulWidget {
  final UserModel userModel;

  AboutShop({Key key, this.userModel}) : super(key: key);
  @override
  _AboutShopState createState() => _AboutShopState();
}

class _AboutShopState extends State<AboutShop> {
  UserModel userModel;

  double lat1, lng1, lat2, lng2, distance;

  String distanceString;

  int transport;

  CameraPosition cameraPosition;

  @override
  void initState() {
    super.initState();

    findLat1Lng1();

    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.75,
                child: Image.network(
                  '${MyConstant().domain}/${userModel.urlPicture}',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.orange.shade900,
            ),
            title: Text(userModel.address),
          ),
          ListTile(
            leading: Icon(
              Icons.phone_iphone,
              color: Colors.orange.shade900,
            ),
            title: Text(userModel.phone),
          ),
          ListTile(
            leading: Icon(
              Icons.directions_bike,
              color: Colors.orange.shade900,
            ),
            title: Text(distance == null ? '' : '$distanceString Km.'),
          ),
          ListTile(
            leading: Icon(
              Icons.transfer_within_a_station,
              color: Colors.orange.shade900,
            ),
            title: Text(transport == null ? '' : '$transport Bath.'),
          ),
          showMap(),
        ],
      ),
    );
  }

  Container showMap() {
    if (lat1 != null) {
      LatLng latLng1 = LatLng(lat1, lng1);
      cameraPosition = CameraPosition(
        target: latLng1,
        zoom: 16.0,
      );
    }

    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 16.0, top: 10.0, bottom: 10.0),
      // color: Colors.grey,
      height: 250.0,
      child: lat1 == null
          ? MyStyle().showProgress()
          : GoogleMap(
              initialCameraPosition: cameraPosition,
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: allMarker(),
            ),
    );
  }

  Set<Marker> allMarker() {
    return <Marker>[
      myMarker(),
      shopMarker(),
    ].toSet();
  }

  Marker myMarker() {
    return Marker(
      markerId: MarkerId('ME'),
      position: LatLng(lat1, lng1),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
        title: "I'm Here.",
        snippet: 'latitude: $lat1, longitude: $lng1',
      ),
    );
  }

  Marker shopMarker() {
    return Marker(
      markerId: MarkerId(userModel.nameShop),
      position: LatLng(lat2, lng2),
      icon: BitmapDescriptor.defaultMarkerWithHue(150.0),
      infoWindow: InfoWindow(
        title: userModel.nameShop,
        snippet: 'latitude: $lat2, longitude: $lng2',
      ),
    );
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();

    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Future<Null> findLat1Lng1() async {
    LocationData locationData = await findLocationData();

    setState(() {
      lat1 = locationData.latitude;
      lng1 = locationData.longitude;
      lat2 = double.parse(userModel.lat);
      lng2 = double.parse(userModel.lng);

      print('lat1: $lat1 , lng1:$lng1, lat2: $lat2 , lng2:$lng2');

      distance = MyAPI().calculateDistance(lat1, lng1, lat2, lng2);
      print('distance: $distance');

      var distanceFormat = NumberFormat('#0.0#', 'en_US');
      distanceString = distanceFormat.format(distance);

      transport = MyAPI().calculateTransport(distance);
      print('transport cost: $transport');
    });
  }
}
