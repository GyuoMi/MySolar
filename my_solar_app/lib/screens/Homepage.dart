import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:based_battery_indicator/based_battery_indicator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MyCustomWidget extends StatelessWidget {
  final AnimationController controller;

  MyCustomWidget({required this.controller});
  bool charging = true;
  bool houseDraw = true;
  bool solarDraw = true;
  bool gridDraw = false;
  int batteryPer = 45;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.sunny,
                color: Colors.yellow,
                size: 60.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              RotatedBox(
                quarterTurns: 1,
                child: SizedBox(
                  width: 80,
                  height: 10,
                  child: LinearProgressIndicator(
                    color: CupertinoColors.activeGreen,
                    value: solarDraw ? controller.value : 0,
                    semanticsLabel: 'Linear progress indicator',
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                BasedBatteryIndicator(
                  status: BasedBatteryStatus(
                    value: batteryPer,

                    ///change charge value
                    type: charging
                        ? BasedBatteryStatusType.charging
                        : BasedBatteryStatusType.normal,

                    ///change its state eg charging vs normal
                  ),
                  trackHeight: 30.0,
                  trackAspectRatio: 2.0,
                  curve: Curves.ease,
                  duration: const Duration(seconds: 1),
                ),
                RotatedBox(
                  quarterTurns: charging ? 2 : 0,
                  child: SizedBox(
                    width: 80,
                    height: 10,
                    child: LinearProgressIndicator(
                      color: CupertinoColors.activeGreen,
                      value: controller.value,
                      semanticsLabel: 'Linear progress indicator',
                    ),
                  ),
                ),
                Icon(
                  Icons.add_box,
                  color: Colors.black,
                  size: 60.0,
                ),
                RotatedBox(
                  quarterTurns: 0,
                  child: SizedBox(
                    width: 80,
                    height: 10,
                    child: LinearProgressIndicator(
                      color: CupertinoColors.activeGreen,
                      value: houseDraw ? controller.value : 0,
                      semanticsLabel: 'Linear progress indicator',
                    ),
                  ),
                ),
                Icon(
                  Icons.home,
                  color: Colors.blue,
                  size: 60.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
              ],
            ),
          ),
          RotatedBox(
            quarterTurns: -1,
            child: SizedBox(
              width: 80,
              height: 10,
              child: LinearProgressIndicator(
                color: CupertinoColors.activeGreen,
                value: gridDraw ? controller.value : 0,
                semanticsLabel: 'Linear progress indicator',
              ),
            ),
          ),
          Icon(
            Icons.electric_bolt,
            color: Colors.yellow,
            size: 60.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
        ],
      ),
    );
  }
}

class HOME extends StatefulWidget {
  HOME({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HOME> with TickerProviderStateMixin {
  final controller = PageController();
  int tabIndex = 0;
  late AnimationController animateController;

  void initState() {
    ///needed to animate loading bars
    animateController = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].

      duration: const Duration(seconds: 2), vsync: this,
    )..addListener(() {
      setState(() {});
    });
    animateController.repeat();
    super.initState();
  }

  List<ChartData> chartData = [
    ChartData('Solar', 100), // Replace 100 with the actual solar usage in kWh
    ChartData('Grid', 200), // Replace 200 with the actual grid usage in kWh
    ChartData('Battery', 50), // Replace 50 with the actual battery usage in kWh
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title ?? ''),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Title widget

            // Your existing widget here
            MyCustomWidget(controller: animateController),
            // Replace with your custom widget

            // Tabs
            DefaultTabController(
              length: 3,
              initialIndex: tabIndex,
              child: Column(
                children: <Widget>[
                  TabBar(
                    tabs: [
                      Tab(text: 'Loadshedding'),
                      Tab(text: 'Usage'),
                      Tab(text: 'Statistics'),
                    ],
                    onTap: (index) {
                      setState(() {
                        tabIndex = index;
                      });
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height *
                        0.4, // Adjust the height as needed
                    child: TabBarView(
                      children: [
                        // Loadshedding tab content
                        Center(child: Text('Loadshedding Content')),

                        // Usage tab content
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                EdgeInsets.all(0), // Set padding to zero
                                child: Text(
                                  'Energy Usage',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                EdgeInsets.all(0), // Set padding to zero
                                child: SfCircularChart(
                                  legend: Legend(
                                      isVisible: true), // Show the legend
                                  series: <CircularSeries>[
                                    DoughnutSeries<ChartData, String>(
                                      dataSource: chartData,
                                      xValueMapper: (ChartData data, _) =>
                                      data.x,
                                      yValueMapper: (ChartData data, _) =>
                                      data.y,
                                      // Radius of doughnut
                                      radius: '50%',
                                      // Customize segment colors
                                      pointColorMapper: (ChartData data, _) {
                                        switch (data.x) {
                                          case 'Solar':
                                            return Colors.yellow;
                                          case 'Grid':
                                            return Colors.blue;
                                          case 'Battery':
                                            return Colors.green;
                                          default:
                                            return Colors.transparent;
                                        }
                                      },
                                      dataLabelMapper: (ChartData data, _) =>
                                      '${data.y} kWh',
                                      dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        labelPosition:
                                        ChartDataLabelPosition.outside,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        // Statistics tab content
                        Center(child: Text('Statistics Content')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
