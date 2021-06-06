import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonetic/controllers/play_controller.dart';

class MyPlaysScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final myPlays = watch(playProvider('1'));

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('My plays'),
        ),
        body: myPlays.when(
            data: (data) {
              return ListView.builder(
                itemBuilder: (ctx, i) {
                  return Text(data[i].playStatus.toString());
                },
                itemCount: data.length,
              );
            },
            loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
            error: (error, _) => Container()));
  }
}
