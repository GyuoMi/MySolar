import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:based_battery_indicator/based_battery_indicator.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../API\'s/WeatherApi.dart';

class MyCustomWidget extends StatelessWidget {
  final AnimationController controller1;
  final AnimationController controller2;
  int count = 0;
  final WeatherService weatherService =
  WeatherService('fbf149b715cc45e8972112241232509');
  Future<String?> getWeather() async {
    //print(weatherInfo);
    try {
      Map<String, dynamic> extractedInfo = await weatherService.getWeather("Johannesburg");

      // Extract the relevant weather information from extractedInfo
      // String location = extractedInfo['location']; // Replace with the actual key for location
      // String temperature = extractedInfo['temperature']; // Replace with the actual key for temperature
      String conditionICON = extractedInfo['ConditionICON']; // Replace with the actual key for condition

      // Create a formatted string with the weather information
      String weatherInfo ="https:$conditionICON";
      count ++;
      //print(weatherInfo);

      return weatherInfo;
     } catch (e) {
    //   // Handle any potential errors here
    //   print("Error fetching weather: $e");
    //   return null;
     }
  }

  MyCustomWidget({required this.controller1, required this.controller2});
  int weather = 1;
  bool charging = true;
  bool houseDraw = true;
  bool solarDraw = true;
  bool gridDraw = false;
  int batteryPer = 45;
  FutureBuilder<String?> getWeatherIcon() {
    return FutureBuilder<String?>(
      future: getWeather(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        IconData iconData = Icons.error; // Default icon for error case
        Color color = Colors.red; // Default color for error case
        if (count < 1) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the Future is still running, show a loading indicator or placeholder
            return CircularProgressIndicator(); // Or any other loading indicator widget
          } else if (snapshot.hasError || snapshot.data == null) {
            // If there was an error fetching data or the data is null, display an error message
            print("Error fetching weather: ${snapshot.error}");
            return Icon(iconData, color: color); // Display a default error icon
          } else {
            // Data fetched successfully, display the weather icon
            String conditionCode = snapshot.data!; // The URL obtained from getWeather
            return Container(
              width: 64,
              height: 64,
              child: Image.network(
                conditionCode,
                color: color,
              ),
            );
          }
        } else {
          // Handle the case when count is not less than 1 (optional)
          return Container();
        }
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    Widget weatherIcon = getWeatherIcon();
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
                      value: charging ? controller2.value : controller1.value,
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
    ChartData('Solar', 50), // Example data for the weekly view
    ChartData('Grid', 75), // Example data for the weekly view
    ChartData('Battery', 30), // Example data for the weekly view
  ];

  List<ChartData> weeklyChartData = [
    ChartData('Solar', 70), // Example data for the weekly view
    ChartData('Grid', 160), // Example data for the weekly view
    ChartData('Battery', 70), // Example data for the weekly view
  ];

  List<ChartData> monthlyChartData = [
    ChartData('Solar', 300), // Example data for the monthly view
    ChartData('Grid', 500), // Example data for the monthly view
    ChartData('Battery', 150), // Example data for the monthly view
  ];

  List<ChartData> totalChartData = [
    ChartData('Solar', 1000), // Example data for the total view
    ChartData('Grid', 1500), // Example data for the total view
    ChartData('Battery', 500), // Example data for the total view
  ];

