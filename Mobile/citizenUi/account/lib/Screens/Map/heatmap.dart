// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart' as a;
// import 'package:latlong2/latlong.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


// class MapboxHeatmap extends StatefulWidget {
//   @override
//   _MapboxHeatmapState createState() => _MapboxHeatmapState();
// }

// class _MapboxHeatmapState extends State<MapboxHeatmap> {
//   late a.MapController mapController;
//   final List<LatLng> heatmapData = [
//     LatLng(37.7749, -122.4194),
//     LatLng(37.7749, -122.4194),
//     LatLng(37.7749, -122.4194),
//     LatLng(37.7749, -122.4194),
//     LatLng(37.7749, -122.4194),
//     LatLng(37.7749, -122.4194),
//     LatLng(37.7749, -122.4194),
//     LatLng(37.7749, -122.4194),
//     LatLng(37.7749, -122.4194),
//     LatLng(37.7749, -122.4194),
//     LatLng(37.7749, -122.4194),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     mapController = a.MapController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: a.FlutterMap(
//         options: a.MapOptions(
//           center: LatLng(37.7749, -122.4194),
//           zoom: 13.0,
//         ),
//         layers: [
//           a.TileLayerOptions(
//             urlTemplate:
//                 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=<your_access_token>',
//             additionalOptions: {
//               'accessToken': '<your_access_token>',
//               'id': 'mapbox.mapbox-streets-v8',
//             },
//           ),],
//          j
        
//         mapController: mapController,
//       ),
//     );
//   }
// }
