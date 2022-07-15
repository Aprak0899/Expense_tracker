import 'dart:async';
import 'dart:math';
import 'package:expanse_tracker/models/transaction_data_bank.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(alpha, (red * value).round(), (green * value).round(),
        (blue * value).round());
  }
}

class BarChartSample1 extends StatefulWidget {
  const BarChartSample1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = const Color(0xff72d8bf);

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: const Color(0xff81e5cd),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        mainBarData(),
                      ),
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

  //here you can alter upper limit of y axis
  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          //when you touch the rod it will increase by 1 showing the effect that it is on pressed
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow.darken(), width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            //upper limit of Y axis
            toY: 10,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  //need to modify this to show our data for transactions and upper limit in makeGroupData
  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
                0,
                Provider.of<TransactionDataBank>(context)
                            .getDailyTotalList()
                            .length ==
                        0
                    ? 0
                    : Provider.of<TransactionDataBank>(context)
                        .getDailyTotalList()[0],
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(
                1,
                Provider.of<TransactionDataBank>(context)
                            .getDailyTotalList()
                            .length ==
                        0
                    ? 0
                    : Provider.of<TransactionDataBank>(context)
                        .getDailyTotalList()[1],
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(
                2,
                Provider.of<TransactionDataBank>(context)
                            .getDailyTotalList()
                            .length ==
                        0
                    ? 0
                    : Provider.of<TransactionDataBank>(context)
                        .getDailyTotalList()[2],
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(
                3,
                Provider.of<TransactionDataBank>(context)
                            .getDailyTotalList()
                            .length ==
                        0
                    ? 0
                    : Provider.of<TransactionDataBank>(context)
                        .getDailyTotalList()[3],
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(
                4,
                Provider.of<TransactionDataBank>(context)
                            .getDailyTotalList()
                            .length ==
                        0
                    ? 0
                    : Provider.of<TransactionDataBank>(context)
                        .getDailyTotalList()[4],
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(
                5,
                Provider.of<TransactionDataBank>(context)
                            .getDailyTotalList()
                            .length ==
                        0
                    ? 0
                    : Provider.of<TransactionDataBank>(context)
                        .getDailyTotalList()[5],
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(
                6,
                Provider.of<TransactionDataBank>(context)
                            .getDailyTotalList()
                            .length ==
                        0
                    ? 0
                    : Provider.of<TransactionDataBank>(context)
                        .getDailyTotalList()[6],
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      //takes data from y axis
      //!! why touch and hold ?
      barTouchData: BarTouchData(
        //on touchandhold show tool tip which is a popcard that shows day and data of y axis for that bar
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    //rod length on y axis
                    text:
                        "${double.parse(((rod.toY - 1) * 10).toStringAsFixed(2)).toString()} %",
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        //get the index of the bar that is touched and store in the state param declare as prop above
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            //print("touchedIndex = ${touchedIndex}");
          });
        },
      ),
      //show data for x axis labelling for day (M,T,W,....)
      //controls rod length and space btw rod and label
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            //callback method that holds data to set labels
            getTitlesWidget: getTitles,
            //earlier 38 -  controls the rod length
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      //border around the rods and not the labels
      borderData: FlBorderData(
        // show: true,
        // border: Border.all(
        //     color: Colors.black, width: 1.0, style: BorderStyle.solid)
        // for no border
        show: false,
      ),
      //main data for bar
      barGroups: showingGroups(),
      //grid like the once we use to draw graph in maths class on a graph chart
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      //you get this from callback
      axisSide: meta.axisSide,
      //controlls space btw rod and this text
      space: 12,
      child: text,
    );
  }
}
