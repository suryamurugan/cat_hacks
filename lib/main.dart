import 'custom_appbar.dart';
import 'custom_shape_clipper.dart';
import 'flight_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: appTheme,
    ));

Color firstColor = Colors.teal;
Color secondColor = Colors.cyan;

ThemeData appTheme = ThemeData(
  primaryColor: Colors.teal,
  fontFamily: "Oxygen",
);

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

List<String> locations = ['Boston [BOS]', 'New York City [JFK]'];

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
      final desktopSalesData = [
        new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
        new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
        new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
        new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
      ];

      final tableSalesData = [
        new TimeSeriesSales(new DateTime(2017, 9, 19), 10),
        new TimeSeriesSales(new DateTime(2017, 9, 26), 50),
        new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
        new TimeSeriesSales(new DateTime(2017, 10, 10), 150),
      ];

      final mobileSalesData = [
        new TimeSeriesSales(new DateTime(2017, 9, 19), 10),
        new TimeSeriesSales(new DateTime(2017, 9, 26), 50),
        new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
        new TimeSeriesSales(new DateTime(2017, 10, 10), 150),
      ];

      return [
        new charts.Series<TimeSeriesSales, DateTime>(
          id: 'Desktop',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: desktopSalesData,
        ),
        new charts.Series<TimeSeriesSales, DateTime>(
          id: 'Tablet',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: tableSalesData,
        ),
        new charts.Series<TimeSeriesSales, DateTime>(
            id: 'Mobile',
            colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
            domainFn: (TimeSeriesSales sales, _) => sales.time,
            measureFn: (TimeSeriesSales sales, _) => sales.sales,
            data: mobileSalesData)
          // Configure our custom point renderer for this series.
          ..setAttribute(charts.rendererIdKey, 'customPoint'),
      ];
    }

    var chartWidget = Padding(
      padding: EdgeInsets.all(16.0),
      child: SizedBox(
        height: 100.0,
        child: new charts.TimeSeriesChart(
          _createSampleData(),
          animate: true,
          // Configure the default renderer as a line renderer. This will be used
          // for any series that does not define a rendererIdKey.
          //
          // This is the default configuration, but is shown here for  illustration.
          defaultRenderer: new charts.LineRendererConfig(),
          // Custom renderer configuration for the point series.
          customSeriesRenderers: [
            new charts.PointRendererConfig(
                // ID used to link series to this renderer.
                customRendererId: 'customPoint')
          ],
          // Optionally pass in a [DateTimeFactory] used by the chart. The factory
          // should create the same type of [DateTime] as the data provided. If none
          // specified, the default creates local date time.
          dateTimeFactory: const charts.LocalDateTimeFactory(),
        ),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            HomeScreenTopPart(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: EdgeInsets.only(right: 8.0),
              child: Text("System Timeseries data:",
                  style: TextStyle(
                      color: appTheme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              decoration: BoxDecoration(
                  color: discountBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 10,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: chartWidget,
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            Wrap(
                alignment: WrapAlignment.center,
                spacing: 40.0,
                runSpacing: 30.0,
                children: <Widget>[
                  ActionCard(
                    icon: Icons.camera,
                    color: appTheme.primaryColor,
                    title: "Scan for\n health",
                    onPressed: () {},
                  ),
                  ActionCard(
                    icon: Icons.send,
                    color: appTheme.primaryColor,
                    title: "Broadcast",
                    onPressed: () {},
                  ),
                  ActionCard(
                    icon: Icons.store,
                    color: appTheme.primaryColor,
                    title: "Store",
                    onPressed: () {},
                  ),
                ]),
            SizedBox(
              height: 50,
            ),
            Text(
              "App version : 1.0",
              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}

const TextStyle dropdownLableStyle =
    TextStyle(color: Colors.white, fontSize: 16);
const TextStyle dropdownMenuItemStyle =
    TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);

class HomeScreenTopPart extends StatefulWidget {
  @override
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}

class _HomeScreenTopPartState extends State<HomeScreenTopPart> {
  var selectedLocationIndex = 0;
  var isFlightSelected = false;

  /// Create one series with sample hard coded data.

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 375,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [firstColor, secondColor])),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 55,
                ),
                Text(
                  "Good Morning !\nHere's your produce status.",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "21" + "\u2103",
                          style: TextStyle(
                              fontSize: 60,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "15",
                          style: TextStyle(
                              fontSize: 60,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      child: ChoiceChip(
                          Icons.hot_tub, "Current Temp", isFlightSelected),
                      onTap: () {
                        setState(() {
                          isFlightSelected = true;
                        });
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      child: ChoiceChip(Icons.content_cut, "Days\nTo Harvest",
                          isFlightSelected),
                      onTap: () {
                        setState(() {
                          isFlightSelected = false;
                        });
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ChoiceChip extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool isSelected;

  ChoiceChip(this.icon, this.text, this.isSelected);

  @override
  _ChoiceChipState createState() => _ChoiceChipState();
}

class _ChoiceChipState extends State<ChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8.0),
      decoration: widget.isSelected
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.all(Radius.circular(20)))
          : null,
      child: Row(
        children: <Widget>[
          Icon(
            widget.icon,
            size: 20,
            color: Colors.white,
          ),
          SizedBox(
            width: 8,
          ),
          Text(widget.text, style: TextStyle(color: Colors.white, fontSize: 16))
        ],
      ),
    );
  }
}

var viewAllStyle = TextStyle(
    fontSize: 14, color: appTheme.primaryColor, fontWeight: FontWeight.w900);

final formatCurrency = NumberFormat.simpleCurrency();


class ActionCard extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String title;
  final Color color;

  const ActionCard({Key key, this.onPressed, this.icon, this.title, this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onPressed,
      child: Ink(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200],
              blurRadius: 10,
              spreadRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: color,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: 12,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
