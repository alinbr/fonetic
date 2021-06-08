import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/controllers/my_plays_controller.dart';
import 'package:fonetic/controllers/play_controller.dart';
import 'package:fonetic/screens/my_plays_screen.dart';

class PlayScreen extends ConsumerWidget {
  final String _playId;

  PlayScreen(this._playId);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final play = watch(playProvider(_playId));
    final playNotifier = watch(playProvider(_playId).notifier);

    return Scaffold(
        appBar: AppBar(
          title: Text('Play'),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('Delete play'),
                            content: Text(
                                'Are you sure you want to delete this play?'),
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
                                    context
                                        .read(myPlaysProvider('1').notifier)
                                        .retrievePlays();
                                    Navigator.pop(context);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute<void>(
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
                          ));
                },
                icon: Icon(Icons.delete))
          ],
        ),
        body: play.when(
            data: (play) {
              final script = playNotifier.script;
              return SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text('${script.name}'),
                      Text('${play.playStatus}'),
                      Text(play.id.toString()),
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Text(play.characters[index].character),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                    play.characters[index].userId ?? 'no user'),
                                OutlinedButton(
                                    onPressed: () async {
                                      await playNotifier.assignCharacter(
                                          play.characters[index].character,
                                          '1');
                                    },
                                    child: Text('ASSIGN TO ME'))
                              ],
                            ),
                          );
                        },
                        itemCount: play.characters.length,
                      )
                    ],
                  ),
                ),
              );
            },
            loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
            error: (e, st) => Container()));
  }
}
