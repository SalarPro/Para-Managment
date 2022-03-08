
import 'package:flutter/material.dart';
import 'package:pare/src/category_editor_screen/category_item_editor.dart';
import 'package:pare/src/models/category_model.dart';

double CATEGORY_ROUND_SIZE = 20;

class CategoryIcon extends StatelessWidget {
  CategoryIcon({Key? key, required this.category}) : super(key: key);

  ParaCategory category;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: categoryIconBackground(category),
        // color: Colors.blue[900],
        borderRadius: BorderRadius.circular(CATEGORY_ROUND_SIZE),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: category.emoji == null
            ? Container()
            : Icon(
                IconData(int.parse(category.emoji.toString()),
                    fontFamily: 'MaterialIcons'),
                color: categoryIconColor(category),
                size: 40,
              ),
      ),
    );
  }
}