import 'package:flutter/material.dart';
import 'package:salarycredits/values/colors.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColor.darkBlue,
      content: Text(text, style: const TextStyle(color: Colors.white),),
    ),
  );
}