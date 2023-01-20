import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  late double boxWidth;
  late Color boxColor;
  late Color textColor;
  late String text;
  // ignore: prefer_typing_uninitialized_variables
  late var boxFunc ;
  MyButton(
      {Key? key,
        required this.boxWidth,
        required this.boxColor,
        required this.text,
        required this.textColor,
        required this.boxFunc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boxWidth,
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: boxColor,
      ),
      child: TextButton(
          onPressed: boxFunc,
          child: Text(
            text,
            style: TextStyle(
                color: textColor, fontSize: 20.0, fontWeight: FontWeight.w600),
          )),
    );
  }
}
