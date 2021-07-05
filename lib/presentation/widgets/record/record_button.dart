import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordButton extends StatelessWidget {
  final VoidCallback callBack;

  const RecordButton({Key? key, required this.callBack}) : super(key: key);

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
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.h),
          child: Row(
            children: [
              Icon(
                Icons.fiber_manual_record,
                color: Colors.red,
              ),
              SizedBox(
                width: 4.w,
              ),
              Text(
                'RECORD',
                style: Theme.of(context).textTheme.button,
              ),
            ],
          ),
        ),
        onPressed: callBack);
  }
}
