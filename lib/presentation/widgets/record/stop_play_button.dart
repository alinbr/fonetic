import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StopPlayButton extends StatelessWidget {
  final VoidCallback callBack;

  const StopPlayButton({Key? key, required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
        ),
        child: Icon(
          Icons.stop,
          color: Colors.red,
        ),
        onPressed: callBack);
  }
}
