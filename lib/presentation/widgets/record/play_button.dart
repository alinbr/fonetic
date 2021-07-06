import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayButton extends StatelessWidget {
  final VoidCallback callBack;

  const PlayButton({Key? key, required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
        ),
        child: Icon(
          Icons.play_arrow_sharp,
          color: Colors.green,
          size: 48.h,
        ),
        onPressed: callBack);
  }
}
