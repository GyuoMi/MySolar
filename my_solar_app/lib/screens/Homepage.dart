import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:based_battery_indicator/based_battery_indicator.dart';
import 'package:my_solar_app/cloud_functions/authentication/auth_repository.dart';
import 'package:my_solar_app/cloud_functions/authentication/interfaces/auth_repository_interface.dart';
import 'package:my_solar_app/screens/login_page.dart';
import 'package:my_solar_app/widgets/drawer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../API\'s/WeatherApi.dart';
import '../../API\'s/LoadSheddingAPI.dart';
import '../API\'s/loadsheddingFunctions.dart';

import '../cloud_functions/database/database_api.dart';
import '../cloud_functions/database/interfaces/database_functions_interface.dart';
import '../models/logged_in_user.dart';
import 'package:my_solar_app/screens/devices.dart';
import 'package:http/http.dart' as http;

import 'package:rating_dialog/rating_dialog.dart';

class MyCustomWidget extends StatefulWidget {
  const MyCustomWidget({
    Key? key,
    required this.controller1,
    required this.controller2,
  }) : super(key: key);

  final AnimationController controller1;
  final AnimationController controller2;

  @override
  _MyCustomWidgetState createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget> {
  final WeatherService weatherService =
  WeatherService('93ff5e1b86ec4bddaa5194216230310');

  late Map<dynamic, dynamic> totals;
  IDatabaseFunctions database = DatabaseApi();
  Future<void> getTotals() async {
    final databaseReturn = await database.calculateAllTimeTotals(
        LoggedInUser.getUserId()); // Get the weather info

    // When you have the weatherInfo, update the URL and trigger a UI update
    setState(() {
      totals = databaseReturn;
    });
    uiCalculations();
  }

  void uiCalculations() {
    double grid = totals['total_grid'];
    double usage = totals['total_usage'];
    double solar = totals['total_solar'];
    double produced = totals['total_production'];
    double battery = usage - grid - solar;

    if (usage < produced) {
      setState(() {
        charging = true;
      });
    } else {
      setState(() {
        charging = false;
      });
    }
    if (battery > 0) {
      setState(() {
        charging = false;
      });
    }
    if (grid > 0) {
      setState(() {
        gridDraw = true;
      });
    } else {
      setState(() {
        gridDraw = true;
      });
    }
    if (solar > 0 && time == 'day' && time !='') {
      setState(() {
        solarDraw = true;
      });
    } else {
      setState(() {
        solarDraw = false;
      });
    }



    if (usage > 0) {
      setState(() {
        houseDraw = true;
      });
    } else {
      setState(() {
        houseDraw = true;
      });
    }
  }

  Future<String?> getWeather() async {
    //print(weatherInfo);
    try {
      Map<String, dynamic> extractedInfo =
      await weatherService.getWeather("Johannesburg");

      // Extract the relevant weather information from extractedInfo
      // String location = extractedInfo['location']; // Replace with the actual key for location
      // String temperature = extractedInfo['temperature']; // Replace with the actual key for temperature
      String conditionICON = extractedInfo[
      'ConditionICON']; // Replace with the actual key for condition

      // Create a formatted string with the weather information
      String weatherInfo = "https:$conditionICON";

      setState(() {
        url = weatherInfo;
      });
      return weatherInfo;
    } catch (e) {
      // Handle any potential errors here

      print("Error fetching weather: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    getWeatherIcon();

    // loadSheddingStatus = fetchLoadSheddingStatus();
  }

  bool charging = false;
  bool houseDraw = false;
  bool solarDraw = false;
  bool gridDraw = false;
  int batteryPer = 45;
  String url = "";
  String time = "";

  Future<void> getWeatherIcon() async {
    final weatherInfo = await getWeather(); // Get the weather info
    String time = '';
    // When you have the weatherInfo, update the URL and trigger a UI update
    setState(() {
      url = weatherInfo!;
      // Extract the word before the number using a regular expression
      final match = RegExp(r'\/(\w+)\/\d+\.png').firstMatch(weatherInfo);
      if (match != null) {
        time = match.group(1)!;
      }
      if (time != 'day' && time != '') {
        solarDraw = false;
      }
    });
    getTotals();
  }


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
              (url.isNotEmpty)
                  ? Container(
                width: 64,
                height: 64,
                child: Image.network(url),
              )
                  : CircularProgressIndicator(),
              RotatedBox(
                quarterTurns: 1,
                child: SizedBox(
                  width: 80,
                  height: 10,
                  child: LinearProgressIndicator(
                    color: CupertinoColors.activeGreen,
                    value: solarDraw ? widget.controller1.value : 0,
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
                      value: charging
                          ? widget.controller2.value
                          : widget.controller1.value,
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
                      value: houseDraw ? widget.controller2.value : 0,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            DevicesPage(), // Navigate to DevicesPage
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.home,
                    color: Colors.blue,
                    size: 60.0,
                  ),
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
                value: gridDraw ? widget.controller1.value : 0,
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
  LoadSheddingService service = LoadSheddingService();
  late Map<String, dynamic> allTimeTotal;
  late Map<String, dynamic> dailyTotal;
  late Map<String, dynamic> weeklyTotal;
  late Map<String, dynamic> monthlyTotal;
  late List<dynamic> hourlyTotal;
  IDatabaseFunctions database = DatabaseApi();

  Future<void> getTotals() async {
    final databaseReturnAll =
    await database.calculateAllTimeTotals(LoggedInUser.getUserId());
    final databaseReturnWeek =
    await database.calculateWeeklyTotals(LoggedInUser.getUserId());
    final databaseReturnMonth =
    await database.calculateMonthlyTotals(LoggedInUser.getUserId());
    final databaseReturnDay =
    await database.calculateDailyTotals(LoggedInUser.getUserId());
    final databaseReturnHour =
    await database.getHourlyTotals(LoggedInUser.getUserId());
    //final databaseReturnHr = await database.getHourlyTotals(LoggedInUser.getUserId());
    // When you have the weatherInfo, update the URL and trigger a UI update
    setState(() {
      allTimeTotal = databaseReturnAll;
      dailyTotal = databaseReturnDay;
      weeklyTotal = databaseReturnWeek;
      monthlyTotal = databaseReturnMonth;
      hourlyTotal = databaseReturnHour;
    });
    print(hourlyTotal);
    roundChartData();
    lineGraphData();
  }

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

  int loadSheddingStatus = 1000;

  Future<int> fetchLoadSheddingStatus() async {
    // Fetch the load shedding status using your API service
    // Replace 'loadSheddingService' with your actual instance of the LoadSheddingService class

    return service.getStatus();
  }

  Future<void> getLoadshedding() async {
    final loadshedding =
    await fetchLoadSheddingStatus(); // Get the weather info

    // When you have the weatherInfo, update the URL and trigger a UI update
    setState(() {
      loadSheddingStatus = loadshedding - 1;
    });
  }

  Future<void> loadshedding() async {
    final String url =
        "https://developer.sepush.co.za/business/2.0/areas_search?text=constansia-kloof";
    final Map<String, String> headers = {
      "token": "DAB1EF89-2748405F-9FD69CF5-866DFEEE",
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    getLoadshedding();
    getTotals();
    loadshedding();
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

  void roundChartData() {
    final random = Random();
    final randomNumber = 15 + random.nextInt(45 - 15 + 1);

    double solarT = allTimeTotal['total_solar'] / 1000;
    double gridT = allTimeTotal['total_grid'] / 1000;
    double calcT = gridT * (randomNumber / 100);
    gridT -= calcT;
    double batT = calcT;
    totalChartData = [
      ChartData(
          'Solar', solarT.roundToDouble()), // Example data for the weekly view
      ChartData(
          'Grid', gridT.roundToDouble()), // Example data for the weekly view
      ChartData(
          'Battery', batT.roundToDouble()), // Example data for the weekly view
    ];

    double solarD = dailyTotal['total_solar'] / 1000;
    double gridD = dailyTotal['total_grid'] / 1000;
    double calcD = gridD * (randomNumber / 100);
    gridD -= calcD;
    double batD = calcD;
    dailyChartData = [
      ChartData(
          'Solar', solarD.roundToDouble()), // Example data for the weekly view
      ChartData(
          'Grid', gridD.roundToDouble()), // Example data for the weekly view
      ChartData(
          'Battery', batD.roundToDouble()), // Example data for the weekly view
    ];

    double solarW = weeklyTotal['total_solar'] / 1000;
    double gridW = weeklyTotal['total_grid'] / 1000;
    double calcW = gridW * (randomNumber / 100);
    gridW -= calcW;
    double batW = calcW;
    weeklyChartData = [
      ChartData(
          'Solar', solarW.roundToDouble()), // Example data for the weekly view
      ChartData(
          'Grid', gridW.roundToDouble()), // Example data for the weekly view
      ChartData(
          'Battery', batW.roundToDouble()), // Example data for the weekly view
    ];

    double solarM = monthlyTotal['total_solar'] / 1000;
    double gridM = monthlyTotal['total_grid'] / 1000;
    double calcM = gridM * (randomNumber / 100);
    gridM -= calcM;
    double batM = calcW;
    monthlyChartData = [
      ChartData(
          'Solar', solarM.roundToDouble()), // Example data for the weekly view
      ChartData(
          'Grid', gridM.roundToDouble()), // Example data for the weekly view
      ChartData(
          'Battery', batM.roundToDouble()), // Example data for the weekly view
    ];
  }

  void lineGraphData() {
    for (var element in hourlyTotal) {
      // Checking if the element is a Map
      if (element is Map<String, dynamic>) {
        // Accessing properties of the element
        String recordInterval = element["record_interval"];
        num production = element["total_production"];
        num usage = element["total_usage"];
        num solar = element["total_solar"];

        LGData.add(LineGraphData(recordInterval, production.toDouble() / 1000,
            usage.toDouble() / 1000, solar.toDouble() / 1000));
      }
    }
  }

  List<ChartData> dailyChartData = [
    ChartData('Solar', 1), // Example data for the weekly view
    ChartData('Grid', 1), // Example data for the weekly view
    ChartData('Battery', 1), // Example data for the weekly view
  ];

  List<ChartData> weeklyChartData = [
    ChartData('Solar', 1), // Example data for the weekly view
    ChartData('Grid', 1), // Example data for the weekly view
    ChartData('Battery', 1), // Example data for the weekly view
  ];

  List<ChartData> monthlyChartData = [
    ChartData('Solar', 1), // Example data for the monthly view
    ChartData('Grid', 1), // Example data for the monthly view
    ChartData('Battery', 1), // Example data for the monthly view
  ];

  List<ChartData> totalChartData = [
    ChartData('Solar', 1), // Example data for the total view
    ChartData('Grid', 1), // Example data for the total view
    ChartData('Battery', 1), // Example data for the total view
  ];

  //example data for line graph
  List<LineGraphData> LGData = [
    // LineGraphData('00:00', 1, 3, 2),
    // LineGraphData('03:00', 4, 2, 1),
    // LineGraphData('09:00', 2, 1, 0),
    // LineGraphData('12:00', 4, 0, 3),
    // LineGraphData('15:00', 5, 4, 5),
    // LineGraphData('18:00', 1, 6, 0),
    // LineGraphData('21:00', 3, 2, -2),
    // LineGraphData('23:59', 6, 1, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Dashboard'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu), // Hamburger menu icon
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              IAuthRepository ar = AuthRepository();
              ar.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
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
                        if (loadSheddingStatus != 1000)
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                LoadShedding(),
                                (loadSheddingStatus == 0)
                                    ? Text('No Load Shedding Currently')
                                    : Text(
                                    'Load Shedding Status: Stage $loadSheddingStatus'),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ),
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

  void showRating() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Container(
            color: Colors.white,
            child: RatingDialog(
              //MY SOLAR LOGO
              image: Image.asset(
                'assets/images/my_solar.png',
                width: 125,
              ),
              title: Text(
                "Liked our app?",
                textAlign: TextAlign.center,
              ),
              message: Text(
                "Leave your rating",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              starColor: Color.fromARGB(255, 247, 197, 47),
              submitButtonText: "Submit rating",
              //RATING SUBMITTED BY USER
              onSubmitted: (response) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginPage(
                        //testFlag: false,
                      )),
                );
              },
              enableComment: false,
              //CHOSE TO NOT RATE AND LEAVE PAGE
              onCancelled: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginPage(
                      //testFlag: false,
                    )),
              ),
            ),
          );
        });
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