import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:pare/src/Analytic_views/ListOfSelectedSpend.dart';
import 'package:pare/src/provider/para_service.dart';
import 'package:pare/src/Analytic_views/PieChartSampleV2.dart';
import 'package:pare/src/tools/SPColors.dart';
import 'package:provider/provider.dart';

class MainAnalyticView extends StatefulWidget {
  MainAnalyticView({Key? key}) : super(key: key);

  late ParaService _paraProvider;
  @override
  State<MainAnalyticView> createState() => _MainAnalyticViewState();
}

Map<int, String> monthArr = {
  // 0: '  All  ',
  0: 'January',
  1: 'February',
  2: 'March',
  3: 'April',
  4: 'May',
  5: 'June',
  6: 'July',
  7: 'August',
  8: 'September',
  9: 'October',
  10: 'November',
  11: 'December',
};

Map<int, String> monthArrShort = {
  // 0: '  All  ',
  0: 'Jan',
  1: 'Feb',
  2: 'Mar',
  3: 'Apr',
  4: 'May',
  5: 'Jun',
  6: 'Jul',
  7: 'Aug',
  8: 'Sep',
  9: 'Oct',
  10: 'Nov',
  11: 'Dec',
};

Map<int, int> yearArr = {};

class _MainAnalyticViewState extends State<MainAnalyticView> {
  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Spend", style: TextStyle(fontWeight: FontWeight.w900)),
    1: Text("Income", style: TextStyle(fontWeight: FontWeight.w900)),
  };

  DateTime? selectedDay = null;

  int selectedMonthIndex = -1;
  int selectedYearIndex = -1;
  bool isSetSalar = false;
  String dateText = '';
  @override
  Widget build(BuildContext context) {
    widget._paraProvider = Provider.of<ParaService>(context, listen: true);

    if (!isSetSalar && widget._paraProvider.itemsCategoriesIncome.isEmpty) {
      isSetSalar = !isSetSalar;
      // _paraProvider!.deleteAll();
      widget._paraProvider.firstInitialize();
    }

    if (widget._paraProvider.listPara.length != 0) {
      selectedDay ??= widget._paraProvider.listPara.first.createdAt!.toDate();

      if (selectedMonthIndex == -1) {
        selectedMonthIndex = DateTime.now().month - 1;
      }

      if (selectedYearIndex == -1) {
        selectedYearIndex = DateTime.now().year;
        yearArr.forEach((key, value) {
          if (value == DateTime.now().year) {
            selectedYearIndex = key;
          }
        });
      }

      return Scaffold(
        //appBar: AppBar(),
        body: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            SPColors.blueColor,
                            SPColors.lighten(SPColors.blueColor, 0.2)
                          ]),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: dateSelector(),
                    ),
                  ),
                ),
              ],
            ),

            Container(
              padding: EdgeInsets.only(top: 30, bottom: 0, left: 20, right: 20),
              width: MediaQuery.of(context).size.width * 0.70,
              child: CupertinoSlidingSegmentedControl(
                  thumbColor: segmentedControlGroupValue == 0
                      ? Colors.red[300]!
                      : Colors.green[300]!,
                  padding: EdgeInsets.all(5),
                  groupValue: segmentedControlGroupValue,
                  children: myTabs,
                  onValueChanged: (i) {
                    setState(() {
                      segmentedControlGroupValue = i is int ? i as int : 0;
                    });
                  }),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: LineChartSample2(
            //     isSpend: segmentedControlGroupValue == 0,
            //     selectedMonth: selectedMonthIndex,
            //     selectedYear: selectedYearIndex,
            //   ),
            // ),

            PieChartSampleV2(
              isSpend: segmentedControlGroupValue == 0,
              selectedMonth: selectedMonthIndex,
              selectedYear: selectedYearIndex,
            ),

            ListOfSelectedSpend(
              isSpend: segmentedControlGroupValue == 0,
              selectedMonth: selectedMonthIndex,
              selectedYear: selectedYearIndex,
            ),

            // PieChartSampleSpend(isSpend: segmentedControlGroupValue == 0),

            // BarChartSample1(),
            // BarChartSample2(),//tow line
            // BarChartSample3(),
            // BarChartSample4(), //lines
            // BarChartSample5(),
            // LineChartSample1(),//waves

            // LineChartSample3(),
            // LineChartSample4(),
            // LineChartSample5(),
            // // LineChartSample6(),
            // LineChartSample7(),
            // // LineChartSample9(),
            // // LineChartSample10(),

            // PieChartSample1(),
            // PieChartSample2(),
          ],
        ),
      );
    } else {
      return Scaffold(
        //appBar: AppBar(),
        body: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            SPColors.blueColor,
                            SPColors.lighten(SPColors.blueColor, 0.2)
                          ]),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                      ),
                    ),
                    child: const Padding(
                      padding: const EdgeInsets.all(30),
                      child: Center(
                          child: Text(
                        'Add Records to show analytics',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: Lottie.asset('assets/data_analitics_2.json'))
          ],
        ),
      );
    }
  }

  Widget dateSelector() {
    return Column(
      children: [
        yearArr.isEmpty ? Container() : YearSelector(),
        MonthSelector(),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget MonthSelector() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          // scrollDirection: Axis.horizontal,
          children: List<Widget>.generate(monthArrShort.length, (index) {
            return GestureDetector(
              onTap: () {
                if (Provider.of<ParaService>(context, listen: false)
                    .listParaDateTime
                    .keys
                    .toList()
                    .contains(
                        DateTime(yearArr[selectedYearIndex]!, index + 1))) {
                  setState(() {
                    selectedMonthIndex = index;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: selectedMonthIndex == index
                          ? SPColors.mainColor
                          : Provider.of<ParaService>(context, listen: false)
                                  .listParaDateTime
                                  .keys
                                  .toList()
                                  .contains(DateTime(
                                      yearArr[selectedYearIndex]!, index + 1))
                              ? SPColors.whiteColor
                              : Colors.grey),
                  child: Text(monthArrShort[index] ?? "",
                      style: TextStyle(
                          color: selectedMonthIndex == index
                              ? Colors.black
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget YearSelector() {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List<Widget>.generate(yearArr.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedYearIndex = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: selectedYearIndex == index
                          ? Colors.amber
                          : SPColors.lighten(SPColors.blueColor, 0.2)),
                  child: Text("      ${yearArr[index].toString()}      ",
                      style: TextStyle(
                          color: selectedYearIndex == index
                              ? Colors.black
                              : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
