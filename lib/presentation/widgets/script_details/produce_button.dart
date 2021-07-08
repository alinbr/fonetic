import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProduceButton extends StatelessWidget {
  final VoidCallback callBack;

  ProduceButton({required this.callBack});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.tealAccent[700]!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          )),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Text(
            'Record it!',
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        onPressed: callBack);
  }
}
