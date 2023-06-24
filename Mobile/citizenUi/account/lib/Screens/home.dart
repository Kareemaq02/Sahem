// ignore_for_file: constant_identifier_names, unused_element

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import '../Repository/language.dart';
import '../Repository/language_constants.dart';
import '../main.dart';
import 'register.dart';
import 'package:adobe_xd/page_link.dart';
import 'login.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/flutter_svg.dart';

class XDHome extends StatelessWidget {
  const XDHome({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Pinned.fromPins(
            Pin(start: -126.5, end: -138.5),
            Pin(size: 483.0, start: -150.2),
            child:
                // Adobe XD layer: 'Action Bar' (group)
                Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 477.0,
                    height: 333.0,
                    child: SvgPicture.string(
                      _svg_tz7yhk,
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: 477.0,
                    height: 333.0,
                    child: SvgPicture.string(
                      _svg_c92z9,
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(60.5, 0.0, 97.9, 35.1),
                  child: SizedBox.expand(
                      child: SvgPicture.string(
                    _svg_zgx5iw,
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  )),
                ),
                Align(
                  alignment: const Alignment(-0.086, 0.083),
                  child: Transform.rotate(
                    angle: 0.0175,
                    child:
                        // Adobe XD layer: 'R-removebg-preview …' (shape)
                        Container(
                      width: 254.0,
                      height: 249.0,
                      decoration: const BoxDecoration(
                        
                      ),
                    ),
                  ),
                ),

                Pinned.fromPins(
                  Pin(size: 366.0, middle: 1.400),
                  Pin(size: 100.0, end: 200.7),   
                  child:

                    Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: DropdownButton<Language>(
                    underline: const SizedBox(),
                     icon: const Icon(
                      Icons.language,
                      color: Colors.white,
                       ),
              onChanged: (Language? language) async {
                if (language != null) {
                  Locale _locale = await setLocale(language.languageCode);
                  MyApp.setLocale(context, _locale);
                }
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.flag,
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(e.name)
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
                ),
                
                Pinned.fromPins(
                  Pin(size: 366.0, middle: 0.5900),
                  Pin(size: 100.0, end: 50.7),
                  child: const Text(
                    'Road Damage',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 50,
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Pinned.fromPins(
            Pin(start: 63.0, end: 62.0),
            Pin(size: 71.0, middle: 0.8500),
            child:
                // Adobe XD layer: 'Register Button' (group)
                PageLink(
              links: [
                PageLinkInfo(
                  duration: 0,
                  pageBuilder: () => const XDRegister(),
                ),
              ],
              child: Stack(
                children: <Widget>[
                  Container(
                    
                    decoration: BoxDecoration(
                      color: const Color(0xff2a0340),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                          width: 1.0, color: const Color(0xff707070)),
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(size: 126.0, middle: 0.5028),
                    Pin(start: 16.0, end: 15.0),
                    child:  Text(
                      translation(context).register,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 30,
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 63.0, end: 62.0),
            Pin(size: 71.0, middle: 0.6300),
            child:
                // Adobe XD layer: 'Login Button' (group)
                PageLink(
              links: [
                PageLinkInfo(
                  duration: 0,
                  pageBuilder: () =>  const XDLogin(),
                ),
              ],
              child: Stack(
                children: <Widget>[
                  // Adobe XD layer: 'Login' (shape)
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff2a0340),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                            width: 1.0, color: const Color(0xff707070)),
                      ),
                    ),
                    onTap:(){Navigator.push(context,MaterialPageRoute(builder: (context) =>  const XDLogin()),);}
                  ),
                  Pinned.fromPins(
                    Pin(size: 180.0, middle: 0.5200),
                    Pin(start: 16.0, end: 10.0),
                    child:  Text(
                      translation(context).login,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 30,
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 70.0, end: 30.0),
            Pin(size: 30.0, middle: 0.7400),
            child:  Text(
               translation(context).dont_have_acc,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Color(0xff6f407d),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(size: 161.0, middle: 0.5019),
            Pin(size: 21.0, end: 15.0),
            child: const Text(
              '©Road Damage 2023',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Color(0xff000000),
              ),
            ),
          ),
         
        ],
      ),
    );
  }
}

const String _svg_tz7yhk =
    '<svg viewBox="91.5 61.7 477.0 333.0" ><path transform="matrix(1.0, 0.0, 0.0, 1.0, 91.5, 61.73)" d="M 166.5 0 L 310.5 0 C 402.4554138183594 0 477 74.54458618164062 477 166.5 C 477 258.4554138183594 402.4554138183594 333 310.5 333 L 166.5 333 C 74.54458618164062 333 0 258.4554138183594 0 166.5 C 0 74.54458618164062 74.54458618164062 0 166.5 0 Z" fill="#8285bd" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_c92z9 =
    '<svg viewBox="-126.5 61.7 477.0 333.0" ><path transform="matrix(1.0, 0.0, 0.0, 1.0, -126.5, 61.73)" d="M 166.5 0 L 310.5 0 C 402.4554138183594 0 477 74.54458618164062 477 166.5 C 477 258.4554138183594 402.4554138183594 333 310.5 333 L 166.5 333 C 74.54458618164062 333 0 258.4554138183594 0 166.5 C 0 74.54458618164062 74.54458618164062 0 166.5 0 Z" fill="#8285bd" fill-opacity="0.89" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_zgx5iw =
    '<svg viewBox="-66.0 -88.2 536.6 447.9" ><path transform="translate(-66.0, -88.23)" d="M 124.7795639038086 0 L 411.7725524902344 0 C 480.6864318847656 0 536.5521240234375 43.03042602539062 536.5521240234375 96.11115264892578 L 536.5521240234375 351.7668151855469 C 536.5521240234375 404.8475646972656 480.6864318847656 447.8779907226562 411.7725524902344 447.8779907226562 L 124.7795639038086 447.8779907226562 C 55.86570739746094 447.8779907226562 0 404.8475646972656 0 351.7668151855469 L 0 96.11115264892578 C 0 43.03042602539062 55.86570739746094 0 124.7795639038086 0 Z" fill="#6f407d" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_nrpqt7 =
    '<svg viewBox="29.7 3.7 1.3 4.0" ><path transform="translate(29.67, 3.67)" d="M 0 0 L 0 4 C 0.8047311305999756 3.661223411560059 1.328037977218628 2.873133182525635 1.328037977218628 2 C 1.328037977218628 1.126866698265076 0.8047311305999756 0.3387765288352966 0 0" fill="#ffffff" fill-opacity="0.4" stroke="none" stroke-width="1" stroke-opacity="0.4" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
const String _svg_pmvna3 =
    '<svg viewBox="392.0 18.2 15.3 11.0" ><path transform="translate(392.03, 18.18)" d="M 7.636517524719238 10.96560001373291 C 7.553837299346924 10.96560001373291 7.473147392272949 10.93181037902832 7.415117263793945 10.87290000915527 L 5.417117595672607 8.856900215148926 C 5.355837345123291 8.796520233154297 5.321717262268066 8.712539672851562 5.323517322540283 8.626500129699707 C 5.325307369232178 8.540619850158691 5.363027572631836 8.458290100097656 5.427017211914062 8.400600433349609 C 6.043807506561279 7.878690242767334 6.828487396240234 7.591279983520508 7.636517524719238 7.591279983520508 C 8.444547653198242 7.591279983520508 9.229227066040039 7.878699779510498 9.846017837524414 8.400600433349609 C 9.909987449645996 8.457460403442383 9.947707176208496 8.539790153503418 9.949517250061035 8.626500129699707 C 9.95131778717041 8.712539672851562 9.917197227478027 8.796520233154297 9.855916976928711 8.856900215148926 L 7.857917308807373 10.87290000915527 C 7.799037456512451 10.93268013000488 7.720407485961914 10.96560001373291 7.636517524719238 10.96560001373291 Z M 11.1447172164917 7.427700042724609 C 11.06472778320312 7.427700042724609 10.9886474609375 7.397650241851807 10.93051719665527 7.343100070953369 C 10.02612781524658 6.524199962615967 8.856297492980957 6.073200225830078 7.636517524719238 6.073200225830078 C 6.417577266693115 6.073200225830078 5.248707294464111 6.524189949035645 4.345217227935791 7.343100070953369 C 4.287087440490723 7.397650241851807 4.211007595062256 7.427700042724609 4.131017208099365 7.427700042724609 C 4.048027515411377 7.427700042724609 3.970037460327148 7.395420074462891 3.911417484283447 7.336800098419189 L 2.757617473602295 6.170400142669678 C 2.695777416229248 6.108550071716309 2.662217378616333 6.026730060577393 2.663117408752441 5.940000057220459 C 2.664007425308228 5.853139877319336 2.69884729385376 5.771959781646729 2.761217355728149 5.711400032043457 C 4.090717315673828 4.47461986541748 5.822447299957275 3.793499946594238 7.637417316436768 3.793499946594238 C 9.452387809753418 3.793499946594238 11.18411731719971 4.47461986541748 12.51361751556396 5.711400032043457 C 12.57655715942383 5.772540092468262 12.61171722412109 5.853720188140869 12.61261749267578 5.940000057220459 C 12.61350727081299 6.025139808654785 12.57939720153809 6.109109878540039 12.51901721954346 6.170400142669678 L 11.36431694030762 7.336800098419189 C 11.30568695068359 7.395420074462891 11.227707862854 7.427700042724609 11.1447172164917 7.427700042724609 Z M 13.80421733856201 4.743000030517578 C 13.72327709197998 4.743000030517578 13.64720726013184 4.711999893188477 13.59001731872559 4.655700206756592 C 11.97507762908936 3.121779918670654 9.860747337341309 2.276999950408936 7.636517524719238 2.276999950408936 C 5.41138744354248 2.276999950408936 3.297057390213013 3.121769905090332 1.683017373085022 4.655700206756592 C 1.625837445259094 4.711989879608154 1.549757361412048 4.743000030517578 1.468817353248596 4.743000030517578 C 1.385827422142029 4.743000030517578 1.3078373670578 4.710720062255859 1.249217391014099 4.652100086212158 L 0.09361741691827774 3.485699892044067 C 0.03236741945147514 3.423549890518188 -0.0008725797524675727 3.342360019683838 1.742024505801965e-05 3.257100105285645 C 0.000917420256882906 3.170560121536255 0.03511742129921913 3.089689970016479 0.09631741791963577 3.029400110244751 C 2.134447336196899 1.075860023498535 4.812267303466797 0 7.636517524719238 0 C 10.46076774597168 0 13.13859748840332 1.075860023498535 15.17671775817871 3.029400110244751 C 15.23734760284424 3.090039968490601 15.27211761474609 3.173029899597168 15.27211761474609 3.257100105285645 C 15.2730073928833 3.342360019683838 15.23976707458496 3.423549890518188 15.17851734161377 3.485699892044067 L 14.02291774749756 4.652100086212158 C 13.96428775787354 4.710720062255859 13.88662719726562 4.743000030517578 13.80421733856201 4.743000030517578 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
const String _svg_anq0p =
    '<svg viewBox="370.0 18.5 17.0 10.7" ><path transform="translate(370.0, 18.48)" d="M 16.00020027160645 10.6668004989624 L 15.00029945373535 10.6668004989624 C 14.44894981384277 10.6668004989624 14.00039958953857 10.2182502746582 14.00039958953857 9.666900634765625 L 14.00039958953857 0.9998999834060669 C 14.00039958953857 0.4485500156879425 14.44894981384277 0 15.00029945373535 0 L 16.00020027160645 0 C 16.55154991149902 0 17.00010108947754 0.4485500156879425 17.00010108947754 0.9998999834060669 L 17.00010108947754 9.666900634765625 C 17.00010108947754 10.2182502746582 16.55154991149902 10.6668004989624 16.00020027160645 10.6668004989624 Z M 11.33369922637939 10.6668004989624 L 10.33290004730225 10.6668004989624 C 9.781549453735352 10.6668004989624 9.332999229431152 10.2182502746582 9.332999229431152 9.666900634765625 L 9.332999229431152 3.333600044250488 C 9.332999229431152 2.782249927520752 9.781549453735352 2.333699941635132 10.33290004730225 2.333699941635132 L 11.33369922637939 2.333699941635132 C 11.88504981994629 2.333699941635132 12.33360004425049 2.782249927520752 12.33360004425049 3.333600044250488 L 12.33360004425049 9.666900634765625 C 12.33360004425049 10.2182502746582 11.88504981994629 10.6668004989624 11.33369922637939 10.6668004989624 Z M 6.666300296783447 10.6668004989624 L 5.666399955749512 10.6668004989624 C 5.115049839019775 10.6668004989624 4.666500091552734 10.2182502746582 4.666500091552734 9.666900634765625 L 4.666500091552734 5.66640043258667 C 4.666500091552734 5.115050315856934 5.115049839019775 4.666500091552734 5.666399955749512 4.666500091552734 L 6.666300296783447 4.666500091552734 C 7.218140125274658 4.666500091552734 7.667099952697754 5.115050315856934 7.667099952697754 5.66640043258667 L 7.667099952697754 9.666900634765625 C 7.667099952697754 10.2182502746582 7.218140125274658 10.6668004989624 6.666300296783447 10.6668004989624 Z M 1.999799966812134 10.6668004989624 L 0.9998999834060669 10.6668004989624 C 0.4485500156879425 10.6668004989624 0 10.2182502746582 0 9.666900634765625 L 0 7.667100429534912 C 0 7.115260124206543 0.4485500156879425 6.666300296783447 0.9998999834060669 6.666300296783447 L 1.999799966812134 6.666300296783447 C 2.55115008354187 6.666300296783447 2.99970006942749 7.115260124206543 2.99970006942749 7.667100429534912 L 2.99970006942749 9.666900634765625 C 2.99970006942749 10.2182502746582 2.55115008354187 10.6668004989624 1.999799966812134 10.6668004989624 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
