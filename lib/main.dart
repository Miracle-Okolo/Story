import 'package:covid_19/screens/country_detail.dart';
import 'package:covid_19/providers/countries.dart';
import 'package:covid_19/model/country.dart';
import 'package:covid_19/screens/home_screen.dart';
import 'package:covid_19/screens/list_of_countries.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Country()),
        ChangeNotifierProvider(create: (ctx) => Countries()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Covid-19 App',
        theme: ThemeData(
          primarySwatch: Theme.of(context).primaryColor,
        ),
        home: HomeScreen(),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          ListOfCountries.routeName: (ctx) => ListOfCountries(),
          CountryDetail.routeName: (ctx) => CountryDetail()
        },
      ),
    );
  }
}
