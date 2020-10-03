import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:covid_19/model/country.dart';
import 'package:covid_19/providers/countries.dart';
import 'package:covid_19/screens/list_of_countries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../widget/info_card.dart';

class HomeScreen extends StatefulWidget with ChangeNotifier {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "China";
  String error;
  var _isInit = true;
  var _isloading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    get();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      _isloading = true;
      Provider.of<Countries>(context).get().then((_) => {
            setState(() {
              _isloading = false;
            })
          });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.country}";
      });
    } catch (e) {
      setState(() {
        _currentAddress = "China";
      });
      print(e);
      error = e.toString();
    }
  }

  static const _apikey = "5218fb9f92mshf5f338c20fee546p125b1djsnf498c408ca48";

  static const String _baseUrl = "covid-193.p.rapidapi.com";

  List<Country> _items = [];

  List<Country> get items {
    return [..._items];
  }

  Future<void> get() async {
    const Map<String, String> _headers = {
      "content-type": "application/json",
      "x-rapidapi-host": _baseUrl,
      "x-rapidapi-key": _apikey
    };

    Uri uri = Uri.https(
      _baseUrl,
      "/statistics",
    );
    http.Response response = await http.get(uri, headers: _headers);

    final extractedData =
        json.decode(response.body)['response'] as List<dynamic>;

    final List<Country> loadedProducts = [];
    extractedData.forEach((countryData) {
      loadedProducts.add(Country(
          name: countryData['country'],
          active: countryData['cases']['active'],
          totalCases: countryData['cases']['total'],
          newCases: countryData['cases']['new'],
          critical: countryData['cases']['critical'],
          recovered: countryData['cases']['recovered'],
          newDeaths: countryData['deaths']['new'],
          totalDeaths: countryData['deaths']['total'],
          day: countryData['day'],
          continent: countryData['continent'],
          population: countryData['population']));
    });
    _items = loadedProducts;

    if (extractedData == null) {
      return;
    }

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print(json.decode(response.body)['response']);
      return json.decode(response.body);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Countries>(context);
    var info = data.items;

    var f = new NumberFormat(",000", "en_US");
    var itemChina = info[items.indexWhere((element) => element.name.startsWith("China"))];
    var itemCountry = _currentAddress == error
        ? itemChina
        : info[items.indexWhere((address) => address.name.startsWith(
            _currentAddress == 'United States'
                ? updateAddress("USA")
                : _currentAddress == "Democratic Republic of the Congo"
                    ? updateAddress("DRC")
                    : _currentAddress == "United Arab Emirates"
                        ? updateAddress("UAE")
                        : _currentAddress == "United Kingdom"
                            ? updateAddress("UK")
                            : _currentAddress == "South Korea"
                                ? updateAddress("S-Korea")
                                : _currentAddress))];

    print(_currentAddress);
    return Scaffold(
        body: SafeArea(
      child: _isloading
          ? Column(
              children: <Widget>[
                appBar(),
                Padding(
                    padding: EdgeInsets.only(top: 250),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ))
              ],
            )
          : Column(
              children: <Widget>[
                appBar(),
                Text(
                  'Current Location:  $_currentAddress',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Wrap(
                    runSpacing: 20,
                    spacing: 20,
                    children: <Widget>[
                      InfoCard(
                        title: "Confirmed Cases",
                        iconColor: Color(0xFFFF8C00),
                        effectedNum: f.format(itemCountry.totalCases == null
                            ? 000
                            : itemCountry.totalCases),
                        press: () {},
                      ),
                      InfoCard(
                        title: "Total Deaths",
                        iconColor: Color(0xFFFF2D55),
                        effectedNum: f.format(itemCountry.totalDeaths == null
                            ? 000
                            : itemCountry.totalDeaths),
                        press: () {},
                      ),
                      InfoCard(
                        title: "Total Recovered",
                        iconColor: Color(0xFF50E3C2),
                        effectedNum: f.format(itemCountry.recovered == null
                            ? 000
                            : itemCountry.recovered),
                        press: () {},
                      ),
                      InfoCard(
                        title: "Active",
                        iconColor: Color(0xFF5856D6),
                        effectedNum: f.format(itemCountry.active == null
                            ? 000
                            : itemCountry.active),
                        press: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) {
//                            return DetailsScreen();
//                          },
//                        ),
//                      );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Preventions",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        buildPreventation(),
                      ],
                    ),
                  ),
                )
              ],
            ),
    ));
  }

  String updateAddress(String address) {
    return address;
  }

  appBar() {
    return Container(
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
//          Image.asset("images/back_button.png"),
          SizedBox(width: 40),
          Text(
            "COVID-19",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F2F3E)),
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              Navigator.of(context).pushNamed(ListOfCountries.routeName);
            },
          )
//          Image.asset("images/bag_button.png", width: 27, height: 30,),
        ],
      ),
    );
  }

  Row buildPreventation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        PreventitonCard(
          svgSrc: "assets/icons/hand_wash.svg",
          title: "Wash Hands",
        ),
        PreventitonCard(
          svgSrc: "assets/icons/use_mask.svg",
          title: "Use Masks",
        ),
        PreventitonCard(
          svgSrc: "assets/icons/Clean_Disinfect.svg",
          title: "Clean Disinfect",
        ),
      ],
    );
  }
}

class PreventitonCard extends StatelessWidget {
  final String svgSrc;
  final String title;

  const PreventitonCard({
    Key key,
    this.svgSrc,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SvgPicture.asset(svgSrc),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: kPrimaryColor),
        )
      ],
    );
  }
}
