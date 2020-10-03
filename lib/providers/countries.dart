import 'dart:convert';
import 'package:covid_19/model/country.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Countries with ChangeNotifier {

  static const _apikey = "5218fb9f92mshf5f338c20fee546p125b1djsnf498c408ca48";

  static const String _baseUrl = "covid-193.p.rapidapi.com";

  List<Country> _items = [];

  List<Country> get items {
    return [..._items];
  }


  Country findByName(String name) {
    return _items.firstWhere((country) => country.name == name);
  }


  Future<void> get() async {


    const _baseUri = 'api.scripture.api.bible';
    const  _apike = '5af01cdfafb0cbd646910ae5b33a9e6c';

    const Map<String, String> _header = {
      "content-type": "application/json",
      "api-key": _apike
    };

    var url =  'https://api.scripture.api.bible/v1/bibles';
    http.Response respons = await http.get(url, headers: _header);
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
      notifyListeners();
    });
    _items = loadedProducts;

    if (extractedData == null) {
      return;
    }


    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print(json.decode(response.body)['response']);
      print(json.decode(respons.body));
      return json.decode(response.body);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }


}
