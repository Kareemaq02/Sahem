
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';




class MapMarker3{
   String? image;
   String? type;
   String? TimeCreated ;
   LatLng? location;

  MapMarker3({
   
    required this.location,
   
  });

  
}
 

final mapMarkers3 = [
  MapMarker3(
      
      location: LatLng(31.965739324039536, 35.86601959636653),
    ),
     MapMarker3(
      
      location: LatLng(31.95599647432616, 35.875094886485016),
    ),
     MapMarker3(
      
      location: LatLng(31.985991566891197, 35.85133405127682),
    ),
     MapMarker3(
      
      location: LatLng(31.937514619922005, 35.89008684203304),
    ),
     MapMarker3(
      
      location: LatLng(31.971270986585445, 35.89517844957766 ),
    ),

     MapMarker3(
      
      location: LatLng(31.99334465358125, 35.902250126722954),
    ),
     MapMarker3(
      
      location: LatLng(31.94319137136904, 35.8889553736898),
    ),
     MapMarker3(
      
      location: LatLng(31.93382959216409, 35.8388878995011),
    ),
     MapMarker3(
      
      location: LatLng(31.981828620583872, 35.83690782965683),
    ),
 
];
