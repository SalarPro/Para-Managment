import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pare/src/category_editor_screen/category_item_editor.dart';
import 'package:pare/src/custom_views/CategoryIcon.dart';
import 'package:pare/src/models/category_model.dart';
import 'package:pare/src/provider/para_service.dart';
import 'package:pare/src/tools/SPColors.dart';
import 'package:pare/src/tools/new_user_data.dart';
import 'package:pare/src/tools/utility.dart';
import 'package:uuid/uuid.dart';

class CategoryEditor extends StatefulWidget {
  static String routeName = 'category_editor';
  CategoryEditor({Key? key}) : super(key: key);

  @override
  State<CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<CategoryEditor> {
  TextEditingController _textFieldController = TextEditingController();

  String iconCodePoint = '';
  //ParaCategory nParaCategory = ParaCategory();

  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Spend"),
    1: Text("Income"),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: SPColors.blueColor,
          child: FaIcon(FontAwesomeIcons.plus),
          onPressed: () {
            var nParaCategory = ParaCategory();
            nParaCategory.uid = Uuid().v1().toString();

            Navigator.pushNamed(context, CategoryItemEditor.routeName,
                arguments: nParaCategory);
            //showAlert(context);
          }),
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Categories"),
            const Spacer(),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('app_version_control')
                  .doc('features')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Container();
                }
                if (((snapshot.data!.data()
                        as Map<String, dynamic>)['resetCategory'] as bool) ==
                    false) {
                  return Container();
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          {
                            var result = await showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(
                                    'Are you sure you want to Add the default preset of category'),
                                content: const Text(
                                    'You can only delete the category that you are not used in any spend or income'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('NO'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'reset'),
                                    child: const Text('Yes Add Default'),
                                  ),
                                ],
                              ),
                            );

                            Utility.progress(context);
                            if (result == 'reset') {
                              await NewUserData().getCategoryList(context);
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: Icon(Icons.refresh))
                  ],
                );
              },
            )
          ],
        ),
        backgroundColor: SPColors.blueColor,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 43),
            child: ListView.builder(
              itemCount: listCategory.length,
              itemBuilder: (context, index) {
                if (segmentedControlGroupValue == 0 &&
                    listCategory[index].type == 'income') {
                  return Container();
                } else if (segmentedControlGroupValue == 1 &&
                    listCategory[index].type == 'spend') {
                  return Container();
                }
                return TextButton(
                  // style: ButtonStyle(f),
                  onPressed: () {
                    Navigator.pushNamed(context, CategoryItemEditor.routeName,
                        arguments: listCategory[index]);

                    // nParaCategory = category[index];
                    // showAlert(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: CategoryIcon(listCategory[index]),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 15,
            right: 15,
            top: 5,
            child: CupertinoSlidingSegmentedControl(
                padding: EdgeInsets.all(5),
                groupValue: segmentedControlGroupValue,
                children: myTabs,
                onValueChanged: (i) {
                  setState(() {
                    segmentedControlGroupValue = i is int ? i : 0;
                  });
                }),
          )
        ],
      ),
    );
  }

  Widget CategoryIcon(ParaCategory category) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: categoryIconBackground(category),
            // color: Colors.blue[900],
            borderRadius:
                BorderRadius.all(Radius.circular(CATEGORY_ROUND_SIZE)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              IconData(int.parse(category.emoji.toString()),
                  fontFamily: 'MaterialIcons'),
              color: categoryIconColor(category),
              size: 40,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(left: 10, bottom: 4),
                child: Text(
                  category.name ?? "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                )),
            Container(
                padding: EdgeInsets.only(left: 11),
                child: Text(
                  category.type ?? "Spend",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                )),
          ],
        ),
      ],
    );
  }
}
