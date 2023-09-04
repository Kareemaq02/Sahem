import 'Screens/Login/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Repository/language_constants.dart';
import 'package:account/Widgets/countProvider.dart';
import 'package:account/Providers/filtersProviders.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


//import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FilterModel>(
          create: (context) => FilterModel(),
        ),
       ChangeNotifierProvider(
      create: (context) => CountProvider(),
       ),
      ],
    
      child: MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key,});

    @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}
class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

    @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
    
        primarySwatch: Colors.blue,
      ),
      home: const XDHome(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      //onGenerateRoute: CustomRouter.generatedRoute,
      //initialRoute: homeRoute,
      locale: _locale,
     
     
    );
  }
}

