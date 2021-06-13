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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Container(
          width: 100.w,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2,
              ),
              child: Text(
                text,
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ),
        ),
      ),
      onPressed: callBack,
    );
  }
}
