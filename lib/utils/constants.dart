import 'package:flutter/material.dart';

Size kScreenSize(context) => MediaQuery.of(context).size;
double kScreenHeight(context) => MediaQuery.of(context).size.height;
double kScreenWidth(context) => MediaQuery.of(context).size.width;

String kLogoTag = 'logoTag';

Color kBackgroundColor = const Color(0xFFF9F9F9);

Duration ktimeout = const Duration(seconds: 30);

class EditObject {
  EditAction action;
  dynamic object;

  EditObject({required this.action, this.object});
}

enum EditAction { add, edit, delete }

String? kadminName;
