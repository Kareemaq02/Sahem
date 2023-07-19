// ignore_for_file: depend_on_referenced_packages, constant_identifier_names, unused_element

import 'dart:convert';


import 'package:account/API/get_complaints_ByLocation.dart';
import 'package:account/Screens/Map/map_view.dart';
import 'package:account/Screens/Profile/profile.dart';
import 'package:account/Widgets/likeButton.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../API/login_request.dart';
import '../../API/view_complaint_request.dart';
import '../File complaint/complaints1.dart';
import '../View complaints/complaints_list.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Map/map.dart'; 
import 'package:http/http.dart' as http;

class XDPublicFeed1 extends StatefulWidget {
  const XDPublicFeed1({Key? key}) : super(key: key);

  @override
  _XDPublicFeed1State createState() => _XDPublicFeed1State();
}

class _XDPublicFeed1State extends State<XDPublicFeed1> {
  
  late List<ComplaintModel> complaints;
  late var Address;

  @override
  void initState() {
  // _getCurrentPosition();
   // getComplaintsByLocation(31.961899172907753, 35.86508730906701 );
   super.initState();
  
   // fetchComplaints(_currentPosition!.latitude,_currentPosition!.longitude);
    
   
  }

// Future<List<dynamic>> fetchComplaints(double latitude, double longitude) async {
//   final response = await http.post(
//     Uri.parse('https://10.0.2.2:5000/api/complaints/location'),
//     headers: {
//       'Authorization': 'Bearer $token2',
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode({
//       'decLat': latitude,
//       'decLng': longitude,
//     }),
//   );

//   if (response.statusCode == 200) {
//     return jsonDecode(response.body.toString());
//   } else {
//     throw Exception('Failed to fetch complaints');
//   }
// }




  String? currentAddress=" ";
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
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
     
    }).catchError((e) {
      debugPrint(e);
    });
    
  }

   Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
         
         // Page title 
          Pinned.fromPins(
            Pin(start: 18.0, end: 27.0),
            Pin(size: 34.0, start: 56.0),
            child:
                // Adobe XD layer: 'Header' (group)
                Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(size: 236.0, start: 0.0),
                  Pin(start: 0.0, end: 0.0),
                  child: const Text(
                    'Public Complaints',
                    style: TextStyle(
                      fontFamily: 'Euclid Circular A',
                      fontSize: 27,
                      color: Color(0xff6f407d),
                      fontWeight: FontWeight.w700,
                    ),
                    softWrap: false,
                  ),
                ),
                Align(
                  alignment: const Alignment(1.0, 0.3),
                  child: SizedBox(
                    width: 41.0,
                    height: 14.0,
                    child:
                        // Adobe XD layer: 'Filter' (group)
                        Stack(
                      children: <Widget>[
                        Pinned.fromPins(
                          Pin(size: 26.0, end: 0.0),
                          Pin(start: 0.0, end: 0.0),
                          child: const Text(
                            'Filter',
                            style: TextStyle(
                              fontFamily: 'Euclid Circular A',
                              fontSize: 11,
                              color: Color(0xff92a5c6),
                              height: 1,
                            ),
                            textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            softWrap: false,
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(size: 9.2, start: 0.0),
                          Pin(start: 3.3, end: 2.5),
                          child:
                              // Adobe XD layer: 'Icon feather-filter' (shape)
                              SvgPicture.string(
                            _svg_sn4rg,
                            allowDrawingOutsideViewBox: true,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
         
         //complaint Post
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 65.0,left: 10,bottom: 140),
            child: FutureBuilder<List<dynamic>>(
            future: getComplaintsByLocation(31.961899172907753, 35.86508730906701),
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
            var data = snapshot.data;
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (BuildContext context, int index) {
             
             
                return post1(context,
                intComplaintId:data![index]['intComplaintId'].toString(),
                strStatus:data![index]['strStatus'].toString(),
                strUserName:data![index]['strUserName'].toString(),
                dtmDateCreated: data![index]['dtmDateCreated'].toString(),
                 intVotersCount: data![index]['intVotersCount'],
                 strComplaintTypeEn: data![index]['strComplaintTypeEn'].toString(),
                 strComment: data![index]['StrComment'].toString(),
                address: "amman",
                
                
                );
              
              },
            ); // Render the widget if the API call is successful
                } else {
            return const Text('No complaints found'); // Render an error message if the API call returns an empty list
                }
              } else {
                return const CircularProgressIndicator(); // Show a progress indicator while the API call is in progress
              }
            },
          ),
          ),
        ),
         


         //bottom navigator
          Pinned.fromPins(
            Pin(start: 0.0, end: 0.0),
            Pin(size: 172.0, end: 0.0),
            child:
                // Adobe XD layer: 'NavBar' (group)
                Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(startFraction: 0.0, endFraction: 0.1201),
                  child: Transform.rotate(
                    angle: 3.1416,
                    child:
                        // Adobe XD layer: 'Gradiant' (shape)
                        Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, 0.978),
                          end: Alignment(0.0, -0.987),
                          colors: [
                            Color(0x00ffffff),
                            Color(0xe4828282)
                          ],
                          stops: [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 46.0, 0.0, 0.0),
                  child:
                      // Adobe XD layer: 'Bar' (group)
                      Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: 75.0,
                          height: 74.0,
                          child:
                              // Adobe XD layer: 'Button' (group)
                              Stack(
                            children: <Widget>[
                              // Adobe XD layer: 'ButtonFill' (shape)
                              Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment(0.0, -1.0),
                                    end: Alignment(0.0, 1.0),
                                    colors: [
                                      Color(0xff2a0340),
                                      Color(0xff223e6d)
                                    ],
                                    stops: [0.0, 1.0],
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.elliptical(9999.0, 9999.0)),
                                  border: Border.all(
                                      width: 4.0,
                                      color: const Color(0xffffffff)),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x29000000),
                                      offset: Offset(0, 3),
                                      blurRadius: 40,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(start: 0.0, end: 0.0),
                        Pin(size: 77.0, end: 0.0),
                        child:
                            // Adobe XD layer: 'BottomBar' (shape)
                            SvgPicture.string(
                          _svg_qn9i8,
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 26.1, end: 28.7),
                  Pin(size: 35.1, end: 18.6),
                  child:
                      // Adobe XD layer: 'Profile' (group)
                      PageLink(
                    links: [
                      PageLinkInfo(
                        duration: 0,
                        pageBuilder: () => const XDProfile(),
                      ),
                    ],
                    child: Stack(
                      children: <Widget>[
                        Pinned.fromPins(
                          Pin(start: 2.0, end: 2.0),
                          Pin(size: 9.0, end: 0.0),
                          child:
                              // Adobe XD layer: 'Label' (text)
                              const Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Euclid Circular A',
                              fontSize: 7,
                              color: Color(0xffbbc7db),
                              fontWeight: FontWeight.w700,
                              height: 0.7142857142857143,
                            ),
                            textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            softWrap: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 9.0),
                          child: SizedBox.expand(
                              child:
                                  // Adobe XD layer: 'Profile' (shape)
                                  SvgPicture.string(
                            _svg_n24q1a,
                            allowDrawingOutsideViewBox: true,
                            fit: BoxFit.fill,
                          )),
                        ),
                      ],
                    ),
                  ),
                ),

               //bottom navigator 
                Pinned.fromPins(
                  Pin(size: 39.0, middle: 0.7715),
                  Pin(size: 35.0, end: 18.6),
                  child:
                      // Adobe XD layer: 'Complaints' (group)
                      PageLink(
                    links: [
                      PageLinkInfo(
                        duration: 0,
                        pageBuilder: () => const XDComplaintsList(),
                      ),
                    ],
                    child: Stack(
                      children: <Widget>[
                        Pinned.fromPins(
                          Pin(start: 0.0, end: 0.0),
                          Pin(size: 9.0, end: 0.0),
                          child:
                              // Adobe XD layer: 'Label' (text)
                              const Text(
                            'Complaints',
                            style: TextStyle(
                              fontFamily: 'Euclid Circular A',
                              fontSize: 7,
                              color: Color(0xffbbc7db),
                              fontWeight: FontWeight.w700,
                              height: 0.7142857142857143,
                            ),
                            textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            softWrap: false,
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(start: 6.5, end: 6.5),
                          Pin(size: 26.0, start: 0.0),
                          child:
                              // Adobe XD layer: 'ComplaintsIcon' (shape)
                              SvgPicture.string(
                            _svg_btlkna,
                            allowDrawingOutsideViewBox: true,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0.0, -0.062),
                  child: SizedBox(
                    width: 34.0,
                    height: 31.0,
                    child:
                        // Adobe XD layer: 'FillComplaintIcon' (group)
                        InkWell(
                      onTap: () {
                          
                          Navigator.push(context,MaterialPageRoute(builder: (context) =>  const XDComplaints1()));
                      },             
                      child: Stack(
                        children: <Widget>[
                          Pinned.fromPins(
                            Pin(size: 1.0, middle: 0.5153),
                            Pin(start: 0.0, end: 0.0),
                            child: SvgPicture.string(
                              _svg_xph1jx,
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 0.0, end: 0.0),
                            Pin(size: 1.0, middle: 0.5165),
                            child: SvgPicture.string(
                              _svg_o6ekv6,
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 26.0, middle: 0.2711),
                  Pin(size: 35.0, end: 17.0),
                  child:
                      // Adobe XD layer: 'Map' (group)
                      Stack(
                    children: <Widget>[
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 15.0,
                          height: 9.0,
                          child:
                              // Adobe XD layer: 'Label' (text)
                              Text(
                            'Map',
                            style: TextStyle(
                              fontFamily: 'Euclid Circular A',
                              fontSize: 7,
                              color: Color(0xffbbc7db),
                              fontWeight: FontWeight.w700,
                              height: 0.7142857142857143,
                            ),
                            textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false),
                            softWrap: false,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 9.0),
                        child: SizedBox.expand(
                            child:
                                // Adobe XD layer: 'Map' (shape)
                                PageLink(
                          links: [
                            PageLinkInfo(
                              duration: 0,
                              pageBuilder: () => const FullMap(),
                            ),
                          ],
                          child: SvgPicture.string(
                            _svg_p8s453,
                            allowDrawingOutsideViewBox: true,
                            fit: BoxFit.fill,
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 29.6, start: 34.7),
                  Pin(size: 36.6, end: 17.0),
                  child:
                      // Adobe XD layer: 'Home' (group)
                      Stack(
                    children: <Widget>[
                      Pinned.fromPins(
                        Pin(start: 2.3, end: 2.4),
                        Pin(size: 11.0, end: 0.0),
                        child:
                            // Adobe XD layer: 'Label' (text)
                            const Text(
                          'Home',
                          style: TextStyle(
                            fontFamily: 'Euclid Circular A',
                            fontSize: 9,
                            color: Color(0xff6f407d),
                            fontWeight: FontWeight.w700,
                            height: 0.6666666666666666,
                          ),
                          textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          softWrap: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 11.5),
                        child: SizedBox.expand(
                            child:
                                // Adobe XD layer: 'HomeIcon' (shape)
                                SvgPicture.string(
                          _svg_j1pel9,
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_yrzequ =
    '<svg viewBox="344.0 173.9 25.7 26.6" ><path transform="translate(343.0, 172.91)" d="M 1.00000011920929 27.56344413757324 L 5.67302942276001 27.56344413757324 L 5.67302942276001 11.62537956237793 L 1.00000011920929 11.62537956237793 L 1.00000011920929 27.56344413757324 Z M 26.70166015625 12.95355129241943 C 26.70166015625 11.49256229400635 25.65023040771484 10.29720687866211 24.36514663696289 10.29720687866211 L 16.99344253540039 10.29720687866211 L 18.1032886505127 4.227458477020264 L 18.13833427429199 3.802443742752075 C 18.13833427429199 3.257892608642578 17.93973159790039 2.75318717956543 17.62430191040039 2.394580841064453 L 16.38594818115234 0.9999998211860657 L 8.698816299438477 9.752655982971191 C 8.266561508178711 10.23079776763916 8.009544372558594 10.89488410949707 8.009544372558594 11.62537956237793 L 8.009544372558594 24.90710258483887 C 8.009544372558594 26.36808967590332 9.060976982116699 27.56344413757324 10.34605884552002 27.56344413757324 L 20.86037445068359 27.56344413757324 C 21.83002662658691 27.56344413757324 22.65949058532715 26.89936065673828 23.00996780395508 25.94307708740234 L 26.53810501098633 16.57946395874023 C 26.64324951171875 16.27398300170898 26.70166015625 15.95522212982178 26.70166015625 15.60989761352539 L 26.70166015625 13.07308673858643 L 26.68997764587402 13.05980682373047 L 26.70166015625 12.95355129241943 Z" fill="#ffffff" stroke="#6f407d" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_sn4rg =
    '<svg viewBox="0.0 3.3 9.2 8.3" ><path transform="translate(-3.0, -1.24)" d="M 12.20806789398193 4.5 L 3 4.5 L 6.6832275390625 8.855416297912598 L 6.6832275390625 11.866455078125 L 8.524840354919434 12.78726196289062 L 8.524840354919434 8.855416297912598 L 12.20806789398193 4.5 Z" fill="none" stroke="#92a5c6" stroke-width="1" stroke-linecap="round" stroke-linejoin="round" /></svg>';
const String _svg_h6ri7 =
    '<svg viewBox="29.7 3.7 1.3 4.0" ><path transform="translate(29.67, 3.67)" d="M 0 0 L 0 4 C 0.8047311305999756 3.661223411560059 1.328037977218628 2.873133182525635 1.328037977218628 2 C 1.328037977218628 1.126866698265076 0.8047311305999756 0.3387765288352966 0 0" fill="#575757" fill-opacity="0.4" stroke="none" stroke-width="1" stroke-opacity="0.4" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
const String _svg_kfznuz =
    '<svg viewBox="428.0 17.3 15.3 11.0" ><path transform="translate(428.03, 17.33)" d="M 7.636517524719238 10.96560001373291 C 7.553837299346924 10.96560001373291 7.473147392272949 10.93181037902832 7.415117263793945 10.87290000915527 L 5.417117595672607 8.856900215148926 C 5.355837345123291 8.796520233154297 5.321717262268066 8.712539672851562 5.323517322540283 8.626500129699707 C 5.325307369232178 8.540619850158691 5.363027572631836 8.458290100097656 5.427017211914062 8.400600433349609 C 6.043807506561279 7.878690242767334 6.828487396240234 7.591279983520508 7.636517524719238 7.591279983520508 C 8.444547653198242 7.591279983520508 9.229227066040039 7.878699779510498 9.846017837524414 8.400600433349609 C 9.909987449645996 8.457460403442383 9.947707176208496 8.539790153503418 9.949517250061035 8.626500129699707 C 9.95131778717041 8.712539672851562 9.917197227478027 8.796520233154297 9.855916976928711 8.856900215148926 L 7.857917308807373 10.87290000915527 C 7.799037456512451 10.93268013000488 7.720407485961914 10.96560001373291 7.636517524719238 10.96560001373291 Z M 11.1447172164917 7.427700042724609 C 11.06472778320312 7.427700042724609 10.9886474609375 7.397650241851807 10.93051719665527 7.343100070953369 C 10.02612781524658 6.524199962615967 8.856297492980957 6.073200225830078 7.636517524719238 6.073200225830078 C 6.417577266693115 6.073200225830078 5.248707294464111 6.524189949035645 4.345217227935791 7.343100070953369 C 4.287087440490723 7.397650241851807 4.211007595062256 7.427700042724609 4.131017208099365 7.427700042724609 C 4.048027515411377 7.427700042724609 3.970037460327148 7.395420074462891 3.911417484283447 7.336800098419189 L 2.757617473602295 6.170400142669678 C 2.695777416229248 6.108550071716309 2.662217378616333 6.026730060577393 2.663117408752441 5.940000057220459 C 2.664007425308228 5.853139877319336 2.69884729385376 5.771959781646729 2.761217355728149 5.711400032043457 C 4.090717315673828 4.47461986541748 5.822447299957275 3.793499946594238 7.637417316436768 3.793499946594238 C 9.452387809753418 3.793499946594238 11.18411731719971 4.47461986541748 12.51361751556396 5.711400032043457 C 12.57655715942383 5.772540092468262 12.61171722412109 5.853720188140869 12.61261749267578 5.940000057220459 C 12.61350727081299 6.025139808654785 12.57939720153809 6.109109878540039 12.51901721954346 6.170400142669678 L 11.36431694030762 7.336800098419189 C 11.30568695068359 7.395420074462891 11.227707862854 7.427700042724609 11.1447172164917 7.427700042724609 Z M 13.80421733856201 4.743000030517578 C 13.72327709197998 4.743000030517578 13.64720726013184 4.711999893188477 13.59001731872559 4.655700206756592 C 11.97507762908936 3.121779918670654 9.860747337341309 2.276999950408936 7.636517524719238 2.276999950408936 C 5.41138744354248 2.276999950408936 3.297057390213013 3.121769905090332 1.683017373085022 4.655700206756592 C 1.625837445259094 4.711989879608154 1.549757361412048 4.743000030517578 1.468817353248596 4.743000030517578 C 1.385827422142029 4.743000030517578 1.3078373670578 4.710720062255859 1.249217391014099 4.652100086212158 L 0.09361741691827774 3.485699892044067 C 0.03236741945147514 3.423549890518188 -0.0008725797524675727 3.342360019683838 1.742024505801965e-05 3.257100105285645 C 0.000917420256882906 3.170560121536255 0.03511742129921913 3.089689970016479 0.09631741791963577 3.029400110244751 C 2.134447336196899 1.075860023498535 4.812267303466797 0 7.636517524719238 0 C 10.46076774597168 0 13.13859748840332 1.075860023498535 15.17671775817871 3.029400110244751 C 15.23734760284424 3.090039968490601 15.27211761474609 3.173029899597168 15.27211761474609 3.257100105285645 C 15.2730073928833 3.342360019683838 15.23976707458496 3.423549890518188 15.17851734161377 3.485699892044067 L 14.02291774749756 4.652100086212158 C 13.96428775787354 4.710720062255859 13.88662719726562 4.743000030517578 13.80421733856201 4.743000030517578 Z" fill="#575757" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
const String _svg_hma332 =
    '<svg viewBox="406.0 17.7 17.0 10.7" ><path transform="translate(406.0, 17.67)" d="M 16.00020027160645 10.6668004989624 L 15.00029945373535 10.6668004989624 C 14.44894981384277 10.6668004989624 14.00039958953857 10.2182502746582 14.00039958953857 9.666900634765625 L 14.00039958953857 0.9998999834060669 C 14.00039958953857 0.4485500156879425 14.44894981384277 0 15.00029945373535 0 L 16.00020027160645 0 C 16.55154991149902 0 17.00010108947754 0.4485500156879425 17.00010108947754 0.9998999834060669 L 17.00010108947754 9.666900634765625 C 17.00010108947754 10.2182502746582 16.55154991149902 10.6668004989624 16.00020027160645 10.6668004989624 Z M 11.33369922637939 10.6668004989624 L 10.33290004730225 10.6668004989624 C 9.781549453735352 10.6668004989624 9.332999229431152 10.2182502746582 9.332999229431152 9.666900634765625 L 9.332999229431152 3.333600044250488 C 9.332999229431152 2.782249927520752 9.781549453735352 2.333699941635132 10.33290004730225 2.333699941635132 L 11.33369922637939 2.333699941635132 C 11.88504981994629 2.333699941635132 12.33360004425049 2.782249927520752 12.33360004425049 3.333600044250488 L 12.33360004425049 9.666900634765625 C 12.33360004425049 10.2182502746582 11.88504981994629 10.6668004989624 11.33369922637939 10.6668004989624 Z M 6.666300296783447 10.6668004989624 L 5.666399955749512 10.6668004989624 C 5.115049839019775 10.6668004989624 4.666500091552734 10.2182502746582 4.666500091552734 9.666900634765625 L 4.666500091552734 5.66640043258667 C 4.666500091552734 5.115050315856934 5.115049839019775 4.666500091552734 5.666399955749512 4.666500091552734 L 6.666300296783447 4.666500091552734 C 7.218140125274658 4.666500091552734 7.667099952697754 5.115050315856934 7.667099952697754 5.66640043258667 L 7.667099952697754 9.666900634765625 C 7.667099952697754 10.2182502746582 7.218140125274658 10.6668004989624 6.666300296783447 10.6668004989624 Z M 1.999799966812134 10.6668004989624 L 0.9998999834060669 10.6668004989624 C 0.4485500156879425 10.6668004989624 0 10.2182502746582 0 9.666900634765625 L 0 7.667100429534912 C 0 7.115260124206543 0.4485500156879425 6.666300296783447 0.9998999834060669 6.666300296783447 L 1.999799966812134 6.666300296783447 C 2.55115008354187 6.666300296783447 2.99970006942749 7.115260124206543 2.99970006942749 7.667100429534912 L 2.99970006942749 9.666900634765625 C 2.99970006942749 10.2182502746582 2.55115008354187 10.6668004989624 1.999799966812134 10.6668004989624 Z" fill="#575757" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
const String _svg_u7gglt =
    '<svg viewBox="344.0 173.9 25.7 26.6" ><path transform="translate(343.0, 172.91)" d="M 1.00000011920929 27.56344413757324 L 5.67302942276001 27.56344413757324 L 5.67302942276001 11.62537956237793 L 1.00000011920929 11.62537956237793 L 1.00000011920929 27.56344413757324 Z M 26.70166015625 12.95355129241943 C 26.70166015625 11.49256229400635 25.65023040771484 10.29720687866211 24.36514663696289 10.29720687866211 L 16.99344253540039 10.29720687866211 L 18.1032886505127 4.227458477020264 L 18.13833427429199 3.802443742752075 C 18.13833427429199 3.257892608642578 17.93973159790039 2.75318717956543 17.62430191040039 2.394580841064453 L 16.38594818115234 0.9999998211860657 L 8.698816299438477 9.752655982971191 C 8.266561508178711 10.23079776763916 8.009544372558594 10.89488410949707 8.009544372558594 11.62537956237793 L 8.009544372558594 24.90710258483887 C 8.009544372558594 26.36808967590332 9.060976982116699 27.56344413757324 10.34605884552002 27.56344413757324 L 20.86037445068359 27.56344413757324 C 21.83002662658691 27.56344413757324 22.65949058532715 26.89936065673828 23.00996780395508 25.94307708740234 L 26.53810501098633 16.57946395874023 C 26.64324951171875 16.27398300170898 26.70166015625 15.95522212982178 26.70166015625 15.60989761352539 L 26.70166015625 13.07308673858643 L 26.68997764587402 13.05980682373047 L 26.70166015625 12.95355129241943 Z" fill="none" stroke="#6f407d" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_qn9i8 =
    '<svg viewBox="0.0 65.0 430.0 77.0" ><path transform="translate(0.0, 65.0)" d="M 56.74769973754883 77.02020263671875 C 56.17734527587891 77.02020263671875 55.6075553894043 77.01351165771484 55.04129028320312 77.00040435791016 L 0 77.00040435791016 L 0 15.00030040740967 C 0 6.715800285339355 6.715800285339355 0 15.00030040740967 0 L 70.510498046875 0 L 70.510498046875 0.1467000097036362 L 150.506103515625 0.1467000097036362 C 150.506103515625 0.1467000097036362 156.3993072509766 -0.4446000158786774 162.8793029785156 2.59470009803772 C 169.3592987060547 5.634900093078613 172.8899993896484 12.30660057067871 172.8899993896484 12.30660057067871 C 172.8899993896484 12.30660057067871 188.3205108642578 36.60480117797852 217.0413055419922 36.43830108642578 C 249.0669097900391 36.20610046386719 262.5632934570312 12.34530067443848 262.5632934570312 12.34530067443848 C 262.5632934570312 12.34530067443848 266.8544921875 5.163300037384033 270.9027099609375 2.59470009803772 C 274.9508972167969 0.02610000036656857 278.2863159179688 0.1467000097036362 285.1416015625 0.1467000097036362 L 359.4888000488281 0.1467000097036362 L 359.4888000488281 0 L 415.9998168945312 0 C 421.89501953125 0 426.9396057128906 3.643968343734741 429.0035400390625 8.80247688293457 C 429.6484375 10.19120025634766 430.0002136230469 11.68927192687988 430.0002136230469 13.25069999694824 L 430.0002136230469 14.00040054321289 L 430.0002136230469 77.00040435791016 L 375.4934997558594 77.00040435791016 C 374.92724609375 77.01351165771484 374.3574523925781 77.02020263671875 373.787109375 77.02020263671875 L 56.74769973754883 77.02020263671875 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_n24q1a =
    '<svg viewBox="4.3 0.0 26.1 26.1" ><path transform="translate(0.26, -4.0)" d="M 17.02800750732422 17.02800750732422 C 20.62699317932129 17.02800750732422 23.54201126098633 14.11298942565918 23.54201126098633 10.51400375366211 C 23.54201126098633 6.915016651153564 20.62699317932129 4 17.02800750732422 4 C 13.42901802062988 4 10.51400375366211 6.915016651153564 10.51400375366211 10.51400375366211 C 10.51400375366211 14.11298942565918 13.42901802062988 17.02800750732422 17.02800750732422 17.02800750732422 Z M 17.02800750732422 20.28500938415527 C 12.67990875244141 20.28500938415527 4 22.46719932556152 4 26.79901313781738 L 4 30.0560131072998 L 30.0560131072998 30.0560131072998 L 30.0560131072998 26.79901313781738 C 30.0560131072998 22.46719932556152 21.37610244750977 20.28500938415527 17.02800750732422 20.28500938415527 Z" fill="#bbc7db" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_btlkna =
    '<svg viewBox="11.1 0.0 26.0 26.0" ><path transform="translate(9.12, -2.0)" d="M 4.600000381469727 7.20000171661377 L 2 7.20000171661377 L 2 25.39999961853027 C 2 26.82999801635742 3.170000553131104 28 4.600000381469727 28 L 22.80000114440918 28 L 22.80000114440918 25.39999961853027 L 4.600000381469727 25.39999961853027 L 4.600000381469727 7.20000171661377 Z M 25.39999961853027 2 L 9.80000114440918 2 C 8.370001792907715 2 7.20000171661377 3.170000553131104 7.20000171661377 4.600000381469727 L 7.20000171661377 20.20000076293945 C 7.20000171661377 21.63000106811523 8.370001792907715 22.80000114440918 9.80000114440918 22.80000114440918 L 25.39999961853027 22.80000114440918 C 26.82999801635742 22.80000114440918 28 21.63000106811523 28 20.20000076293945 L 28 4.600000381469727 C 28 3.170000553131104 26.82999801635742 2 25.39999961853027 2 Z M 25.39999961853027 15.00000286102295 L 22.14999961853027 13.05000114440918 L 18.89999961853027 15.00000286102295 L 18.89999961853027 4.600000381469727 L 25.39999961853027 4.600000381469727 L 25.39999961853027 15.00000286102295 Z" fill="#bbc7db" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_xph1jx =
    '<svg viewBox="16.8 0.0 1.0 31.3" ><path transform="translate(16.81, 0.0)" d="M 0 0 L 0 31.3182373046875" fill="none" stroke="#ffffff" stroke-width="3" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
const String _svg_o6ekv6 =
    '<svg viewBox="0.0 15.7 33.6 1.0" ><path transform="matrix(0.0, 1.0, -1.0, 0.0, 33.62, 15.66)" d="M 0 0 L 0 33.6187744140625" fill="none" stroke="#ffffff" stroke-width="3" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
const String _svg_p8s453 =
    '<svg viewBox="0.0 0.0 26.0 26.0" ><path transform="translate(-3.0, -3.0)" d="M 28.27777862548828 2.999999761581421 L 28.04666709899902 3.043332815170288 L 20.33333206176758 6.033331871032715 L 11.66666603088379 2.999999761581421 L 3.519999742507935 5.744444847106934 C 3.216666460037231 5.845555305480957 2.999999761581421 6.105555534362793 2.999999761581421 6.437777519226074 L 2.999999761581421 28.27777862548828 C 2.999999761581421 28.68222236633301 3.317777872085571 29 3.722221612930298 29 L 3.953333616256714 28.9566650390625 L 11.66666603088379 25.9666633605957 L 20.33333206176758 29 L 28.4799976348877 26.25555610656738 C 28.78333282470703 26.15444564819336 29 25.89444351196289 29 25.56222343444824 L 29 3.722221612930298 C 29 3.317777872085571 28.68222236633301 2.999999761581421 28.27777862548828 2.999999761581421 Z M 20.33333206176758 26.11111068725586 L 11.66666603088379 23.06332969665527 L 11.66666603088379 5.888888359069824 L 20.33333206176758 8.936665534973145 L 20.33333206176758 26.11111068725586 Z" fill="#bbc7db" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_j1pel9 =
    '<svg viewBox="0.7 8.0 29.6 25.2" ><path transform="translate(-1.27, 5.0)" d="M 13.85300064086914 28.1876220703125 L 13.85300064086914 19.29787445068359 L 19.77949523925781 19.29787445068359 L 19.77949523925781 28.1876220703125 L 27.1876220703125 28.1876220703125 L 27.1876220703125 16.33462524414062 L 31.63249969482422 16.33462524414062 L 16.81625175476074 2.999999523162842 L 1.999999523162842 16.33462524414062 L 6.444873809814453 16.33462524414062 L 6.444873809814453 28.1876220703125 L 13.85300064086914 28.1876220703125 Z" fill="#6f407d" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';

Widget post1(BuildContext context,  
{
required String dtmDateCreated,
required String strComplaintTypeEn,
required String strComment,
required int intVotersCount,
required String strStatus,
required String strUserName,
required var address,
required var intComplaintId,



}) {
  return
   Padding(
    padding: const EdgeInsets.only(top:20.0,right:10),
    child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 108, 107, 107),
                  offset: Offset(0, 0),
                  blurRadius: 5,
                ),
              ],
            ),
          child:
    
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Card
       
  
        // Photo
        Stack(
         
          children: <Widget>[
             Container(
              child: Image.asset('assets/icons/pothole.jpg',fit:BoxFit.fill,),
         height: 183.0,
         decoration: const BoxDecoration(
           color: Color(0xff6f407d),
           borderRadius: BorderRadius.only(
             topLeft: Radius.circular(10.0),
             topRight: Radius.circular(10.0),
           ),
         ),
        ),
            // StatusBox
    MediaQuery(
    data: MediaQuery.of(context), child:
  
     Padding(
     padding: const EdgeInsets.all(8.0),
     child: Container(
      height: 15,
      width: 50,
                
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
               child:
            
            //status
                  Text(
                  
                  strStatus,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Euclid Circular A',
                    fontSize: 12,
                    color: Color(0xff6f407d),
                  ),
                  softWrap: false,
                ),
                    ),
     ),
          ),],
        ),
        
  
        // Data
    const SizedBox(height: 10,),
        Row(
          children: [
            //username
             Text(
              strUserName,
              style:const  TextStyle(
                fontFamily: 'Euclid Circular A',
                fontSize: 13,
                color: Color(0xff6f407d),
                fontWeight: FontWeight.w700,
              ),
              softWrap: false,
            ),
          const Spacer(),
            Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 75.0,
                  height: 65.0,
                  child: Column(
                    children: <Widget>[
                         // VoteIcon

                        like(intVotersCount,intComplaintId),
                     
                    
                    ],
                  ),
                ),
              ),
          ],
        ),
  
  
         // Description
               Padding(
                padding:const  EdgeInsets.only(left: 2.0, right: 41.7,bottom: 30),
                child: Text(
                strComplaintTypeEn + '\n' +
             (strComment=="" ? strComment : 'Uneven road surface due to pothole - hazardous conditions!'),

                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    color: Color(0xff000000),
                  ),
                ),
              ),
          SizedBox(height: 1,),
  
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0,left: 5),
            child: Row(children: [
            // address
              Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: 124.0,
                    height: 10.0,
                    child: Text(
                      address,
                      style: TextStyle(
                        fontFamily: 'Euclid Circular A',
                        fontSize: 10,
                        color: Color(0xff92a5c6),
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: false,
                    ),
                  ),
                ),
                   
             SizedBox(width: 18,),
                // date
                 Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    dtmDateCreated.toString().substring(0,10),
                    style: const TextStyle(
                      fontFamily: 'Euclid Circular A',
                      fontSize: 10,
                      color: Color(0xff92a5c6),
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: false,
                  ),),
              SizedBox(width: 40,),
                //time
                 Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                           dtmDateCreated.toString().substring(11,17),
                          style:const   TextStyle(
                            fontFamily: 'Euclid Circular A',
                            fontSize: 10,
                            color: Color(0xff92a5c6),
                             fontWeight: FontWeight.bold,
                          ),
                          softWrap: false,
                        ),
                      ),
            
                   ],),
          )
             
  
       
  
      
  
        //       // Vote count
        //       Align(
        //         alignment: Alignment.topRight,
        //         child: SizedBox(
        //           width: 26.0,
        //           height: 44.0,
        //           child: Stack(
        //             children: <Widget>[
        //               Text(
        //                 '754',
        //                 style: TextStyle(
        //                   fontFamily: 'Euclid Circular A',
        //                   fontSize: 11,
        //                   color: Color(0xff6f407d),
        //                   fontWeight: FontWeight.w500,
        //                 ),
        //                 softWrap: false,
        //               ),
  
        //               // VoteIcon
        //               SvgPicture.string(
        //                 _svg_u7gglt,
        //                 allowDrawingOutsideViewBox: true,
        //                 fit: BoxFit.fill,
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
  
             
        //     ],
        //   ),
        // ),
  
        // // Status box
        
      ],
    ),
    ),
  );
}