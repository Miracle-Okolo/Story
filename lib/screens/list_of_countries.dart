import 'dart:convert';


import 'package:covid_19/screens/country_detail.dart';
import 'package:covid_19/model/country.dart';
import 'package:covid_19/providers/countries.dart';
import 'package:covid_19/screens/home_screen.dart';
import 'package:covid_19/widget/country_item.dart';
import 'package:covid_19/widget/info_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ListOfCountries extends StatefulWidget with ChangeNotifier {
  static const routeName = '/list-countries';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ListOfCountriesState();
  }
}

class _ListOfCountriesState extends State<ListOfCountries> {
  TextEditingController searchController = new TextEditingController();
  String filter;
  var _isInit = true;
  var _isloading = true;

  @override  initState() {
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }
  @override  void dispose() {
    searchController.dispose();
    super.dispose();
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




  @override
  Widget build(BuildContext context) {
    final countryData = Provider.of<Countries>(context);
    final data = countryData.items;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: _isloading
            ? Column(
                children: <Widget>[
                  appBar(),
                  Padding(
                    padding: const EdgeInsets.only(top: 200.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                ],
              )
            : Column(
                children: <Widget>[
                  appBar(),
                  Container(
                    height: 540,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (ctx, index) {
                        return filter == null || filter == ""
                            ? GestureDetector(
                                child: CountryItem(data[index]),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      CountryDetail.routeName,
                                      arguments: data[index].name);
                                },
                              )
                            : '${data[index].name}'
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())
                                ? GestureDetector(
                                    child: CountryItem(data[index]),
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          CountryDetail.routeName,
                                          arguments: data[index].name);
                                    },
                                  )
                                : new Container();
                      },
                      itemCount: data == null ? 0 : data.length,
                    ),
                  ),
                ],
              ),
      ),
    ));
  }

  appBar() {
    return Container(
      padding: EdgeInsets.all(2),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                width: 40,
              ),
              Text(
                "List Of Countries",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F2F3E)),
              ),
            ],
          ),
          new Padding(
            padding: new EdgeInsets.all(2.0),
            child: new TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Countries',
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                border: ,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
