import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback callBack;

  const MyOutlinedButton({Key? key, required this.text, required this.callBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Text(
          text,
          style: Theme.of(context).textTheme.button,
        ),
      ),
      onPressed: callBack,
    );
  }
}
