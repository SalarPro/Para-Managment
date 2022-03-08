import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:intl/intl.dart';
import 'package:pare/src/custom_views/CategoryIcon.dart';

class AddNewPara extends StatefulWidget {
  const AddNewPara({Key? key}) : super(key: key);

  @override
  _AddJobState createState() => _AddJobState();
}

class _AddJobState extends State<AddNewPara> {
  String? amountType = 'spend';

  String iconCodePoint = '';
  // Initial Selected Value
  String dropdownvalue = 'USd';
  Color spendButtonColor = Colors.white;
  Color incomeButtonColor = Colors.transparent;
  // List of items in our dropdown menu
  var items = [
    'USd',
    'IQd',
  ];
  Color currentColor = Color(0xFF1A237E);

  final _formKey = GlobalKey<FormState>();
  late FocusNode focusnode;

  final amountOfMoneyController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime createdAtController = DateTime.now();

  @override
  void initState() {
    super.initState();

    focusnode = FocusNode();
    focusnode.requestFocus();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusnode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: currentColor.toMaterialColor()),

        iconTheme: IconThemeData(color: currentColor),
        // all fields should have a value
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: currentColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0)),
                  ),
                  height: MediaQuery.of(context).size.height * 0.16,
                  //padding: const EdgeInsets.only(bottom: 26, top: 16, right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                            color: Colors.white,
                          ),
                          addMethod(context),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              child: iconCodePoint.toString() != ''
                                  ? Icon(
                                      IconData(
                                          int.parse(iconCodePoint.toString()),
                                          fontFamily: 'MaterialIcons'),
                                      color: Colors.white,
                                      size: 50,
                                    )
                                  : Container(
                                      height: 50,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white60,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white60,
                                      )),
                              onTap: () => pickIcon(context),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: amountofMoneyTextField(),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: Center(
                                child: dropDownMethod(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //title *
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Row(
                    children: [
                      const Expanded(child: Icon(Icons.sticky_note_2)),
                      Expanded(
                        flex: 8,
                        child: titleTextField(),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Row(
                    children: [
                      const Expanded(
                          child: Icon(
                        Icons.comment_bank,
                      )),
                      Expanded(
                        flex: 8,
                        child: descriptionTextField(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: InkWell(
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100))
                          .then((value) {
                        setState(() {
                          createdAtController =
                              DateTime.parse(value.toString());
                        });
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              createdAtController.isToday()
                                  ? "Today"
                                  : createdAtController.isYesterday()
                                      ? "Yesterday"
                                      : DateFormat("dd MMM")
                                          .format(createdAtController),
                            ),
                          ],
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            side:
                                const BorderSide(width: 1, color: Colors.grey),
                          ),
                          onPressed: () {
                            createdAtController.isToday()
                                ? createdAtController =
                                    DateTime.now().subtract(Duration(days: 1))
                                : createdAtController = DateTime.now();

                            setState(() {});
                          },
                          child: Text(
                              createdAtController.isToday()
                                  ? "Yesterday?"
                                  : createdAtController.isYesterday()
                                      ? "today?"
                                      : DateFormat("dd MMM")
                                          .format(createdAtController),
                              style: const TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
                  child: Center(
                    child: toggleButton(context),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    child: BlockPicker(
                      layoutBuilder: (context, colors, child) =>
                          GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: colors.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                currentColor = colors[index];
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colors[index],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: iconCodePoint.toString() != ''
                                        ? Icon(
                                            IconData(int.parse(iconCodePoint),
                                                fontFamily: 'MaterialIcons'),
                                            color: Colors.white,
                                            size: 40,
                                          )
                                        : Container()),
                              ));
                        },
                      ),
                      useInShowDialog: mounted,
                      pickerColor: currentColor,
                      onColorChanged: changeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //////////////////////
  //////////////////
  /////////////
  /////////
  //////
  ////

  Container toggleButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.0)),
      height: 50,
      width: MediaQuery.of(context).size.width * 0.7,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(CATEGORY_ROUND_SIZE)),
                        backgroundColor: spendButtonColor),
                    onPressed: () {
                      spendButtonColor = Colors.white;
                      incomeButtonColor = Colors.transparent;
                      amountType = 'spend';
                      setState(() {});
                    },
                    child: const Text(
                      "Spend",
                    )),
              ),
              Expanded(
                child: TextButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(CATEGORY_ROUND_SIZE)),
                        backgroundColor: incomeButtonColor),
                    onPressed: () {
                      spendButtonColor = Colors.transparent;
                      incomeButtonColor = Colors.white;
                      amountType = 'income';
                      setState(() {});
                    },
                    child: const Text(
                      "Income",
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField descriptionTextField() {
    return TextFormField(
      controller: descriptionController,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Write a note',
      ),
    );
  }

  TextFormField titleTextField() {
    return TextFormField(
      // focusNode: focusnode2,
      validator: (value) {
        if (value == null || value.isEmpty) {
          //  focusnode2.requestFocus();
          debugPrint(amountOfMoneyController.value.text);

          return 'please enter some text';
        }
      },

      controller: titleController,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Title',
      ),
    );
  }

  DropdownButton<String> dropDownMethod() {
    return DropdownButton(
      underline: SizedBox(),
      style: TextStyle(color: Colors.white, fontSize: 10),
      iconEnabledColor: Colors.white,
      dropdownColor: currentColor,

      value: dropdownvalue,

      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),

      onChanged: (String? newValue) {
        setState(() {
          dropdownvalue = newValue!;
        });
      },
    );
  }

  TextFormField amountofMoneyTextField() {
    return TextFormField(
      focusNode: focusnode,
      validator: (value) {
        if (value == null || value.isEmpty) {}
      },
      showCursor: false,
      style: const TextStyle(fontSize: 25, color: Colors.white),
      textAlign: TextAlign.right,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      controller: amountOfMoneyController,
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
        hintText: '0',
      ),
    );
  }

  TextButton addMethod(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
      ),
      onPressed: () {},
      // onPressed: () async {
      //   if (iconCodePoint == '') {
      //     pickIcon(context);
      //   } else if (amountOfMoneyController.value.text.isEmpty) {
      //     focusnode.requestFocus();
      //     debugPrint("=======================");
      //   } else if (_formKey.currentState!.validate() &&
      //       amountOfMoneyController.value.text.isNotEmpty) {
      //     var uid = Uuid().v1();

      //     //double? c;
      //     // final caremcy = await Caremcy().oneUSDToIQD().then((value) => c = value);

      //     final double c = 1480;

      //     Provider.of<ParaService>(context, listen: true).listPara.add(Para(
      //         uid: "1",
      //         createdAt: Timestamp.fromDate(createdAtController),
      //         amountUSD: (dropdownvalue == items[0])
      //             ? double.parse(amountOfMoneyController.value.text)
      //             : double.parse(amountOfMoneyController.value.text) / c,
      //         amountIQD: (dropdownvalue == items[1])
      //             ? double.parse(amountOfMoneyController.value.text)
      //             : double.parse(amountOfMoneyController.value.text) * c,
      //         amountOneUSDToIQD: c,
      //         amountType: amountType, // spend, income
      //         walletId: "1",
      //         categoryID: uid, //1 ... 10
      //         description: descriptionController.value.text));

      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Processing Data')),
      //     );
      //     category.add(
      //       ParaCategory(
      //           uid: uid,
      //           emoji: iconCodePoint,
      //           name: titleController.value.text,
      //           color:
      //               '#${currentColor.value.toRadixString(16).substring(2, 8)}'),
      //     );
      //     Navigator.of(context).pop();
      //   }
      // }
      // ,
      child: const Text('Add'),
    );
  }

  void pickIcon(BuildContext context) async {
    IconData? icon = await FlutterIconPicker.showIconPicker(
      context,
      iconPackModes: [IconPack.material],
    );
    if (icon != null) {
      iconCodePoint = icon.codePoint.toString();

      debugPrint(icon.codePoint.toString());
    }

    // _icon = Icon(icon);
    // _icon =Icon(IconData(int.parse(iconCodePoint), fontFamily: 'MaterialIcons'));
    setState(() {
      //debugPrint(icon!.codePoint.toString());
      // debugPrint(icon.fontFamily.toString());
    });

    // debugPrint('Picked Icon:  $icon');
  }

  void changeColor(Color color) => setState(() {
        // currentColor = Color( int.parse( color.value.toString() ));
        // currentColor = FFRHexColor('#${color.value.toRadixString(16).substring(2, 8)}');
        currentColor = color;
        debugPrint('#${currentColor.value.toRadixString(16).substring(2, 8)}');
        debugPrint(color.value.toString());
      });
}

extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == this.day &&
        now.month == this.month &&
        now.year == this.year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.day == this.day &&
        yesterday.month == this.month &&
        yesterday.year == this.year;
  }
}

extension ColorConversion on Color {
  MaterialColor toMaterialColor() {
    final List strengths = <double>[.05];
    final Map<int, Color> swatch = {};
    final r = red, g = green, b = blue;

    for (var i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final strength in strengths) {
      final ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(value, swatch);
  }
}