  //example data for line graph
  List<LineGraphData> LGData = [
    LineGraphData('00:00', 1, 3, 2),
    LineGraphData('03:00', 4, 2, 1),
    LineGraphData('09:00', 2, 1, 0),
    LineGraphData('12:00', 4, 0, 3),
    LineGraphData('15:00', 5, 4, 5),
    LineGraphData('18:00', 1, 6, 0),
    LineGraphData('21:00', 3, 2, -2),
    LineGraphData('23:59', 6, 1, 1),
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
            MyCustomWidget(
              controller1: controller1,
              controller2: controller2,
            ),
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
                                    margin: const EdgeInsets.all(
                                        0), // Set padding to zero
                                    child: const Text(
                                      'Daily Energy Usage',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment
                                        .topCenter, // Set padding to zero
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
                                          pointColorMapper:
                                              (ChartData data, _) {
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
                                          dataLabelMapper:
                                              (ChartData data, _) =>
                                          '${data.y} kWh',
                                          dataLabelSettings:
                                          const DataLabelSettings(
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
                                    padding: EdgeInsets.all(
                                        0), // Set padding to zero
                                    child: Text(
                                      'Weekly Energy Usage',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        0), // Set padding to zero
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
                                          pointColorMapper:
                                              (ChartData data, _) {
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
                                          dataLabelMapper:
                                              (ChartData data, _) =>
                                          '${data.y} kWh',
                                          dataLabelSettings:
                                          const DataLabelSettings(
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
                                    padding: EdgeInsets.all(
                                        0), // Set padding to zero
                                    child: Text(
                                      'Monthly Energy Usage',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        0), // Set padding to zero
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
                                          pointColorMapper:
                                              (ChartData data, _) {
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
                                          dataLabelMapper:
                                              (ChartData data, _) =>
                                          '${data.y} kWh',
                                          dataLabelSettings:
                                          const DataLabelSettings(
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
                                    padding: EdgeInsets.all(
                                        0), // Set padding to zero
                                    child: Text(
                                      'Total Energy Usage',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        0), // Set padding to zero
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
                                          pointColorMapper:
                                              (ChartData data, _) {
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
                                          dataLabelMapper:
                                              (ChartData data, _) =>
                                          '${data.y} kWh',
                                          dataLabelSettings:
                                          const DataLabelSettings(
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
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Align(
                                alignment:
                                Alignment.topCenter, // Set padding to zero
                                child: SfCartesianChart(
                                  plotAreaBorderWidth: 0,
                                  primaryXAxis: CategoryAxis(
                                    title: AxisTitle(text: 'Time'),
                                    majorGridLines: MajorGridLines(width: 0.5),
                                    labelRotation: -45,
                                    labelStyle: TextStyle(fontSize: 12),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    title: AxisTitle(text: 'Power (kW)'),
                                    majorGridLines: MajorGridLines(width: 0.5),
                                    labelStyle: TextStyle(fontSize: 12),
                                  ),
                                  //production power
                                  series: <ChartSeries<LineGraphData, String>>[
                                    StackedLineSeries<LineGraphData, String>(
                                      dataSource: LGData,
                                      xValueMapper: (LineGraphData power, _) =>
                                      power.LGx,
                                      yValueMapper: (LineGraphData power, _) =>
                                      power.LGy,
                                      name: " Production",
                                      color: Colors.blue,
                                      width: 3,
                                    ),
                                    //consumption power
                                    StackedLineSeries<LineGraphData, String>(
                                      dataSource: LGData,
                                      xValueMapper: (LineGraphData power, _) =>
                                      power.LGx,
                                      yValueMapper: (LineGraphData power, _) =>
                                      power.LGy2,
                                      name: " Consumption",
                                      color: Colors.red,
                                      width: 3,
                                    ),
                                    //battery power
                                    StackedLineSeries<LineGraphData, String>(
                                      dataSource: LGData,
                                      xValueMapper: (LineGraphData power, _) =>
                                      power.LGx,
                                      yValueMapper: (LineGraphData power, _) =>
                                      power.LGy3,
                                      name: " Battery",
                                      color: Colors.green,
                                      width: 3,
                                    ),
                                  ],
                                  title: ChartTitle(
                                    text: 'Hourly Statistics',
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  legend: Legend(
                                    isVisible: true,
                                    overflowMode: LegendItemOverflowMode.wrap,
                                    //orientation: LegendItemOrientation.vertical,
                                    position: LegendPosition.bottom,
                                    textStyle: TextStyle(fontSize: 10),
                                    padding: 2,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
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

//usage chart data
class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}

//statistics chart data
class LineGraphData {
  final String LGx;
  final double LGy;
  final double LGy2;
  final double LGy3;

  LineGraphData(this.LGx, this.LGy, this.LGy2, this.LGy3);
}