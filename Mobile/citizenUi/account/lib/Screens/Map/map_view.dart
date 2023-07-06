import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
class FullMap extends StatefulWidget {
  const FullMap({super.key});

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MapWidget(
      key: const ValueKey("mapWidget"),
      resourceOptions: ResourceOptions(accessToken:"sk.eyJ1IjoicnViYWFidXJ1bW1hbiIsImEiOiJjbGdwbHpyODcxMHI4M2VtbWZ2czVpc2R6In0.mdQCAgiz1Wq6KxO9X0YmfQ"),
      onMapCreated: _onMapCreated,
      
        ));
  }
}


         