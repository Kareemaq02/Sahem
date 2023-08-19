// ignore_for_file: avoid_print, depend_on_referenced_packages, implementation_imports

import 'package:account/API/map_complaints.dart';
import 'package:account/Repository/mapLinks.dart';
import 'package:account/Screens/Map/makerMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as map2;
import 'package:flutter_map/plugin_api.dart' as a;
import 'package:flutter_map/src/layer/marker_layer.dart' as map;
import 'package:latlong2/latlong.dart';

class FullMap extends StatefulWidget {
  const FullMap({super.key});

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> with TickerProviderStateMixin {

final getUsersComplaint _complaintApi = getUsersComplaint();
 List<ComplaintModel2> _complaints = [];
bool showCards = false; 
map2.MapboxMap? mapboxMap;
final pageController = PageController();
int selectedIndex = 0;
var currentLocation = MapConstants.myLocation;



void _fetchComplaints() async {
  try {
    _complaints = await _complaintApi.getComplaints();
    setState(() {
      _complaints = _complaints;
    });
  } catch (error) {
    print('Failed to fetch complaints: $error');
   
  }
}

void _fetchFilteredComplaints() async {
  try {
    _complaints = await _complaintApi.getComplaints();
    setState(() {
      _complaints = _complaints;

    });
  } catch (error) {
    print('Failed to fetch complaints: $error');
   
  }
}



late final MapController mapController;

  @override
  void initState() {
    super.initState();
      mapController = MapController();
     _fetchComplaints();
  
  }
  


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('View Compalints'),centerTitle: true,backgroundColor: (const Color(0xff223e6d)),
                                     ),
      
      body: Stack(
        children: [
        FlutterMap(  
         mapController: mapController,
            options: a.MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: 11,
              center: currentLocation,
            ), 
              
          
              layers: [
              TileLayerOptions(
                urlTemplate:
                   "https://api.mapbox.com/styles/v1/rubaaburumman/cljqu0bkj010101o44i2a5nhm/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicnViYWFidXJ1bW1hbiIsImEiOiJjbGdwbDMyaXkwNnVvM2ZtcjYxNTJoaHNyIn0.rG3Gztp7P5YwoY5NHtYAHA",
                additionalOptions: {
                  'mapStyleId': MapConstants.style_URL,
                  'accessToken': MapConstants.access_token,
                },
              ),
          MarkerLayerOptions(
           markers: [
           for (int i = 0; i < _complaints.length; i++)
                   map.Marker(
                      height: 40 ,
                      width: 40,
                      point: LatLng(
           _complaints[i].latLng.decLat ,
          _complaints[i].latLng.decLng,
        ) ?? MapConstants.myLocation,
                   
                      builder: (_) {
                        return GestureDetector(
                          onTap: () {
                            pageController.animateToPage(
                              i,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                            selectedIndex = i;
                            currentLocation = LatLng(
           _complaints[i].latLng!.decLat ,
          _complaints[i].latLng!.decLng,
        ) ?? MapConstants.myLocation ??
                                MapConstants.myLocation;
                                
                            _animatedMapMove(currentLocation, 11.5);
                            setState(() {});
                          },
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 500),
                            scale: selectedIndex == i ? 1 : 0.7,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: selectedIndex == i ? 1 : 0.5,
                              child: Image.asset(
                                'assets/map-mark.png',
                              ),
                            ),
                          ),
                        );
                  },
               ),
            ],
            
          ),
        ],
        
       
      ),

      
       Positioned(
            left: 0,
            right: 0,
            bottom: 120,
            height: MediaQuery.of(context).size.height * 0.3,
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (value) {
               selectedIndex = value;
             LatLng(
           _complaints[value].latLng!.decLat ,
          _complaints[value].latLng!.decLng,
        ) ?? MapConstants.myLocation ?? MapConstants.myLocation;
                _animatedMapMove(currentLocation, 11.5);
//                currentLocation = LatLng(
//   MapMarker3[] ?? MapConstants.myLocation.latitude,
//   _complaints[value].decLng ?? MapConstants.myLocation.longitude,
// );
//                _animatedMapMove(LatLng(
//   _complaints[value].decLat ?? MapConstants.myLocation.latitude,
//   _complaints[value].decLng ?? MapConstants.myLocation.longitude,
// ), 11.5);
                setState(() {});
              },
              itemCount: _complaints.length,
              itemBuilder: (_, index) {
                final item = _complaints[index];
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color:  Colors.white,
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                       
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.strComplaintTypeEn.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      item.intComplaintId.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                           
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/street.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          ]));


                    

                        
  }void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
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


         