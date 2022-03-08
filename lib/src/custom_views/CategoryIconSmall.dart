
import 'package:flutter/material.dart';
import 'package:pare/src/category_editor_screen/category_item_editor.dart';
import 'package:pare/src/custom_views/CategoryIcon.dart';
import 'package:pare/src/models/category_model.dart';


class CategoryIconSmall extends StatelessWidget {
  CategoryIconSmall({Key? key, required this.category}) : super(key: key);

  ParaCategory category;
  @override
  Widget build(BuildContext context) {
    return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        decoration: BoxDecoration(
          gradient: categoryIconBackground(category),
          // color: Colors.blue[900],
          borderRadius: BorderRadius.circular(CATEGORY_ROUND_SIZE),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(
            IconData(int.parse(category.emoji.toString()),
                fontFamily: 'MaterialIcons'),
            color: categoryIconColor(category),
            size: 24,
          ),
        ),
      ),
      SizedBox(
        width: 50,
        child: Text(
          category.name ?? "",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10),
        ),
      )
    ],
  );
  }
}