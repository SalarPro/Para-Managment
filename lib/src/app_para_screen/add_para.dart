import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pare/src/category_editor_screen/category_editor.dart';
import 'package:pare/src/category_editor_screen/category_item_editor.dart';
import 'package:pare/src/custom_views/CategoryIcon.dart';
import 'package:pare/src/custom_views/CategoryIconSmall.dart';
import 'package:pare/src/models/category_model.dart';
import 'package:pare/src/models/para_model.dart';
import 'package:pare/src/provider/para_service.dart';
import 'package:pare/src/tools/SPColors.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';

class AddPara extends StatefulWidget {
  static String routeName = 'add_para';
  const AddPara({Key? key}) : super(key: key);

  @override
  State<AddPara> createState() => _AddParaState();
}

class _AddParaState extends State<AddPara> {
  String selectedValue = ccParaType == 'usd' ? 'USD' : 'IQD';
  List<String> items = [
    'USD',
    'IQD',
  ];

  bool? yesterday = false;

  correct cPara = correct();
  ParaCategory cParaCategory = ParaCategory();

  TextEditingController _paraTextController = TextEditingController(text: "0");
  TextEditingController _noteTextController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Spend"),
    1: Text("Income")
  };

  List<ParaCategory> showCategories = [];

  @override
  Widget build(BuildContext context) {
    showCategories = listCategory
        .where((element) =>
            element.type == 'both' ||
            element.type ==
                (segmentedControlGroupValue == 0 ? "spend" : "income"))
        .toList();

    cPara.createdAt ??= Timestamp.now();
    cPara.updatedAt ??= Timestamp.now();
    cPara.uid ??= Uuid().v1().toString();

    if (cParaCategory.uid == null) cParaCategory = listCategory[0];

    return Scaffold(
      backgroundColor: SPColors.blueColor,
      body: SafeArea(
        child: Container(
          color: SPColors.whiteColor,
          child: Stack(
            children: [
              ListView(children: [
                topViewContainer(),
                noteTextFelid(),
                dateTextFelid(),
                spendIncomeWidget(),
                paraCategoriesView(),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, CategoryEditor.routeName);
                    },
                    child: const Text('Manage Categories'))
              ]),
              Positioned(right: 10, left: 10, bottom: 50, child: addButton()),
              /*Visibility(
                visible: isLoading,
                child: Container(
                  color: Colors.black45,
                  child: Container(
                    child: AnimatedOpacity(
                      opacity: isLoading ? 1 : 0,
                      duration: Duration(milliseconds: 200),
                      child: Lottie.asset(
                        'assets/lf20_qufi1zre.json',
                        repeat: true,
                        animate: true,
                      ),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Container topViewContainer() {
    return Container(
      decoration: BoxDecoration(
        color: SPColors.blueColor,
        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(25),
        //   topRight: Radius.circular(25),
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                size: 30,
                color: Colors.white70,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: CategoryIcon(category: cParaCategory),
              ),
              addParaTextField(),
              dropDownWidgetForUSDandIQD()
            ],
          ),
        ],
      ),
    );
  }

  Container spendIncomeWidget() {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 10, left: 50, right: 50),
      width: MediaQuery.of(context).size.width * 0.70,
      child: CupertinoSlidingSegmentedControl(
          padding: EdgeInsets.all(5),
          groupValue: segmentedControlGroupValue,
          children: myTabs,
          onValueChanged: (i) {
            setState(() {
              segmentedControlGroupValue = i is int ? i as int : 0;
            });
          }),
    );
  }

  Widget noteTextFelid() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _noteTextController,
        decoration: InputDecoration(
          icon: FaIcon(FontAwesomeIcons.penFancy),
          border: InputBorder.none,
          hintText: 'Write your note',
        ),
        style: TextStyle(),
      ),
    );
  }

  Widget dateTextFelid() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          FaIcon(FontAwesomeIcons.calendarAlt),
          GestureDetector(
            onTap: () async {
              _showDatePicker(context);
              // final DateTime? picked = await showDatePicker(
              //     context: context,
              //     initialDate: cPara.createdAt!.toDate(),
              //     firstDate: DateTime(2015, 8),
              //     lastDate: DateTime(2101));
              // if (picked != null && picked != cPara.createdAt!.toDate())
              //   setState(() {
              //     cPara.createdAt = Timestamp.fromDate(picked);
              //     yesterday = null;
              //   });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                DateFormat('yy MMM dd').format(cPara.createdAt!.toDate()),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              setState(() {
                if (yesterday != null) {
                  yesterday = !yesterday!;
                } else {
                  yesterday = false;
                }

                cPara.createdAt = yesterday!
                    ? Timestamp.fromDate(
                        DateTime.now().add(const Duration(days: -1)))
                    : Timestamp.now();
              });
            },
            child: Container(
              padding: EdgeInsets.only(top: 4, bottom: 4, left: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: SPColors.blueColor),
              child: Text(
                yesterday == null
                    ? "Today"
                    : yesterday!
                        ? "Today"
                        : "Yesterday",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget addParaTextField() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _paraTextController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.end,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          style: const TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget dropDownWidgetForUSDandIQD() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 52, 94),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value as String;
            });
          },
          icon: const Icon(
            FontAwesomeIcons.arrowDown,
            size: 12,
          ),
          iconSize: 12,
          iconEnabledColor: const Color.fromARGB(255, 0, 52, 94),
          iconDisabledColor: Colors.grey,
          buttonHeight: 24,
          buttonWidth: 55,
          buttonPadding: const EdgeInsets.only(left: 10, right: 6),
          buttonDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CATEGORY_ROUND_SIZE),
            color: Colors.white,
          ),
          buttonElevation: 2,
          itemHeight: 40,
          itemPadding: const EdgeInsets.only(left: 10, right: 14),
          // dropdownMaxHeight: 200,
          // dropdownWidth: 100,
          dropdownPadding: null,
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          dropdownElevation: 8,
          // scrollbarRadius: const Radius.circular(40),
          // scrollbarThickness: 6,
        ),
      ),
    );
  }

  Widget paraCategoriesView() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0, left: 8, right: 8, top: 8),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [Colors.blue[500]!, Colors.purple[500]!],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                  mainAxisExtent: 80),
              scrollDirection: Axis.horizontal,
              itemCount: showCategories.length,
              itemBuilder: (context, index) {
                var e = showCategories[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      cParaCategory = showCategories[index];
                    });
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),

                              gradient: categoryIconBackground(e),
                              // color: Colors.blue[900],
                              borderRadius:
                                  BorderRadius.circular(CATEGORY_ROUND_SIZE),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                IconData(int.parse(e.emoji.toString()),
                                    fontFamily: 'MaterialIcons'),
                                color: categoryIconColor(e),
                                size: 40,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            // child: FittedBox(
                            child: Text(
                              e.name ?? "",
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          // )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  void _showDatePicker(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 270,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    color: Colors.grey[100],
                    child: Row(
                      children: [
                        Spacer(),
                        CupertinoButton(
                          padding: EdgeInsets.all(0),
                          child: Text('OK'),
                          onPressed: () => Navigator.of(ctx).pop(),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: cPara.createdAt!.toDate(),
                        dateOrder: DatePickerDateOrder.ymd,
                        onDateTimeChanged: (val) {
                          setState(() {
                            yesterday = null;
                            cPara.createdAt = Timestamp.fromDate(val);
                          });
                        }),
                  ),
                ],
              ),
            ));
  }

  Widget addButton() {
    return RoundedLoadingButton(
        child: Text('Save', style: TextStyle(color: Colors.white)),
        controller: _btnController,
        onPressed: onSave,
        successIcon: Icons.check,
        successColor: Colors.green);
  }

  //save to firebase
  onSave() async {
    var money = 0.0;

    try {
      money = double.parse(_paraTextController.text);
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(_paraTextController.text);
      _btnController.stop();
      setState(() {});
      _onBasicWaitingAlertPressed(
          title:
              "enter the value of ${segmentedControlGroupValue == 0 ? "Spend" : "Income"}");
      return;
    }

    // if (_paraTextController.value is double || _paraTextController.value is int)

    // else {
    //   _btnController.stop();
    //   setState(() {});
    //   _onBasicWaitingAlertPressed(
    //       title:
    //           "enter the value of ${segmentedControlGroupValue == 0 ? "Spend" : "Income"}");
    //   return;
    // }

    cPara.amountOneUSDToIQD =
        Provider.of<ParaService>(context, listen: false).uSDtoIQD;

    if (cPara.amountOneUSDToIQD == null) {
      _btnController.stop();
      setState(() {});
      _onBasicWaitingAlertPressed(title: "Check your internet connection");
      return;
    }

    if (segmentedControlGroupValue == 0) {
      cPara.amountType = 'spend';
    } else {
      cPara.amountType = 'income';
    }

    if (money == 0) {
      _btnController.stop();
      setState(() {});
      _onBasicWaitingAlertPressed(
          title:
              "Enter the value of ${segmentedControlGroupValue == 0 ? "Spend" : "Income"}");
      return;
    }

    if (selectedValue == 'USD') {
      cPara.amountUSD = money;
      cPara.amountIQD = cPara.amountOneUSDToIQD! * cPara.amountUSD!;
    } else {
      cPara.amountIQD = money;
      cPara.amountUSD = cPara.amountIQD! / cPara.amountOneUSDToIQD!;
    }

    cPara.inputCurrency = selectedValue.toLowerCase();
    cPara.description = _noteTextController.text;

    cPara.walletId = 'main_wallet';

    cPara.categoryID = cParaCategory.uid;

    debugPrint(cPara.toString());

    await cPara.save();

    _btnController.success();
    setState(() {});
    setState(() {
      Timer(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    });
  }

  _onBasicWaitingAlertPressed(
      {String title = "Wrong", String body = ""}) async {
    await Alert(context: context, title: title, desc: body, buttons: [
      DialogButton(
          child: Text(
            "ok",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
          })
    ]).show();

    // Code will continue after alert is closed.
    debugPrint("Alert closed now.");
  }
}
