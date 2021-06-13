import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/application/play_controller.dart';
import 'package:fonetic/application/script_controller.dart';
import 'package:fonetic/infrastructure/dtos/script.dart';
import 'package:fonetic/presentation/screens/record_screen.dart';
import 'package:fonetic/presentation/widgets/delete_play_dialog.dart';
import 'package:fonetic/presentation/widgets/loading_center.dart';

class PlayScreen extends ConsumerWidget {
  final String _playId;

  PlayScreen(this._playId);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final play = watch(playProvider(_playId));

    return Scaffold(
        appBar: AppBar(
          title: Text('Play'),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => DeletePlayDialog(_playId));
                },
                icon: Icon(Icons.delete))
          ],
        ),
        body: play.when(
            data: (play) {
              return SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text('${play.name}'),
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
                                play.characters[index].userId != null
                                    ? Text('${play.characters[index].userId}')
                                    : OutlinedButton(
                                        onPressed: () async {
                                          context
                                              .read(playProvider(_playId)
                                                  .notifier)
                                              .assignCharacter(
                                                  play.characters[index]
                                                      .character,
                                                  '1');
                                        },
                                        child: Text('ASSIGN TO ME'))
                              ],
                            ),
                          );
                        },
                        itemCount: play.characters.length,
                      ),
                      ElevatedButton(
                          onPressed: context
                                  .read(playProvider(_playId).notifier)
                                  .isRecordable(play)
                              ? () {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute<void>(
                                    builder: (BuildContext context) {
                                      return RecordScreen(playId: play.id!);
                                    },
                                  ));
                                }
                              : null,
                          child: Text('Start producing'))
                    ],
                  ),
                ),
              );
            },
            loading: () => LoadingCenter(),
            error: (e, st) => Container()));
  }
}
