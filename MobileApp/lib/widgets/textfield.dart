import 'package:flutter/material.dart';

import '../theme/colors.dart';

class Textfield extends StatefulWidget {
  late String text;
  late String hintText;
  late TextEditingController controller;
  bool password=false;

  bool isHidden = true;
  Textfield({Key? key,
  required this.text,
    required this.controller,
    required this.hintText,
    required this.password,
    //required this.isHidden,
  }) : super(key: key);

  @override
  State<Textfield> createState() => _TextfieldState();
}

class _TextfieldState extends State<Textfield> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Align(
          alignment: Alignment.topLeft,
          child: Text(
            widget.text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff535353)),
          ),
        ),
        if (widget.password==false)
          TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: GetColor.white1,
            hintText: widget.hintText,
            hintStyle: TextStyle(color: GetColor.secondaryGrey),
          ),
        ),
        if (widget.password==true)
          TextField(
            controller: widget.controller,
            obscureText: widget.isHidden,
            decoration: InputDecoration(
              filled: true,
              fillColor: GetColor.white1,
              hintText: '**************',
              hintStyle: TextStyle(color: GetColor.secondaryGrey),
              suffixIcon: IconButton(
                icon: widget.isHidden
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                onPressed: () {
                  setState(() {
                    widget.isHidden = !widget.isHidden;
                  });
                },
              ),
            ),
          ),

      ],
    );
  }
}
