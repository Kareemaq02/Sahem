// ignore_for_file: use_build_context_synchronously, avoid_types_as_parameter_names, use_function_type_syntax_for_parameters, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled. Please enable the services'),
        ),
      );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        ),
      );
      return false;
    }
    return true;
  }

  static Future<void> getCurrentPosition(Function(Position),BuildContext context, onPositionReceived) async {
    final hasPermission = await handleLocationPermission(onPositionReceived.context);

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      onPositionReceived(position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  static Future<void> getAddressFromLatLng(
      double latitude, double longitude, Function(String) onAddressReceived) async {
    await placemarkFromCoordinates(latitude, longitude).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      onAddressReceived(
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}',
      );
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
