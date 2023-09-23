import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as b;
import 'package:flutter_map/flutter_map.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Repository/mapLinks.dart';
import 'package:flutter_map/plugin_api.dart' as a;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// ignore_for_file: file_names


class FullMap extends StatefulWidget {
  final double lat;
  final double lng;
  const FullMap({super.key, required this.lat, required this.lng});

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> with TickerProviderStateMixin {
  MapboxMap? mapboxMap;
  final pageController = PageController();
  int selectedIndex = 0;
  var currentLocation = MapConstants.myLocation;
  late final MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterMap(
      mapController: mapController,
      options: a.MapOptions(
        minZoom: 5,
        maxZoom: 25,
        zoom: 15,
        center: b.LatLng(widget.lat, widget.lng),
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: MapConstants.templeteURL,
          additionalOptions: {
            'mapStyleId': MapConstants.style_URL,
            'accessToken': MapConstants.access_token,
          },
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              height: 40,
              width: 40,
              point: b.LatLng(widget.lat, widget.lng),
              builder: (_) {
                return GestureDetector(
                  onTap: () {
                    pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                    selectedIndex = 1;
                   
                    _animatedMapMove(currentLocation, 11.5);
                    setState(() {});
                  },
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 500),
                    scale: selectedIndex == 1 ? 1 : 0.7,
                    child: const AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: 1,
                        child: Icon(
                          Icons.location_on_sharp,
                          color: AppColor.main,
                          size: 70,
                        )),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ));
  }

  void _animatedMapMove(b.LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        b.LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
