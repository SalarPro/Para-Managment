import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pare/src/Analytic_views/main_analytic_view.dart';
import 'package:pare/src/custom_views/CategoryIcon.dart';
import 'package:pare/src/models/para_model.dart';
import 'package:pare/src/provider/para_service.dart';
import 'package:provider/provider.dart';

/// Icons by svgrepo.com (https://www.svgrepo.com/collection/job-and-professions-3/)
class ListOfSelectedSpend extends StatefulWidget {
  ListOfSelectedSpend(
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
  State<StatefulWidget> createState() => ListOfSelectedSpendState();
}

class ListOfSelectedSpendState extends State<ListOfSelectedSpend> {
  int touchedIndex = 2;
  List<Widget> items = [];

  calculateItems(BuildContext context) {
    List<correct> tList = [];
    items.clear();
    var paraService = Provider.of<ParaService>(context, listen: false);
    var mList = paraService.listParaDateTime[DateTime(
        yearArr[widget.selectedYear] ?? DateTime.now().year,
        widget.selectedMonth + 1)];
    if (mList == null) {
      return;
    }
    widget.totalIncome = mList.totalPriceIncome;
    widget.totalSpend = mList.totalPriceSpend;
    (widget.isSpend ? mList.itemsCategoriesSpend : mList.itemsCategoriesIncome)
        .forEach((key, value) {
      value.forEach((element) {
        tList.add(element);
      });
    });

    tList.sort(
      (a, b) {
        return -((a.createdAt!).compareTo(b.createdAt!));
      },
    );
    tList.forEach((element) {
      items.add(mainTableCell(element));
    });
  }

  @override
  Widget build(BuildContext context) {
    calculateItems(context);
    return items.length == 0
        ? Container()
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 30, bottom: 5),
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
                                Expanded(
                                  child: Text(
                                    "All items For ${yearArr[widget.selectedYear] ?? DateTime.now().year} ${monthArr[widget.selectedMonth] ?? ""}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 2000),
                height: items.length * 80,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return items[index];
                  },
                ),
              ),
            ],
          );
  }

  Widget mainTableCell(correct pare) {
    return Container(
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                  padding:
                      const EdgeInsets.only(top: 10, left: 20, right: 10, bottom: 10),
                  child: CategoryIcon(category: pare.categpry())),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pare.categpry().name ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(pare.description ?? ""),
                ],
              ),
              const Expanded(
                child: SizedBox(),
              ),
              Container(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                   const SizedBox(
                      height: 20,
                    ),
                    Text(
                      DateFormat('yy-MM-dd').format(pare.createdAt!.toDate()),
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                    Text(
                      DateFormat('hh:mma').format(pare.createdAt!.toDate()),
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            top: 18,
            child: Text(
              "${pare.amountType == "income" ? "+" : "-"} ${NumberFormat(ccParaType == 'usd' ? "#,###.#" : "#,###", "en_US").format(pare.cPare)} ${ccParaType == 'usd' ? '\$' : 'IQD'}",
              style: TextStyle(
                  color: pare.amountType == "income"
                      ? Colors.greenAccent
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
