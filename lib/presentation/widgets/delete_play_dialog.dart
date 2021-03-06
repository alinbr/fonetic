import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/my_plays_controller.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/presentation/screens/my_plays_screen.dart';

class DeletePlayDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final playNotifier = watch(playProvider.notifier);

    return AlertDialog(
      title: Text('Delete play'),
      content: Text('Are you sure you want to delete this play?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w400),
            )),
        TextButton(
            onPressed: () {
              playNotifier.deletePlay();
              context.read(myPlaysProvider('1').notifier).retrievePlays();
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return MyPlaysScreen();
                },
              ));
            },
            child: Text(
              'Yes',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w400),
            ))
      ],
    );
  }
}
