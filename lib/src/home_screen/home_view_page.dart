import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pare/src/app_para_screen/add_para.dart';
import 'package:pare/src/custom_views/CategoryIcon.dart';
import 'package:pare/src/models/para_model.dart';
import 'package:pare/src/provider/para_service.dart';
import 'package:pare/src/tools/SPColors.dart';
import 'package:provider/provider.dart';

class HomeViewPage extends StatefulWidget {
  HomeViewPage({Key? key}) : super(key: key);

  @override
  State<HomeViewPage> createState() => _HomeViewPageState();
}

class _HomeViewPageState extends State<HomeViewPage> {
  bool _isVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  double popHeight = 0;

  ParaService? _paraProvider;

  bool isThereData = false;

  @override
  Widget build(BuildContext context) {
    _paraProvider ??= Provider.of<ParaService>(context, listen: true);

    return Stack(
      children: [
        Scaffold(
          body: homeViewPage(),
          floatingActionButton: FloatingActionButton(
            child: FaIcon(FontAwesomeIcons.coins),
            onPressed: () {
              Navigator.pushNamed(context, AddPara.routeName);
            },
          ),
        ),
        isThereData
            ? Container()
            : Positioned(
                bottom: -14,
                right: -18,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AddPara.routeName);
                    },
                    child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Lottie.asset('assets/tap_animation.json')),
                  ),
                ),
              )
      ],
    );
  }

  Widget homeViewPage() {
    return Stack(
      children: [
        Column(
          children: [
            topBarBalance(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _paraProvider!.paraStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(50),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child: Lottie.asset(
                              'assets/loading_wallert_coins.json')),
                    );
                  }

                  isThereData = snapshot.data!.docs.isNotEmpty;

                  if (snapshot.data!.docs.isEmpty) {
                    return Container();
                  }
                  Map<String, List<correct>> value = snapshot.data!.docs
                      .fold(<String, List<correct>>{},
                          (Map<String, List<correct>> a, b) {
                    var obj = correct.fromMap(b.data() as Map<String, dynamic>);

                    var dateID = DateFormat('yyyy-MM-dd')
                        .format((obj.createdAt ?? Timestamp.now()).toDate());

                    a.putIfAbsent(dateID, () => []).add(obj);
                    return a;
                  });

                  List<Widget> widgets = [];

                  var _totalPrice = 0.0;

                  value.forEach((key, value) {
                    var tPrice = 0.0;

                    value.forEach((e) {
                      if (e.amountType == 'spend')
                        tPrice -= e.cPare ?? 0;
                      else
                        tPrice += e.cPare ?? 0;
                    });

                    widgets.add(cell_separator_text(key, tPrice));

                    value.forEach((element) {
                      widgets.add(mainTableCell(element));
                      if (element.amountType == 'spend')
                        _totalPrice -= element.cPare ?? 0;
                      else
                        _totalPrice += element.cPare ?? 0;
                    });
                  });

                  SchedulerBinding.instance?.addPostFrameCallback((_) {
                    // add your code here.

                    _paraProvider!.setTotalPrice(_totalPrice);
                  });

                  return ListView(
                    children: widgets,
                  );
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  Container cell_separator_text(String title, double total) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: Colors.grey[300]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 2.5) - 20,
                    child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(title)),
                  ),
                  Spacer(),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 2.5) - 20,
                    child: FittedBox(
                      alignment: Alignment.centerRight,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        NumberFormat("#,###.# \$").format(total),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Slidable mainTableCell(correct pare) {
    return Slidable(
      key: ValueKey(pare.uid ?? ""),

      // The start action pane is the one at the left or the top side.
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const DrawerMotion(),

        // A pane can dismiss the Slidable.
        // dismissible: DismissiblePane(onDismissed: () {}),
        extentRatio: 0.2,

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            autoClose: true,
            onPressed: (context) async {
              await pare.delete();
            },
            backgroundColor: Color.fromARGB(255, 175, 56, 56),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      child: Stack(
        children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, right: 10, bottom: 10),
                  child: CategoryIcon(category: pare.categpry())),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pare.categpry().name ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
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
                      height: 25,
                    ),
                    Text(
                      DateFormat('yy-MM-dd').format(pare.createdAt!.toDate()),
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      DateFormat('hh:mma').format(pare.createdAt!.toDate()),
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            top: 14,
            child: FittedBox(
              child: Text(
                "${pare.amountType == "income" ? "+" : "-"} ${NumberFormat(ccParaType == 'usd' ? "#,###.#" : "#,###", "en_US").format(pare.cPare)} ${ccParaType == 'usd' ? '\$' : 'IQD'}",
                style: TextStyle(
                    color: pare.amountType == "income"
                        ? Colors.greenAccent
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container topBarBalance() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SPColors.blueColor,
              SPColors.lighten(SPColors.blueColor, 0.2)
            ]),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 20, top: 8, bottom: 4, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Text(
                "${NumberFormat("#,###.#", "en_US").format(_paraProvider!.totalPrice)} ${ccParaType == 'usd' ? '\$' : 'IQD'}",
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const Text(
              "Available Balance",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
