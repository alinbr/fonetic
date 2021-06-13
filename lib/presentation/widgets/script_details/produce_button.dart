import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProduceButton extends StatelessWidget {
  final VoidCallback callBack;

  ProduceButton({required this.callBack});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 18.h),
          child: Text(
            'Produce',
            style: Theme.of(context).textTheme.button,
          ),
        ),
        onPressed: callBack);
  }
}
