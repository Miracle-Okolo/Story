import 'dart:math';

import 'package:covid_19/providers/countries.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChartState();
}

class ChartState extends State {
  int touchedIndex;

  var _isInit = true;
  var _isloading = true;

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
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
                      setState(() {
                        if (pieTouchResponse.touchInput is FlLongPressEnd ||
                            pieTouchResponse.touchInput is FlPanEnd) {
                          touchedIndex = -1;
                        } else {
                          touchedIndex = pieTouchResponse.touchedSectionIndex;
                        }
                      });
                    }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections()),
              ),
            ),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      final countryId = ModalRoute.of(context).settings.arguments as String;
      final loadedProduct =
          Provider.of<Countries>(context, listen: false).findByName(countryId);
      bool isnull = true;
      double totalcases = loadedProduct.totalCases.toDouble();
      double active = loadedProduct.active.toDouble();
      double critical = loadedProduct.critical.toDouble();
      double recovered = loadedProduct.recovered.toDouble();
      double deaths = loadedProduct.totalDeaths.toDouble();
      double dp(double val, int places) {
        double mod = pow(10.0, places);
        return ((val * mod).round().toDouble() / mod);
      }

      double sum = totalcases + active + recovered + deaths + critical;
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 20 : 12;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blueGrey,
            value: (totalcases / sum) * 100,
            title: '${dp((totalcases / sum) * 100, 1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.blue,
            value: (active / sum) * 100,
            title: '${dp((active / sum) * 100, 1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.orange,
            value: (critical / sum) * 100,
            title: '${dp((critical / sum) * 100, 1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.deepPurple,
            value: (recovered / sum) * 100,
            title: '${dp((recovered / sum) * 100, 1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.red,
            value: (deaths / sum) * 100,
            title: '${dp((deaths / sum) * 100, 1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}
