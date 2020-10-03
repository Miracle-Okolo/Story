import 'package:flutter/material.dart';

class Country with ChangeNotifier {
  String name;
  int totalCases;
  int critical;
  String newCases;
  int recovered;
  String newDeaths;
  int totalDeaths;
  String day;
  int active;
  String continent;
  int population;

  Country(
      {this.name,
      this.totalCases,
      this.active,
      this.critical,
      this.newCases,
      this.recovered,
      this.newDeaths,
      this.totalDeaths,
      this.day,
      this.continent,
      this.population});
}
