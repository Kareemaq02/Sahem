import 'package:flutter/material.dart';
import 'package:account/Screens/Login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'Repository/language_constants.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

SharedPreferences? prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  // static void setLocale(BuildContext context, Locale newLocale) {
  //   _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
  //   state?.setLocale(newLocale);
  // }
}

class _MyAppState extends State<MyApp> {
  //Locale? _locale;

  // setLocale(Locale locale) {
  //   setState(() {
  //     _locale = locale;
  //   });
  // }

  @override
  void didChangeDependencies() {
    // getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const XDLogin(),
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      //onGenerateRoute: CustomRouter.generatedRoute,
      //initialRoute: homeRoute,
    //  locale: _locale,
    );
  }
}
