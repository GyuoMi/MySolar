import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:based_battery_indicator/based_battery_indicator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';

class MyCustomWidget extends StatelessWidget {
  final AnimationController controller;

  MyCustomWidget({required this.controller});

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
                    value: controller.value,
                    semanticsLabel: 'Linear progress indicator',
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 135.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BasedBatteryIndicator(
                  status: BasedBatteryStatus(
                    value: 60,

                    ///change charge value
                    type: BasedBatteryStatusType.charging,

                    ///change its state eg charging vs normal
                  ),
                  trackHeight: 50.0,
                  trackAspectRatio: 2.0,
                  curve: Curves.ease,
                  duration: const Duration(seconds: 1),
                ),
                RotatedBox(
                  quarterTurns: 0,
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
                value: controller.value,
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
    )
      ..addListener(() {
        setState(() {});
      });
    animateController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title ?? ''),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Your widget here
            MyCustomWidget(
                controller: animateController),
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
                    height: MediaQuery
                        .of(context)
                        .size
                        .height *
                        0.4, // Adjust the height as needed
                    child: TabBarView(
                      children: [
                        // Loadshedding tab content
                        Center(child: Text('Loadshedding Content')),

                        // Usage tab content
                        Center(child: Text('Usage Content')),

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