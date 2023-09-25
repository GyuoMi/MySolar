import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:based_battery_indicator/based_battery_indicator.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../API\'s/WeatherApi.dart';


class MyCustomWidget extends StatelessWidget {
 final AnimationController controller1;
  final AnimationController controller2;
 final WeatherService weatherService= WeatherService('fbf149b715cc45e8972112241232509');



  MyCustomWidget({required this.controller1,required this.controller2});
  int weather=1;
  bool charging = true;
  bool houseDraw = true;
  bool solarDraw = true;
  bool gridDraw = false;
  int batteryPer = 45;
  Widget getWeatherIcon(int weatherCode) {
    IconData iconData;
    Color color;

    switch (weatherCode) {
      case 0:
        iconData = WeatherIcons.day_sunny; // Sun
        color = Colors.yellow;
        break;
      case 1:
        iconData = WeatherIcons.day_cloudy; // Sun and cloud
        color = Colors.lightBlueAccent;
        break;
      case 2:
        iconData = WeatherIcons.cloud; // Cloud
        color = Colors.blueGrey;
        break;
      case 3:
        iconData = WeatherIcons.rain; // Rain (You can change this to a rain icon)
        color = Colors.blueAccent;
        break;
      case 4:
        iconData = WeatherIcons.stars; // Night
        color = Colors.black;
        break;
      default:
        iconData = WeatherIcons.day_haze; // Default icon for unknown weather code
        color = Colors.black;
    }

    return BoxedIcon(
      iconData,
      color: color,
      size: 60.0,

    );
  }
  @override
  Widget build(BuildContext context) {
    Widget weatherIcon = getWeatherIcon(weather);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              weatherIcon,
              RotatedBox(
                quarterTurns: 1,
                child: SizedBox(
                  width: 80,
                  height: 10,
                  child: LinearProgressIndicator(
                    color: CupertinoColors.activeGreen,
                    value: solarDraw ? controller1.value : 0,

                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
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
                      value: charging ? controller2.value :controller1.value,

                    ),
                  ),
                ),
                const Icon(
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
                      value: houseDraw ? controller2.value : 0,

                    ),
                  ),
                ),
                const Icon(
                  Icons.home,
                  color: Colors.blue,
                  size: 60.0,

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
                value: gridDraw ? controller1.value : 0,

              ),
            ),
          ),
          const Icon(
            Icons.electric_bolt,
            color: Colors.yellow,
            size: 60.0,

          ),
        ],
      ),
    );
  }
}
PageController _pageController = PageController(initialPage: 0);
class HOME extends StatefulWidget {
  const HOME({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HOME> with TickerProviderStateMixin {
  final controller = PageController();
  int tabIndex = 0;
  late AnimationController controller1;
  late AnimationController controller2;


  void startAnimation1() {
    controller1.forward().then((_) {
      // Wait for 2 seconds
      controller1.reset();

    }).then((_) {
      // Reset the first animation to zero and start the second animation

      startAnimation2();
    });
  }

  void startAnimation2() {
    controller2.forward().then((_) {
      // Wait for 2 seconds
      controller2.reset();

    }).then((_) {
      // Reset the first animation to zero and start the second animation

      startAnimation1();
    });
  }

  @override
  void initState() {
    super.initState();
    controller1 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    controller2 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    controller1.addListener(() {
      setState(() {});
    });
    controller2.addListener(() {
      setState(() {});
    });

    // Start the first animation
    startAnimation1();
  }
  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  List<ChartData> dailyChartData = [
    ChartData('Solar', 50),   // Example data for the weekly view
    ChartData('Grid', 75),    // Example data for the weekly view
    ChartData('Battery', 30), // Example data for the weekly view
  ];

  List<ChartData> weeklyChartData = [
    ChartData('Solar', 70),   // Example data for the weekly view
    ChartData('Grid', 160),    // Example data for the weekly view
    ChartData('Battery', 70), // Example data for the weekly view
  ];

  List<ChartData> monthlyChartData = [
    ChartData('Solar', 300),   // Example data for the monthly view
    ChartData('Grid', 500),    // Example data for the monthly view
    ChartData('Battery', 150), // Example data for the monthly view
  ];

  List<ChartData> totalChartData = [
    ChartData('Solar', 1000),   // Example data for the total view
    ChartData('Grid', 1500),    // Example data for the total view
    ChartData('Battery', 500),  // Example data for the total view
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
            MyCustomWidget(controller1: controller1,controller2: controller2,),
            // Replace with your custom widget

            // Tabs
            DefaultTabController(
              length: 3,
              initialIndex: tabIndex,
              child: Column(
                children: <Widget>[
                  TabBar(
                    tabs: const [
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

                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.4, // Adjust the height as needed
                    child: TabBarView(
                      children: [
                        // Loadshedding tab content
                        const Center(child: Text('Loadshedding Content')),

                        // Usage tab content
                      PageView(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        children: [
                          ///daily usage
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin:
                                  const EdgeInsets.all( 0), // Set padding to zero
                                  child: const Text(
                                    'Daily Energy Usage',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment:
                                  Alignment.topCenter, // Set padding to zero
                                  child: SfCircularChart(
                                    legend: const Legend(
                                        isVisible: true), // Show the legend
                                    series: <CircularSeries>[
                                      DoughnutSeries<ChartData, String>(
                                        dataSource: dailyChartData,
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
                                        dataLabelSettings: const DataLabelSettings(
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
                          ///weekly usage
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Padding(
                                  padding:
                                  EdgeInsets.all(0), // Set padding to zero
                                  child: Text(
                                    'Weekly Energy Usage',
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
                                    legend: const Legend(
                                        isVisible: true), // Show the legend
                                    series: <CircularSeries>[
                                      DoughnutSeries<ChartData, String>(
                                        dataSource: weeklyChartData,
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
                                        dataLabelSettings: const DataLabelSettings(
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

                          ///monthly data
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Padding(
                                  padding:
                                  EdgeInsets.all(0), // Set padding to zero
                                  child: Text(
                                    'Monthly Energy Usage',
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
                                    legend: const Legend(
                                        isVisible: true), // Show the legend
                                    series: <CircularSeries>[
                                      DoughnutSeries<ChartData, String>(
                                        dataSource: monthlyChartData,
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
                                        dataLabelSettings: const DataLabelSettings(
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

                          ///total data
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Padding(
                                  padding:
                                  EdgeInsets.all(0), // Set padding to zero
                                  child: Text(
                                    'Total Energy Usage',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.all(0), // Set padding to zero
                                  child: SfCircularChart(
                                    legend: const Legend(
                                        isVisible: true), // Show the legend
                                    series: <CircularSeries>[
                                      DoughnutSeries<ChartData, String>(
                                        dataSource: totalChartData,
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
                                        dataLabelSettings: const DataLabelSettings(
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
                        ],
                      ),

                        // Statistics tab content
                        const Center(child: Text('Statistics Content')),
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
