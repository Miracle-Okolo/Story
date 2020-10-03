import 'package:covid_19/model/country.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CountryItem extends StatelessWidget with ChangeNotifier {
  Country data;

  CountryItem(this.data);

  @override
  Widget build(BuildContext context) {
    var f = new NumberFormat(",000", "en_US");
    return ListTile(
        title: Text('${data.name}'),
        subtitle: Row(
          children: <Widget>[
            Text('Population: '),
            Text('${f.format(data.population == null ? 0 : data.population)}',
                style: data.population == null
                    ? TextStyle(color: Colors.grey)
                    : TextStyle(color: Colors.orange))
          ],
        ),
        trailing: RichText(
          text: TextSpan(
              text: 'Continent: ',
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: '${data.continent}',
                    style: TextStyle(
                        color: data.continent == 'Asia'
                            ? Colors.red
                            : data.continent == 'North-America'
                                ? Colors.blue
                                : data.continent == 'Europe'
                                    ? Colors.deepPurple
                                    : data.continent == 'Africa'
                                        ? Colors.green
                                        : data.continent == 'South-America'
                                            ? Colors.deepOrange
                                            : data.continent == 'Oceania'
                                                ? Colors.brown
                                                : Colors.grey))
              ]),
        )
//          Text('Continent: '),
//      Text('${data.continent}',
//              ),

        );
  }
}
