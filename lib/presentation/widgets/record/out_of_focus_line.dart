import 'package:flutter/material.dart';
import 'package:fonetic/infrastructure/dtos/line.dart';

class OutOfFocusLine extends StatelessWidget {
  final Line line;

  const OutOfFocusLine({Key? key, required this.line}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '${line.character}: ${line.text}',
      style: Theme.of(context).textTheme.bodyText2,
      overflow: TextOverflow.clip,
      maxLines: 3,
      textAlign: TextAlign.start,
    );
  }
}
