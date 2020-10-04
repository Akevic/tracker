import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';
import '../services/socket_service.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

LocationService locationService = LocationService();

class _HomePageState extends State<HomePage> {
  SocketService socketService = injector.get<SocketService>();
  @override
  void initState() {
    socketService.createSocketConnection();
    print('inited');
    super.initState();
  }

  @override
  void dispose() {
    if (locationService.locationSubscription != null) {
      locationService.locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Di je Biscan'),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.satellite,
        initialCameraPosition: locationService.initialLocation,
        zoomControlsEnabled: false,
        markers: Set.of(
            (locationService.marker != null) ? [locationService.marker] : []),
        circles: Set.of(
            (locationService.circle != null) ? [locationService.circle] : []),
        onMapCreated: (GoogleMapController controller) {
          locationService.controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            locationService.getCurrentLocation(context, this);
          }),
    );
  }
}
