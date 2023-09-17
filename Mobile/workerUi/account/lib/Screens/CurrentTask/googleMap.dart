import 'package:url_launcher/url_launcher.dart';
// ignore_for_file: deprecated_member_use

// ignore_for_file: file_names



void navigateToGoogleMaps(double currentLat, double currentLng, double destinationLat, double destinationLng) async {
  final url = 'https://www.google.com/maps/dir/?api=1&origin=$currentLat,$currentLng&destination=$destinationLat,$destinationLng';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch Google Maps';
  }
}