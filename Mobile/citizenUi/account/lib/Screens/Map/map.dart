// // ignore_for_file: depend_on_referenced_packages, camel_case_types, constant_identifier_names

// import 'package:account/Screens/Profile/profile1.dart';
// import 'package:account/Screens/Home/public_feed.dart';
// import 'package:flutter/material.dart';
// import 'package:adobe_xd/pinned.dart';
// import '../View complaints/complaints_list.dart';
// import 'package:adobe_xd/page_link.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class XDMap_ extends StatelessWidget {
//   const XDMap_({
//     Key? key,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffffffff),
//       body: Stack(
//         children: <Widget>[
//           SizedBox(
//             width: 440.0,
//             height: 939.0,
//             child: SvgPicture.string(
//               _svg_aqdodg,
//               allowDrawingOutsideViewBox: true,
//             ),
//           ),
//           Align(
//             alignment: const Alignment(-0.468, -1),
//             child:
//                 // Adobe XD layer: 'Map' (shape)
//                 Container(
//               width: 648.0,
//               height: 932.0,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(''),
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//           ),
//           Pinned.fromPins(
//             Pin(start: 0.0, end: 0.0),
//             Pin(size: 172.0, end: 0.0),
//             child:
//                 // Adobe XD layer: 'NavBar' (group)
//                 Stack(
//               children: <Widget>[
//                 Pinned.fromPins(
//                   Pin(start: 0.0, end: 0.0),
//                   Pin(startFraction: 0.0, endFraction: 0.1201),
//                   child: Transform.rotate(
//                     angle: 3.1416,
//                     child:
//                         // Adobe XD layer: 'Gradiant' (shape)
//                         Container(
//                       decoration: const BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment(0.0, 0.978),
//                           end: Alignment(0.0, -0.987),
//                           colors: [
//                             Color(0x00ffffff),
//                             Color(0xe4828282)
//                           ],
//                           stops: [0.0, 1.0],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(0.0, 46.0, 0.0, 0.0),
//                   child:
//                       // Adobe XD layer: 'Bar' (group)
//                       Stack(
//                     children: <Widget>[
//                       Align(
//                         alignment: Alignment.topCenter,
//                         child: SizedBox(
//                           width: 75.0,
//                           height: 74.0,
//                           child:
//                               // Adobe XD layer: 'Button' (group)
//                               Stack(
//                             children: <Widget>[
//                               // Adobe XD layer: 'ButtonFill' (shape)
//                               Container(
//                                 decoration: BoxDecoration(
//                                   gradient: const LinearGradient(
//                                     begin: Alignment(0.0, -1.0),
//                                     end: Alignment(0.0, 1.0),
//                                     colors: [
//                                       Color(0xff2a0340),
//                                       Color(0xff223e6d)
//                                     ],
//                                     stops: [0.0, 1.0],
//                                   ),
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.elliptical(9999.0, 9999.0)),
//                                   border: Border.all(
//                                       width: 4.0,
//                                       color: const Color(0xffffffff)),
//                                   boxShadow: const [
//                                     BoxShadow(
//                                       color: Color(0x29000000),
//                                       offset: Offset(0, 3),
//                                       blurRadius: 40,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Pinned.fromPins(
//                         Pin(start: 0.0, end: 0.0),
//                         Pin(size: 77.0, end: 0.0),
//                         child:
//                             // Adobe XD layer: 'BottomBar' (shape)
//                             SvgPicture.string(
//                           _svg_qn9i8,
//                           allowDrawingOutsideViewBox: true,
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Pinned.fromPins(
//                   Pin(size: 26.1, end: 28.7),
//                   Pin(size: 35.1, end: 18.6),
//                   child:
//                       // Adobe XD layer: 'Profile' (group)
//                       PageLink(
//                     links: [
//                       PageLinkInfo(
//                         duration: 0,
//                         pageBuilder: () => const Pro(),
//                       ),
//                     ],
//                     child: Stack(
//                       children: <Widget>[
//                         Pinned.fromPins(
//                           Pin(start: 2.0, end: 2.0),
//                           Pin(size: 9.0, end: 0.0),
//                           child:
//                               // Adobe XD layer: 'Label' (text)
//                               const Text(
//                             'Profile',
//                             style: TextStyle(
//                               fontFamily: 'Euclid Circular A',
//                               fontSize: 7,
//                               color: Color(0xffbbc7db),
//                               fontWeight: FontWeight.w700,
//                               height: 0.7142857142857143,
//                             ),
//                             textHeightBehavior: TextHeightBehavior(
//                                 applyHeightToFirstAscent: false),
//                             softWrap: false,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 9.0),
//                           child: SizedBox.expand(
//                               child:
//                                   // Adobe XD layer: 'Profile' (shape)
//                                   SvgPicture.string(
//                             _svg_n24q1a,
//                             allowDrawingOutsideViewBox: true,
//                             fit: BoxFit.fill,
//                           )),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Pinned.fromPins(
//                   Pin(size: 39.0, middle: 0.7715),
//                   Pin(size: 35.0, end: 18.6),
//                   child:
//                       // Adobe XD layer: 'Complaints' (group)
//                       PageLink(
//                     links: [
//                       PageLinkInfo(
//                         duration: 0,
//                         pageBuilder: () => const XDComplaintsList(),
//                       ),
//                     ],
//                     child: Stack(
//                       children: <Widget>[
//                         Pinned.fromPins(
//                           Pin(start: 0.0, end: 0.0),
//                           Pin(size: 9.0, end: 0.0),
//                           child:
//                               // Adobe XD layer: 'Label' (text)
//                               const Text(
//                             'Complaints',
//                             style: TextStyle(
//                               fontFamily: 'Euclid Circular A',
//                               fontSize: 7,
//                               color: Color(0xffbbc7db),
//                               fontWeight: FontWeight.w700,
//                               height: 0.7142857142857143,
//                             ),
//                             textHeightBehavior: TextHeightBehavior(
//                                 applyHeightToFirstAscent: false),
//                             softWrap: false,
//                           ),
//                         ),
//                         Pinned.fromPins(
//                           Pin(start: 6.5, end: 6.5),
//                           Pin(size: 26.0, start: 0.0),
//                           child:
//                               // Adobe XD layer: 'ComplaintsIcon' (shape)
//                               SvgPicture.string(
//                             _svg_btlkna,
//                             allowDrawingOutsideViewBox: true,
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: const Alignment(0.0, -0.062),
//                   child: SizedBox(
//                     width: 34.0,
//                     height: 31.0,
//                     child:
//                         // Adobe XD layer: 'FillComplaintIcon' (group)
//                         Stack(
//                       children: <Widget>[
//                         Pinned.fromPins(
//                           Pin(size: 1.0, middle: 0.5153),
//                           Pin(start: 0.0, end: 0.0),
//                           child: SvgPicture.string(
//                             _svg_xph1jx,
//                             allowDrawingOutsideViewBox: true,
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                         Pinned.fromPins(
//                           Pin(start: 0.0, end: 0.0),
//                           Pin(size: 1.0, middle: 0.5165),
//                           child: SvgPicture.string(
//                             _svg_o6ekv6,
//                             allowDrawingOutsideViewBox: true,
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Pinned.fromPins(
//                   Pin(size: 26.0, middle: 0.2711),
//                   Pin(size: 35.0, end: 17.0),
//                   child:
//                       // Adobe XD layer: 'Map' (group)
//                       Stack(
//                     children: <Widget>[
//                       const Align(
//                         alignment: Alignment.bottomCenter,
//                         child: SizedBox(
//                           width: 15.0,
//                           height: 9.0,
//                           child:
//                               // Adobe XD layer: 'Label' (text)
//                               Text(
//                             'Map',
//                             style: TextStyle(
//                               fontFamily: 'Euclid Circular A',
//                               fontSize: 7,
//                               color: Color(0xff6f407d),
//                               fontWeight: FontWeight.w700,
//                               height: 0.7142857142857143,
//                             ),
//                             textHeightBehavior: TextHeightBehavior(
//                                 applyHeightToFirstAscent: false),
//                             softWrap: false,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 9.0),
//                         child: SizedBox.expand(
//                             child:
//                                 // Adobe XD layer: 'Map' (shape)
//                                 SvgPicture.string(
//                           _svg_ftdyrm,
//                           allowDrawingOutsideViewBox: true,
//                           fit: BoxFit.fill,
//                         )),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Pinned.fromPins(
//                   Pin(size: 29.6, start: 34.7),
//                   Pin(size: 36.6, end: 17.0),
//                   child:
//                       // Adobe XD layer: 'Home' (group)
//                       PageLink(
//                     links: [
//                       PageLinkInfo(
//                         duration: 0,
//                         pageBuilder: () => const XDPublicFeed1(),
//                       ),
//                     ],
//                     child: Stack(
//                       children: <Widget>[
//                         Pinned.fromPins(
//                           Pin(start: 2.3, end: 2.4),
//                           Pin(size: 11.0, end: 0.0),
//                           child:
//                               // Adobe XD layer: 'Label' (text)
//                               const Text(
//                             'Home',
//                             style: TextStyle(
//                               fontFamily: 'Euclid Circular A',
//                               fontSize: 9,
//                               color: Color(0xffbbc7db),
//                               fontWeight: FontWeight.w700,
//                               height: 0.6666666666666666,
//                             ),
//                             textHeightBehavior: TextHeightBehavior(
//                                 applyHeightToFirstAscent: false),
//                             softWrap: false,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 11.5),
//                           child: SizedBox.expand(
//                               child:
//                                   // Adobe XD layer: 'HomeIcon' (shape)
//                                   SvgPicture.string(
//                             _svg_ax8kh6,
//                             allowDrawingOutsideViewBox: true,
//                             fit: BoxFit.fill,
//                           )),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Pinned.fromPins(
//             Pin(start: 0.0, end: 0.0),
//             Pin(size: 209.0, middle: 0.0),
//             child:
//                 // Adobe XD layer: 'Header' (group)
//                 Stack(
//               children: <Widget>[
//                 Pinned.fromPins(
//                   Pin(start: 0.0, end: 0.0),
//                   Pin(startFraction: 0.0, endFraction: 0.0),
//                   child:
//                       // Adobe XD layer: 'Gradiant' (shape)
//                       Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment(0.0, 0.978),
//                         end: Alignment(0.0, -0.987),
//                         colors: [
//                           Color(0x00ffffff),
//                           Color(0xb0ffffff)
//                         ],
//                         stops: [0.0, 1.0],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Pinned.fromPins(
//                   Pin(startFraction: 0.2023, endFraction: 0.2023),
//                   Pin(size: 34.0, middle: 0.32),
//                   child:
//                       // Adobe XD layer: 'Title' (text)
//                       const Text(
//                     'General Complaints',
//                     style: TextStyle(
//                       fontFamily: 'Euclid Circular A',
//                       fontSize: 27,
//                       color: Color(0xff6f407d),
//                       height: 1.1851851851851851,
//                     ),
//                     textHeightBehavior:
//                         TextHeightBehavior(applyHeightToFirstAscent: false),
//                     textAlign: TextAlign.center,
//                     softWrap: false,
//                   ),
//                 ),
//                 Pinned.fromPins(
//                   Pin(size: 21.9, start: 16.0),
//                   Pin(size: 36.6, middle: 0.3663),
//                   child:
//                       // Adobe XD layer: 'BackIcon' (shape)
//                       PageLink(
//                     links: [
//                       PageLinkInfo(
//                         duration: 0,
//                         pageBuilder: () => const XDPublicFeed1(),
//                       ),
//                     ],
//                     child: SvgPicture.string(
//                       _svg_uaqvq,
//                       allowDrawingOutsideViewBox: true,
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//                 Pinned.fromPins(
//                   Pin(size: 26.5, end: 21.5),
//                   Pin(size: 17.7, middle: 0.33),
//                   child:
//                       // Adobe XD layer: 'FilterIcon' (shape)
//                       SvgPicture.string(
//                     _svg_f651wd,
//                     allowDrawingOutsideViewBox: true,
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// const String _svg_aqdodg =
//     '<svg viewBox="0.0 0.0 440.3 938.8" ><path transform="matrix(1.0, 0.0, 0.0, 1.0, 0.0, 0.0)" d="M 0 0 L 440.3344421386719 0 L 440.3344421386719 938.7883911132812 L 0 938.7883911132812 L 0 0 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
// const String _svg_qn9i8 =
//     '<svg viewBox="0.0 65.0 430.0 77.0" ><path transform="translate(0.0, 65.0)" d="M 56.74769973754883 77.02020263671875 C 56.17734527587891 77.02020263671875 55.6075553894043 77.01351165771484 55.04129028320312 77.00040435791016 L 0 77.00040435791016 L 0 15.00030040740967 C 0 6.715800285339355 6.715800285339355 0 15.00030040740967 0 L 70.510498046875 0 L 70.510498046875 0.1467000097036362 L 150.506103515625 0.1467000097036362 C 150.506103515625 0.1467000097036362 156.3993072509766 -0.4446000158786774 162.8793029785156 2.59470009803772 C 169.3592987060547 5.634900093078613 172.8899993896484 12.30660057067871 172.8899993896484 12.30660057067871 C 172.8899993896484 12.30660057067871 188.3205108642578 36.60480117797852 217.0413055419922 36.43830108642578 C 249.0669097900391 36.20610046386719 262.5632934570312 12.34530067443848 262.5632934570312 12.34530067443848 C 262.5632934570312 12.34530067443848 266.8544921875 5.163300037384033 270.9027099609375 2.59470009803772 C 274.9508972167969 0.02610000036656857 278.2863159179688 0.1467000097036362 285.1416015625 0.1467000097036362 L 359.4888000488281 0.1467000097036362 L 359.4888000488281 0 L 415.9998168945312 0 C 421.89501953125 0 426.9396057128906 3.643968343734741 429.0035400390625 8.80247688293457 C 429.6484375 10.19120025634766 430.0002136230469 11.68927192687988 430.0002136230469 13.25069999694824 L 430.0002136230469 14.00040054321289 L 430.0002136230469 77.00040435791016 L 375.4934997558594 77.00040435791016 C 374.92724609375 77.01351165771484 374.3574523925781 77.02020263671875 373.787109375 77.02020263671875 L 56.74769973754883 77.02020263671875 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
// const String _svg_n24q1a =
//     '<svg viewBox="4.3 0.0 26.1 26.1" ><path transform="translate(0.26, -4.0)" d="M 17.02800750732422 17.02800750732422 C 20.62699317932129 17.02800750732422 23.54201126098633 14.11298942565918 23.54201126098633 10.51400375366211 C 23.54201126098633 6.915016651153564 20.62699317932129 4 17.02800750732422 4 C 13.42901802062988 4 10.51400375366211 6.915016651153564 10.51400375366211 10.51400375366211 C 10.51400375366211 14.11298942565918 13.42901802062988 17.02800750732422 17.02800750732422 17.02800750732422 Z M 17.02800750732422 20.28500938415527 C 12.67990875244141 20.28500938415527 4 22.46719932556152 4 26.79901313781738 L 4 30.0560131072998 L 30.0560131072998 30.0560131072998 L 30.0560131072998 26.79901313781738 C 30.0560131072998 22.46719932556152 21.37610244750977 20.28500938415527 17.02800750732422 20.28500938415527 Z" fill="#bbc7db" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
// const String _svg_btlkna =
//     '<svg viewBox="11.1 0.0 26.0 26.0" ><path transform="translate(9.12, -2.0)" d="M 4.600000381469727 7.20000171661377 L 2 7.20000171661377 L 2 25.39999961853027 C 2 26.82999801635742 3.170000553131104 28 4.600000381469727 28 L 22.80000114440918 28 L 22.80000114440918 25.39999961853027 L 4.600000381469727 25.39999961853027 L 4.600000381469727 7.20000171661377 Z M 25.39999961853027 2 L 9.80000114440918 2 C 8.370001792907715 2 7.20000171661377 3.170000553131104 7.20000171661377 4.600000381469727 L 7.20000171661377 20.20000076293945 C 7.20000171661377 21.63000106811523 8.370001792907715 22.80000114440918 9.80000114440918 22.80000114440918 L 25.39999961853027 22.80000114440918 C 26.82999801635742 22.80000114440918 28 21.63000106811523 28 20.20000076293945 L 28 4.600000381469727 C 28 3.170000553131104 26.82999801635742 2 25.39999961853027 2 Z M 25.39999961853027 15.00000286102295 L 22.14999961853027 13.05000114440918 L 18.89999961853027 15.00000286102295 L 18.89999961853027 4.600000381469727 L 25.39999961853027 4.600000381469727 L 25.39999961853027 15.00000286102295 Z" fill="#bbc7db" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
// const String _svg_xph1jx =
//     '<svg viewBox="16.8 0.0 1.0 31.3" ><path transform="translate(16.81, 0.0)" d="M 0 0 L 0 31.3182373046875" fill="none" stroke="#ffffff" stroke-width="3" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
// const String _svg_o6ekv6 =
//     '<svg viewBox="0.0 15.7 33.6 1.0" ><path transform="matrix(0.0, 1.0, -1.0, 0.0, 33.62, 15.66)" d="M 0 0 L 0 33.6187744140625" fill="none" stroke="#ffffff" stroke-width="3" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
// const String _svg_ftdyrm =
//     '<svg viewBox="0.0 0.0 26.0 26.0" ><path transform="translate(-3.0, -3.0)" d="M 28.27777862548828 2.999999761581421 L 28.04666709899902 3.043332815170288 L 20.33333206176758 6.033331871032715 L 11.66666603088379 2.999999761581421 L 3.519999742507935 5.744444847106934 C 3.216666460037231 5.845555305480957 2.999999761581421 6.105555534362793 2.999999761581421 6.437777519226074 L 2.999999761581421 28.27777862548828 C 2.999999761581421 28.68222236633301 3.317777872085571 29 3.722221612930298 29 L 3.953333616256714 28.9566650390625 L 11.66666603088379 25.9666633605957 L 20.33333206176758 29 L 28.4799976348877 26.25555610656738 C 28.78333282470703 26.15444564819336 29 25.89444351196289 29 25.56222343444824 L 29 3.722221612930298 C 29 3.317777872085571 28.68222236633301 2.999999761581421 28.27777862548828 2.999999761581421 Z M 20.33333206176758 26.11111068725586 L 11.66666603088379 23.06332969665527 L 11.66666603088379 5.888888359069824 L 20.33333206176758 8.936665534973145 L 20.33333206176758 26.11111068725586 Z" fill="#6f407d" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
// const String _svg_ax8kh6 =
//     '<svg viewBox="0.7 8.0 29.6 25.2" ><path transform="translate(-1.27, 5.0)" d="M 13.85300064086914 28.1876220703125 L 13.85300064086914 19.29787445068359 L 19.77949523925781 19.29787445068359 L 19.77949523925781 28.1876220703125 L 27.1876220703125 28.1876220703125 L 27.1876220703125 16.33462524414062 L 31.63249969482422 16.33462524414062 L 16.81625175476074 2.999999523162842 L 1.999999523162842 16.33462524414062 L 6.444873809814453 16.33462524414062 L 6.444873809814453 28.1876220703125 L 13.85300064086914 28.1876220703125 Z" fill="#bbc7db" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
// const String _svg_uaqvq =
//     '<svg viewBox="0.0 13.1 21.9 36.6" ><path transform="translate(-8.0, 7.14)" d="M 29.90407371520996 10.30359077453613 L 25.73609352111816 6 L 7.999998092651367 24.31315040588379 L 25.73609352111816 42.62630462646484 L 29.90407371520996 38.32271575927734 L 16.36552429199219 24.31315040588379 L 29.90407371520996 10.30359077453613 Z" fill="#6f407d" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
// const String _svg_f651wd =
//     '<svg viewBox="366.0 13.1 26.5 17.7" ><path transform="translate(363.0, 7.14)" d="M 13.29619026184082 23.65061187744141 L 19.17972755432129 23.65061187744141 L 19.17972755432129 20.70884323120117 L 13.29619026184082 20.70884323120117 L 13.29619026184082 23.65061187744141 Z M 3 6 L 3 8.941768646240234 L 29.47591781616211 8.941768646240234 L 29.47591781616211 6 L 3 6 Z M 7.412652969360352 16.29619026184082 L 25.06326484680176 16.29619026184082 L 25.06326484680176 13.35442161560059 L 7.412652969360352 13.35442161560059 L 7.412652969360352 16.29619026184082 Z" fill="#6f407d" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
