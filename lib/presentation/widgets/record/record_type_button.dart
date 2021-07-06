import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordTypeButton extends StatelessWidget {
  final VoidCallback callBack;
  final Icon icon;
  final String text;

  const RecordTypeButton(
      {Key? key,
      required this.callBack,
      required this.icon,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.h),
          child: Row(
            children: [
              icon,
              SizedBox(
                width: 4.w,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.button,
              ),
            ],
          ),
        ),
        onPressed: callBack);
  }
}
