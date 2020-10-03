import 'package:covid_19/chart.dart';
import 'package:covid_19/providers/countries.dart';
import 'package:covid_19/screens/list_of_countries.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CountryDetail extends StatelessWidget {
  static const routeName = '/country-detail';

  @override
  Widget build(BuildContext context) {


    final countryId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Countries>(context, listen: false).findByName(countryId);
    var f = new NumberFormat(",000", "en_US");
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              appBar(loadedProduct.name, context),
              Text(
                '${loadedProduct.day}',
                textAlign: TextAlign.end,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Chart(),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Total Cases: ',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: '${f.format(loadedProduct.totalCases == null ? 0 :loadedProduct.totalCases)}   ',
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w300)),
                          ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Active: ',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: '${f.format(loadedProduct.active == null ? 0 : loadedProduct.active)}   ',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w300)),
                          ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Critical: ',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: '${f.format(loadedProduct.critical == null ? 0 :loadedProduct.critical)}   ',
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w300)),
                          ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Recovered: ',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: '${f.format(loadedProduct.recovered == null ? 0 :loadedProduct.recovered)}   ',
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w300)),
                          ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Deaths: ',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: '${f.format(loadedProduct.totalDeaths == null ? 0 : loadedProduct.totalDeaths)}   ',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w300)),
                            TextSpan(
                                text: '${loadedProduct.newDeaths == null ? " " : loadedProduct.newDeaths}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w200))
                          ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  appBar(String name, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
//          Image.asset("images/back_button.png"),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context)
                            .pop();
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    Text(
                      "$name",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F2F3E)),
                    ),
                  ],
                ),
//                Text(
//                  "MEN'S ORIGINAL",
//                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 14),
//                ),
              ],
            ),
          ),
//          Image.asset("images/bag_button.png", width: 27, height: 30,),
        ],
      ),
    );
  }
}
