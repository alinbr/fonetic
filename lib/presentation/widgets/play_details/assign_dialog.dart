import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/infrastructure/dtos/character.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssignDialog extends ConsumerWidget {
  final Character character;

  const AssignDialog({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Dialog(
        backgroundColor: Theme.of(context).backgroundColor,
        child: Container(
          width: double.infinity,
          height: 200,
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(),
              ),
              Text(
                '${character.character}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 16.h,
              ),
              if (character.userId != null)
                Text("Character already assigned to: ${character.userId}"),
              if (character.userId == null)
                OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.tealAccent[700]!),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      )),
                    ),
                    onPressed: () async {
                      context
                          .read(playProvider.notifier)
                          .assignCharacter(character.character, '1');
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'assign role to me',
                      style: Theme.of(context).textTheme.button!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    )),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ));
  }
}
