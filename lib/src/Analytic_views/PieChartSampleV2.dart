import 'package:ffr_hex_color/ffr_hex_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pare/src/Analytic_views/main_analytic_view.dart';
import 'package:pare/src/category_editor_screen/category_item_editor.dart';
import 'package:pare/src/custom_views/CategoryIconSmall.dart';
import 'package:pare/src/models/para_model.dart';
import 'package:pare/src/provider/para_service.dart';
import 'package:provider/provider.dart';

/// Icons by svgrepo.com (https://www.svgrepo.com/collection/job-and-professions-3/)
class PieChartSampleV2 extends StatefulWidget {
  PieChartSampleV2(
      {Key? key,
      required this.isSpend,
      required this.selectedMonth,
      required this.selectedYear})
      : super(key: key);

  int selectedMonth;
  int selectedYear;
  bool isSpend;
  double totalIncome = 0;
  double totalSpend = 0;
  @override
  State<StatefulWidget> createState() => PieChartSampleV2State();
}

class PieChartSampleV2State extends State<PieChartSampleV2> {
  int touchedIndex = 2;
  List<PieChartSectionData> items = [];

  calculateItems(BuildContext context) {
    items.clear();
    var index = 0;
    var paraService = Provider.of<ParaService>(context);

    var mList = paraService.listParaDateTime[DateTime(
        yearArr[widget.selectedYear] ?? DateTime.now().year,
        widget.selectedMonth + 1)];
    if (mList == null) {
      return;
    }

    widget.totalIncome = mList.totalPriceIncome;
    widget.totalSpend = mList.totalPriceSpend;

    var eteratable = (widget.isSpend
        ? mList.itemsCategoriesSpend
        : mList.itemsCategoriesIncome);

    if (eteratable.length == 0) {
      return;
    }

    eteratable.forEach((key, value) {
      final isTouched = index == touchedIndex;

      final radius = isTouched ? 50.0 : 40.0;

      var divistionValue =
          widget.isSpend ? mList.divisionSpend : mList.divisionIncome;

      index++;

      var tot = 0.0;

      if (value.length == 0) {
        return;
      }

      value.forEach((element) {
        tot += element.cPare!;
      });

      final fontSize =
          (tot / divistionValue) < 5 ? 0.0 : (isTouched ? 16.0 : 14.0);

      items.add(PieChartSectionData(
        color: FFRHexColor(key.color ?? "#ffffff"),
        value: tot / divistionValue,
        title: '${(tot / divistionValue).round()}%',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: categoryIconColor(key)),
        badgeWidget: CategoryIconSmall(category:key),
        badgePositionPercentageOffset: 1.9,
      ));
    });

    // return items;
  }

  @override
  Widget build(BuildContext context) {
    calculateItems(context);

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 5),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "${yearArr[widget.selectedYear] ?? DateTime.now().year} ${monthArr[widget.selectedMonth] ?? ""}",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 5),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  color: Colors.white,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Spacer(),
                          Text(
                            "Total Balance",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Spacer(),
                          Text(
                            "${NumberFormat("#,###.#").format(widget.totalIncome - widget.totalSpend)} ${ccParaType == 'usd' ? '\$' : 'IQD'}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          Spacer(),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 5),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Spacer(),
                          Text(
                            "Spend : ${NumberFormat("#,###.#").format(widget.totalSpend)} ${ccParaType == 'usd' ? '\$' : 'IQD'}",
                            // textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          // Spacer(),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Income : ${NumberFormat("#,###.#").format(widget.totalIncome)} ${ccParaType == 'usd' ? '\$' : 'IQD'}",
                            // textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          // Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 5),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            color: Colors.white,
            child: AspectRatio(
              aspectRatio: 1.2,
              child: items.length == 0
                  ? Center(
                      child: Stack(
                        children: [
                          Lottie.asset('assets/data_analitics_2.json'),
                          Positioned(
                              bottom: 15,
                              left: 0,
                              right: 0,
                              child: Text(
                                "There is no data to show",
                                textAlign: TextAlign.center,
                              ))
                        ],
                      ),
                    )
                  : PieChart(
                      PieChartData(
                          pieTouchData: PieTouchData(touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            if (pieTouchResponse == null) return;
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                      .touchedSection?.touchedSectionIndex ??
                                  0;
                            });
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 35,
                          startDegreeOffset: 0,
                          sections: items),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
