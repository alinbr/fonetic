import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendButton extends StatelessWidget {
  final VoidCallback callBack;

  const SendButton({Key? key, required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.tealAccent[700]!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.h),
          child: Text(
            'Send line',
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(color: Colors.black, fontWeight: FontWeight.w800),
          ),
        ),
        onPressed: callBack);
  }
}
