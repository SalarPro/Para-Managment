import 'package:ffr_hex_color/ffr_hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pare/src/models/category_model.dart';
import 'package:pare/src/tools/SPColors.dart';

class CategoryItemEditor extends StatefulWidget {
  static String routeName = 'categoryEditor';
  CategoryItemEditor({Key? key}) : super(key: key);

  bool isNameAssigned = false;

  @override
  State<CategoryItemEditor> createState() => _CategoryItemEditorState();
}

class _CategoryItemEditorState extends State<CategoryItemEditor> {
  late ParaCategory paraCategory;

  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Spend"),
    1: Text("Income"),
    2: Text("Spend & Income")
  };

  TextEditingController _textFieldController = TextEditingController();

  Color currentColor = Colors.amber;
  List<Color> currentColors = [Colors.yellow, Colors.green];
  List<Color> colorHistory = [];

  void changeColor(Color color) => setState(() => currentColor = color);
  void changeColors(List<Color> colors) =>
      setState(() => currentColors = colors);

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    paraCategory = ModalRoute.of(context)!.settings.arguments as ParaCategory;
    if (!widget.isNameAssigned) {
      _textFieldController.text = paraCategory.name ?? "";
      widget.isNameAssigned = true;
      paraCategory.emoji ??= '58513';
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Spacer(),
            IconButton(
                onPressed: () async {
                  switch (segmentedControlGroupValue) {
                    case 0:
                      paraCategory.type = 'spend';
                      break;
                    case 1:
                      paraCategory.type = 'income';
                      break;
                    case 2:
                      paraCategory.type = 'both';
                      break;
                    default:
                      break;
                  }

                  paraCategory.name = _textFieldController.text;

                  await paraCategory.save(context);
                  Navigator.pop(context);
                },
                icon: FaIcon(FontAwesomeIcons.save))
          ],
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                // color: FFRHexColor(paraCategory.color ?? "#eb34db"),

                gradient: categoryIconBackground(paraCategory),
                // color: Colors.blue[900],
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                   IconData(
                      int.parse(paraCategory.emoji == null
                          ? "58513"
                          : paraCategory.emoji.toString()),
                      fontFamily: 'MaterialIcons'),
                  color: categoryIconColor(paraCategory),
                  size: 100,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              decoration: InputDecoration(
                label: Text("Category name"),

                counterText: "",
                // hintStyle: TextStyle(color: SPColors.greyText),
                border: OutlineInputBorder(),
              ),
              controller: _textFieldController,
              textAlign: TextAlign.center,
              // decoration: InputDecoration(hintText: "Category name"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
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
          ),
          Container(
            // height: 450,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColorPicker(
                  enableAlpha: false,
                  labelTypes: [],
                  pickerColor: FFRHexColor(paraCategory.color ?? '#000000'),
                  onColorChanged: (changeColor) {
                    paraCategory.color =
                        "#${changeColor.toString().substring(10, 16)}";
                    setState(() {});
                  },
                  pickerAreaBorderRadius: BorderRadius.circular(20),
                  pickerAreaHeightPercent: 0.4,
                  colorPickerWidth: MediaQuery.of(context).size.width - 40,
                  displayThumbColor: true,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      pickIcon(context);
                    },
                    child: Text('Icon')),
              )),
            ],
          )
        ],
      ),
    );
  }

  void pickIcon(BuildContext context) async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.material],
        iconColor: categoryIconColor(paraCategory),
        backgroundColor: FFRHexColor(paraCategory.color ?? "#eeeeee"));

    if (icon != null) {
      setState(() {
        paraCategory.emoji = icon.codePoint.toString();
      });
    }
  }
}

bool isDarck(Color color) {
  return (((299 * color.red) + (114 * color.blue) + (587 * color.green)) /
          1000) <
      180;
}

Color categoryIconColor(ParaCategory e) {
  return isDarck(FFRHexColor(e.color ?? "#ffffff"))
      ? Color.fromARGB(255, 245, 245, 245)
      : Color.fromARGB(255, 51, 51, 51);
}

LinearGradient categoryIconBackground(ParaCategory category) {
  return LinearGradient(colors: [
    FFRHexColor(category.color ?? "#eb34db"),
    FFRHexColor(category.color ?? "#eb34db"),
    SPColors.darken(FFRHexColor(category.color ?? "#eb34db"), 0.1)
  ], begin: Alignment.topLeft, end: Alignment.bottomRight);
}
