import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
  StreamSubscription locationSubscription;
  Location locationTracker = Location();
  GoogleMapController controller;
  Marker marker;
  Circle circle;

  final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker(ctx) async {
    ByteData byteData =
        await DefaultAssetBundle.of(ctx).load("images/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(
      LocationData newLocalData, Uint8List imageData, object) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    object.setState(() {
      marker = Marker(
        markerId: MarkerId("home"),
        position: latlng,
        rotation: newLocalData.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData),
      );
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  Future<List> getLocation() async {
    var location = await locationTracker.getLocation();
    return [
      location.latitude,
      location.longitude,
    ];
  }

  // * context, this
  void getCurrentLocation(ctx, object) async {
    try {
      Uint8List imageData = await getMarker(ctx);
      // * get location from socket
      var location = await locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData, object);

      if (locationSubscription != null) {
        locationSubscription.cancel();
      }

      locationSubscription =
          locationTracker.onLocationChanged.listen((newLocalData) {
        if (controller != null) {
          controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData, object);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }
}
