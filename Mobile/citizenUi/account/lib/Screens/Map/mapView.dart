import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart' as b;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:account/API/map_complaints.dart';
import 'package:account/Widgets/Bars/appBar.dart';
import 'package:account/Repository/mapLinks.dart';
import 'package:account/Widgets/Bars/bottomNavBar.dart';
import 'package:account/Widgets/MapWidgets/marker.dart';
import 'package:account/Widgets/MapWidgets/mapCard.dart';
import 'package:account/Widgets/MapWidgets/myLocationWidget.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
// ignore_for_file: avoid_print

// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously

class FullMap extends StatefulWidget {
  const FullMap({super.key});

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> with TickerProviderStateMixin {
  //MapboxMap? mapboxMap;
  final pageController = PageController();
  int selectedIndex = 0;
  late final MapController mapController;
  late double _markerSize;
  List<ComplaintModel2> complaints = [];
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('تم تعطيل خدمة الموقع الحالي. الرجاء تفعيل الخدمة')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم رفض أذونات الموقع')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم رفض أذونات الموقع بشكل دائم.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      //  debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      setState(() {});
    }).catchError((e) {
      //debugPrint(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    mapController = MapController();
    _markerSize = 200.0;
    _fetchComplaints();
  }

  Future<void> _fetchComplaints() async {
    getUsersComplaint usersComplaintObj = getUsersComplaint();
    try {
      final List<ComplaintModel2> fetchedComplaints =
          await usersComplaintObj.getComplaints();
      setState(() {
        complaints = fetchedComplaints;
      });
    } catch (error) {
      print('Error fetching complaints: $error');
    }
  }

  List<b.LatLng> buildMarkerLocations() {
    return complaints
        .map((complaint) =>
            b.LatLng(complaint.latLng.decLat, complaint.latLng.decLng))
        .toList();
  }

  void _updateMarkerSize(var zoom) {
    final markerSizeTween = Tween<double>(
      end: 40.0,
      begin: 40.0,
    );

    setState(() {
      _markerSize = markerSizeTween.transform((zoom - 15) / 10.0);
    });
  }

  List<b.LatLng> markerLocations = [
    b.LatLng(31.97843632996766, 35.841184352214725),
    b.LatLng(31.983572397437857, 35.83794951164986),
    b.LatLng(32.001625414747444, 35.821641682069675),
    b.LatLng(31.957505727610943, 35.82867979799376),
    b.LatLng(31.95138845374212, 35.850480791222),
    b.LatLng(32.065174697792365, 35.88038905102139),
    b.LatLng(32.016864736899166, 35.97428781713044),
    b.LatLng(32.09470105626992, 35.96776468529836),
    b.LatLng(32.03811261913162, 35.974974462586445),
    b.LatLng(32.0666294215345, 35.955061744362226),
    b.LatLng(31.97843632996766, 35.841184352214725),
    b.LatLng(31.949392102408837, 35.66974543840278),
    b.LatLng(31.845924404519707, 35.87126799133567),
    b.LatLng(31.831202772105296, 35.66992164287437),
    b.LatLng(31.97843632996766, 35.841184352214725),
    b.LatLng(31.939822118246564, 35.93438642676467),
    b.LatLng(31.956094613166286, 35.92756946460224),
    b.LatLng(31.934368093257547, 35.919691260853014),
    b.LatLng(31.927681976801534, 35.931789930896464),
    b.LatLng(31.919323647502658, 35.89577528518574),
    b.LatLng(31.988794078410276, 35.895212556346515),
    b.LatLng(31.97066101036198, 35.91707996576524),
    b.LatLng(31.948245997893004, 35.91399446229071),
    b.LatLng(31.941700436945087, 35.903195200129844),
  ];

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // floatingActionButton: const CustomActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavBar1(1),
        appBar: myAppBar(context, "الخريطة", false, screenWidth * 0.6),
        body: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                plugins: [
                  MarkerClusterPlugin(),
                ],
                minZoom: 5,
                maxZoom: 25,
                interactiveFlags:
                    InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                zoom: 10.9,
                onPositionChanged: (position, hasGesture) {
                  if (hasGesture) {
                    _updateMarkerSize(position.zoom);
                  }
                },
                center: _currentPosition != null
                    ? b.LatLng(
                        _currentPosition!.latitude, _currentPosition!.longitude)
                    : b.LatLng(31.961030, 35.881216),
              ),
              layers: [
                TileLayerOptions(
                  //urlTemplate: MapConstants.templeteURL,
                  urlTemplate: MapConstants.templeteURL,
                  additionalOptions: {
                    'mapStyleId': MapConstants.style_URL,
                    'accessToken': MapConstants.access_token,
                  },
                ),

                // MarkerLayerOptions(markers: [
                //   if (currentLocation != null)
                //     Marker(
                //       width: 40.0,
                //       height: 40.0,
                //       point: currentLocation!,
                //       builder: (ctx) => Container(
                //         child: Icon(
                //           Icons.panorama_photosphere_select_outlined,
                //           size: 40.0,
                //           color: Colors.blue, // Customize the icon's color
                //         ),
                //       ),
                //     ),
                // ]),

                MarkerClusterLayerOptions(
                  maxClusterRadius: 120,
                  markers: markerLocations.asMap().entries.map((entry) {
                    int index = entry.key;
                    b.LatLng location = entry.value;
                    return Marker(
                      width: _markerSize,
                      height: _markerSize,
                      point: location,
                      builder: (context) {
                        return InkWell(
                          child: markerWidegt(index),
                          onTap: () => mapCard(context),
                        );
                      },
                    );
                  }).toList(),
                  builder: (BuildContext context, List<Marker> markers) {
                    int clusterSize = markers.length;

                    return clusterWidget(clusterSize);
                  },
                ),
              ],
            ),
            filterIcon(context),
            myLocationWidegt(() {
              if (_currentPosition != null) {
                _animatedMapMove(
                  b.LatLng(
                      _currentPosition!.latitude, _currentPosition!.longitude),
                  16.0,
                );
              } else {}
            }),
          ],
        ));
  }

  void _animatedMapMove(b.LatLng destLocation, double destZoom) {
    if (_currentPosition != null) {
      final latTween = Tween<double>(
          begin: mapController.center.latitude, end: destLocation.latitude);
      final lngTween = Tween<double>(
          begin: mapController.center.longitude, end: destLocation.longitude);
      final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

      var controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      );

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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Unable to move to current location. Location not available.'),
        ),
      );
    }
  }
}
